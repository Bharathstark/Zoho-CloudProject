/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.adventnet.servicedesk.utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.adventnet.servicedesk.utils.DataAccessUtil;
import com.adventnet.ds.query.QueryConstants;
import com.adventnet.ds.query.Criteria;
import com.adventnet.ds.query.Column;
import com.adventnet.persistence.DataObject;
import com.adventnet.ds.query.Table;
import com.adventnet.ds.query.SelectQueryImpl;
import com.adventnet.persistence.Row;
import com.adventnet.ds.query.Join;
import java.util.Iterator;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author admin
 */
public class FileUpload extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String choice=request.getParameter("option");
            if(choice.equalsIgnoreCase("viewDataUser"))
            {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(viewUserData(request));
                out.flush();
            }
            else if(choice.equalsIgnoreCase("download"))
            {
                
            }
            else if(choice.equalsIgnoreCase("delete"))
            {
                Criteria delcr = new Criteria(Column.getColumn("STOREDFILES", "UID"), request.getParameter("uid"), QueryConstants.EQUAL);
                DataAccessUtil.getInstance().delete(delcr.and(new Criteria(Column.getColumn("STOREDFILES", "FILEID"),request.getParameter("fileid"), QueryConstants.EQUAL)));
                
            }

        } catch (Exception e) {
            Logger.getLogger(FileUpload.class.getName()).log(Level.SEVERE, null, e);
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("inside the post method of file uploadz");
            String fname = request.getParameter("fname");
            String name = request.getParameter("uid");
            int fsize =Integer.parseInt(request.getParameter("fsize").toString());
            String content = request.getParameter("file");
            String cid=null;
            SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("CENTERS"));
            sql.addSelectColumn(Column.getColumn("CENTERS", "CID"));
            sql.addSelectColumn(Column.getColumn("CENTERS", "SIZE"));
            sql.addSelectColumn(Column.getColumn("CENTERS", "LOCATION"));
            Criteria sicr=new Criteria(Column.getColumn("CENTERS","SIZE"), fsize,QueryConstants.GREATER_EQUAL);
            sql.setCriteria(sicr);
            Join join = new Join("CENTERS", "BUSERS", new Criteria(Column.getColumn("CENTERS", "LOCATION"), Column.getColumn("BUSERS", "LOCATION"), QueryConstants.EQUAL), Join.INNER_JOIN);
            sql.addJoin(join);
            sql.setCriteria(sicr.and(new Criteria(Column.getColumn("BUSERS", "UID"), name, QueryConstants.EQUAL)));
            DataObject dataObject = DataAccessUtil.getInstance().get(sql);
            System.out.println(dataObject);
            if (dataObject.getRow("CENTERS") == null) {
                System.out.println("inside no own data center");
                sql = new SelectQueryImpl(Table.getTable("CENTERS"));
                sql.addSelectColumn(Column.getColumn("CENTERS", "CID"));
                sql.addSelectColumn(Column.getColumn("CENTERS", "SIZE"));
                sql.addSelectColumn(Column.getColumn("CENTERS", "LOCATION"));
                sql.setCriteria(new Criteria(Column.getColumn("CENTERS", "SIZE"), fsize, QueryConstants.GREATER_EQUAL));
                dataObject = DataAccessUtil.getInstance().get(sql);
            }
            Row row = dataObject.getRow("CENTERS");
            if (row != null) {
                cid = (String) row.get("CID").toString();
                System.out.println("caling insert of file on" + cid);
                insert(name, cid, fname, fsize, content,"o");
            }
            else
            {
                System.out.println("NOT ENOUGH SPACE IN STORING ORIGINAL");
            }
            System.out.println("inserting the replica file");
            sql = new SelectQueryImpl(Table.getTable("CENTERS"));
            sql.addSelectColumn(Column.getColumn("CENTERS", "CID"));
            sql.addSelectColumn(Column.getColumn("CENTERS", "SIZE"));
            sql.addSelectColumn(Column.getColumn("CENTERS", "LOCATION"));
            sicr=new Criteria(Column.getColumn("CENTERS","SIZE"), fsize,QueryConstants.GREATER_EQUAL);
            sql.setCriteria(sicr.and( new Criteria(Column.getColumn("CENTERS", "CID"),cid, QueryConstants.NOT_EQUAL)));
            dataObject = DataAccessUtil.getInstance().get(sql);
            row = dataObject.getRow("CENTERS");
            if (row != null) {
                cid = (String) row.get("CID").toString();
                System.out.println("caling insert of file on" + cid);
                insert(name, cid, fname, fsize, content,"r");
            }
            else
            {
                System.out.println("NOT ENOUGH SPACE IN DATACENTERS FOR STORING REPLICA");
            }
        } catch (Exception e) {
            Logger.getLogger(FileUpload.class.getName()).log(Level.SEVERE, "in the file upload post method", e);
        }
    }

    public void insert(String name, String cid, String fname, int fsize, String content, String o) throws SQLException, Exception {
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("STOREDFILES"));
        sql.addSelectColumn(Column.getColumn("STOREDFILES", "*"));
        DataObject store = DataAccessUtil.getInstance().get(sql);
        Row row = new Row("STOREDFILES");
        row.set("FILENAME", fname);
        row.set("FILE", content);
        row.set("CREATEDBY", name);
        row.set("FILESIZE", fsize);
        row.set("STOREDBY", cid);
        row.set("TYPE",o);
        store.addRow(row);
        DataAccessUtil.getInstance().update(store);
        updateCenters(cid,fsize);
        updateBusers(name,fsize);
    }
     
    private void updateCenters(String cid,int size) throws Exception
    {          
        System.out.println("inside update centers");
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("CENTERS"));
        sql.addSelectColumn(Column.getColumn("CENTERS", "*"));
        DataObject centers = DataAccessUtil.getInstance().get(sql);
        Criteria upcr = new Criteria(Column.getColumn("CENTERS", "CID"),cid, QueryConstants.EQUAL);
        Row row = centers.getRow("CENTERS", upcr);
        System.out.println(row);
        if (row != null) {
            row.set("SIZE",Integer.parseInt(row.get("SIZE").toString())-size);
            row.set("NOF",Integer.parseInt(row.get("NOF").toString())+1);
            centers.updateRow(row);
            DataAccessUtil.getInstance().update(centers);
        }

    }
    private void updateBusers(String uid,int size) throws Exception
    {
        System.out.println("inside update Busers");
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("BUSERS"));
        sql.addSelectColumn(Column.getColumn("BUSERS", "*"));
        DataObject busers = DataAccessUtil.getInstance().get(sql);
        Criteria upcr = new Criteria(Column.getColumn("BUSERS", "UID"),uid, QueryConstants.EQUAL);
        Row row = busers.getRow("BUSERS", upcr);
        System.out.println(row);
        if (row != null) {
            row.set("SIZE",Integer.parseInt(row.get("SIZE").toString())+size);
            row.set("NOF",Integer.parseInt(row.get("NOF").toString())+1);
            busers.updateRow(row);
            DataAccessUtil.getInstance().update(busers);
        }
    }
    
    private JSONArray viewUserData(HttpServletRequest request) throws Exception
    {
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("STOREDFILES"));
        sql.addSelectColumn(Column.getColumn("STOREDFILES", "FILEID"));
        sql.addSelectColumn(Column.getColumn("STOREDFILES", "FILENAME"));
        sql.addSelectColumn(Column.getColumn("STOREDFILES", "FILESIZE"));
        sql.addSelectColumn(Column.getColumn("STOREDFILES", "TYPE"));
        sql.addSelectColumn(Column.getColumn("STOREDFILES", "CREATEDBY"));
        Criteria sicr=new Criteria(Column.getColumn("STOREDFILES","CREATEDBY"),request.getParameter("ID"),QueryConstants.EQUAL);
        sql.setCriteria(sicr.and( new Criteria(Column.getColumn("STOREDFILES", "TYPE"),"o", QueryConstants.EQUAL)));
        DataObject store = DataAccessUtil.getInstance().get(sql);
        Iterator iter = store.getRows("STOREDFILES");
        JSONArray json = new JSONArray();
        while (iter.hasNext()) {
            Row row = (Row) iter.next();
            JSONObject obj = row.getAsJSON();
            json.put(obj);
        }
        return json;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
