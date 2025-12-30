package com.coffeeshop.controller;

import com.coffeeshop.model.User;
import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(name = "FeedbackServlet", value = "/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Get User (Who is complaining?)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Get Form Data
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        try {
            Connection con = DBConnection.getConnection();

            // 3. Insert into Database
            // We insert NULL for image_url since we are ignoring it
            String sql = "INSERT INTO feedback (user_id, subject, message, image_url, status) VALUES (?, ?, ?, NULL, 'New')";
            PreparedStatement pst = con.prepareStatement(sql);

            pst.setInt(1, user.getId());
            pst.setString(2, subject);
            pst.setString(3, message);

            pst.executeUpdate();
            con.close();

            // 4. Success Redirect
            // You can reuse the order-success page or make a simple alert
            response.sendRedirect("index.jsp?msg=Feedback Submitted! Thank you.");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}