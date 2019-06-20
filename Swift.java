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
public class Swift extends HttpServlet {

    Connection con;

    public Swift() throws SQLException, ClassNotFoundException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("inside do get swift");
            if (request.getParameter("option").equalsIgnoreCase("viewData")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(getData(request));
                out.flush();
                System.out.println("here is the implementation for count by mickey");
                SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("CENTERS"));
                sql.addSelectColumn(Column.getColumn("CENTERS", "CID"));
                Join join = new Join("CENTERS", "STOREDFILES", new Criteria(Column.getColumn("CENTERS", "CID"), Column.getColumn("STOREDFILES", "STOREDBY"), QueryConstants.EQUAL), Join.INNER_JOIN);
                sql.addJoin(join);
                sql.addSelectColumn(Column.getColumn("STOREDFILES", "STOREDBY").count());
                sql.addGroupByColumn(Column.getColumn("CENTERS", "CID"));
                DataObject centers = DataAccessUtil.getInstance().get(sql);
                System.out.println(centers);
            } else if (request.getParameter("option").equalsIgnoreCase("update")) {
                System.out.println("inside update");
                updateData(request);
            }

        } catch (Exception e) {
            Logger.getLogger(Swift.class.getName()).log(Level.SEVERE, "in the swift get method", e);

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
            addData(request);
        } catch (Exception ex) {
            Logger.getLogger(Swift.class.getName()).log(Level.SEVERE, null, ex);
        }

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

    private JSONArray getData(HttpServletRequest request) throws Exception {
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("CENTERS"));
        sql.addSelectColumn(Column.getColumn("CENTERS", "*"));
        DataObject centers = DataAccessUtil.getInstance().get(sql);
        Iterator iter = centers.getRows("CENTERS");
        JSONArray json = new JSONArray();
        while (iter.hasNext()) {
            Row row = (Row) iter.next();
            JSONObject obj = row.getAsJSON();
            json.put(obj);
        }
        return json;
    }

    private void updateData(HttpServletRequest request) throws Exception {
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("CENTERS"));
        sql.addSelectColumn(Column.getColumn("CENTERS", "*"));
        DataObject centers = DataAccessUtil.getInstance().get(sql);
        Criteria upcr = new Criteria(Column.getColumn("CENTERS", "CID"), request.getParameter("cid"), QueryConstants.EQUAL);
        Row row = centers.getRow("CENTERS", upcr);
        if (row != null) {
            row.set("SIZE", request.getParameter("size"));
            centers.updateRow(row);
            DataAccessUtil.getInstance().update(centers);
        }

    }

    private void addData(HttpServletRequest request) throws Exception {
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("CENTERS"));
        sql.addSelectColumn(Column.getColumn("CENTERS", "*"));
        DataObject centers = DataAccessUtil.getInstance().get(sql);
        Row row = new Row("CENTERS");
        System.out.println("cid" + request.getParameter("cid"));
        System.out.println("cid" + request.getParameter("cname"));
        System.out.println("cid" + request.getParameter("cloc"));
        System.out.println("cid" + request.getParameter("csize"));
        row.set("CID", request.getParameter("cid"));
        row.set("CNAME", request.getParameter("cname"));
        row.set("LOCATION", request.getParameter("cloc"));
        row.set("SIZE", Integer.parseInt(request.getParameter("csize")));
        row.set("NOF", Integer.parseInt("0"));
        centers.addRow(row);
        DataAccessUtil.getInstance().update(centers);
        System.out.println(centers);
    }

}
