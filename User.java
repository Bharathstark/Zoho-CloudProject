/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.adventnet.servicedesk.utils;

import java.io.IOException;
import javax.servlet.http.Cookie;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.adventnet.servicedesk.utils.DataAccessUtil;
import com.adventnet.ds.query.Criteria;
import com.adventnet.ds.query.Column;
import com.adventnet.persistence.DataObject;
import com.adventnet.ds.query.QueryConstants;
import com.adventnet.ds.query.Table;
import com.adventnet.ds.query.SelectQueryImpl;
import com.adventnet.persistence.Row;
import java.io.PrintWriter;
import java.util.Iterator;

/**
 *
 * @author admin
 */
public class User extends HttpServlet {

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
            if (request.getParameter("option").equalsIgnoreCase("verifyLog")) {
                verifyLogin(request, response);

            } else if (request.getParameter("option").equalsIgnoreCase("viewData")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(viewData(request));
                out.flush();
            } else if (request.getParameter("option").equalsIgnoreCase("delete")) {
                Criteria delcr = new Criteria(Column.getColumn("BUSERS", "UID"), request.getParameter("uid"), QueryConstants.EQUAL);
                DataAccessUtil.getInstance().delete(delcr);
            }
        } catch (Exception e) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, "in the user get method", e);
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
            postData(request);
        } catch (Exception ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, "in the user post method", ex);

        }

    }

    private void verifyLogin(HttpServletRequest request, HttpServletResponse response) throws JSONException, IOException ,Exception{
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("BUSERS"));
        sql.addSelectColumn(Column.getColumn("BUSERS", "*"));
        Criteria vcr1 = new Criteria(Column.getColumn("BUSERS", "UID"), request.getParameter("ID"), QueryConstants.EQUAL);
        sql.setCriteria(vcr1);
        DataObject users = DataAccessUtil.getInstance().get(sql);
        Criteria upcr = new Criteria(Column.getColumn("BUSERS", "PASS"), request.getParameter("PASS"), QueryConstants.EQUAL);
        Row row = users.getRow("BUSERS", upcr);
        PrintWriter out = response.getWriter();
        JSONObject obj = new JSONObject();
        if (row != null) {
            Cookie ck = new Cookie("user", request.getParameter("ID"));
            response.addCookie(ck);
            obj.put("VAL", "SUCCESS");
            out.print(obj);
            out.flush();
        } else {
            obj.put("VAL", "FAILURE");
            out.print(obj);
            out.flush();
        }

    }

    private JSONArray viewData(HttpServletRequest request) throws Exception {
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("BUSERS"));
        sql.addSelectColumn(Column.getColumn("BUSERS", "*"));
        DataObject centers = DataAccessUtil.getInstance().get(sql);
        Iterator iter = centers.getRows("BUSERS");
        JSONArray json = new JSONArray();
        while (iter.hasNext()) {
            Row row = (Row) iter.next();
            JSONObject obj = row.getAsJSON();
            json.put(obj);
        }
        return json;
    }

    private void postData(HttpServletRequest request) throws Exception{
        SelectQueryImpl sql = new SelectQueryImpl(Table.getTable("BUSERS"));
        sql.addSelectColumn(Column.getColumn("BUSERS", "*"));
        DataObject users = DataAccessUtil.getInstance().get(sql);
        Row row = new Row("BUSERS");
        row.set("UID", request.getParameter("uid"));
        row.set("UNAME", request.getParameter("uname"));
        row.set("PASS", request.getParameter("pass"));
        row.set("LOCATION", request.getParameter("uloc"));
        row.set("NOF",0);
        row.set("SIZE",0);
        users.addRow(row);
        DataAccessUtil.getInstance().update(users);
        System.out.println(users);
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
