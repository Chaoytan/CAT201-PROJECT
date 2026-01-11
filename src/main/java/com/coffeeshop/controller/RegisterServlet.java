package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import com.coffeeshop.util.HashUtil;

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
        String plainPass = request.getParameter("password"); // Hashed by CryptoJS in JSP
        String uFull = request.getParameter("fullname");
        String uEmail = request.getParameter("email");
        String uPhone = request.getParameter("phone");
        String uAddr = request.getParameter("address");

        String hashedPass = HashUtil.hashSHA256(plainPass);
        // SQL order matches your CREATE TABLE script exactly
        String sql = "INSERT INTO users (username, password, full_name, phone, address, email, role) VALUES (?, ?, ?, ?, ?, ?, 'customer')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, uName);
            pst.setString(2, hashedPass);
            pst.setString(3, uFull);
            pst.setString(4, uPhone);
            pst.setString(5, uAddr);
            pst.setString(6, uEmail);

            pst.executeUpdate();
            response.sendRedirect("login.jsp?msg=Account Created! Please Login.");

        } catch (SQLException e) {
            String errorMessage = "Registration failed.";

            // Check for "Unique Constraint" error code (00001)
            if (e.getErrorCode() == 1) {
                errorMessage = "Username or Email already exists! Please try another.";
            } else {
                errorMessage += " Error: " + e.getMessage();
            }

            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}