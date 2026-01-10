package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uName = request.getParameter("username");
        String uPass = request.getParameter("password"); // Hashed by CryptoJS in JSP
        String uFull = request.getParameter("fullname");
        String uEmail = request.getParameter("email");
        String uPhone = request.getParameter("phone");
        String uAddr = request.getParameter("address");

        // SQL order matches your CREATE TABLE script exactly
        String sql = "INSERT INTO users (username, password, full_name, phone, address, email, role) VALUES (?, ?, ?, ?, ?, ?, 'customer')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, uName);
            pst.setString(2, uPass);
            pst.setString(3, uFull);
            pst.setString(4, uPhone);
            pst.setString(5, uAddr);
            pst.setString(6, uEmail);

            pst.executeUpdate();
            response.sendRedirect("login.jsp?msg=Account Created! Please Login.");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}