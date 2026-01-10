package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

// 1. Ensure the URL mapping is easy to use
@WebServlet(name = "DeleteFeedbackServlet", value = "/DeleteFeedbackServlet")
public class DeleteFeedbackServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement stmt = con.prepareStatement("DELETE FROM feedback WHERE id = ?");
            stmt.setString(1, id);
            stmt.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }

        // 2. Redirect back to the LIST page, not the form page
        response.sendRedirect("view-feedback.jsp");
    }
}