package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "DeleteItemServlet", value = "/delete-item")
public class DeleteItemServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        try {
            //Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DBConnection.getConnection();

            PreparedStatement stmt = con.prepareStatement("DELETE FROM PRODUCTS WHERE id = ?");
            stmt.setString(1, id);
            stmt.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("Admin-Menu.jsp");
    }
}