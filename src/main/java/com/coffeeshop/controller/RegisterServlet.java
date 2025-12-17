package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uName = request.getParameter("username");
        String uPass = request.getParameter("password");
        String uFull = request.getParameter("fullname");
        String uPhone = request.getParameter("phone");
        String uAddr = request.getParameter("address");
        String uEmail = request.getParameter("email");

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO users (username, password, full_name, phone, address, email, role) VALUES (?, ?, ?, ?, ?, ?, 'customer')";

            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, uName);
            pst.setString(2, uPass);
            pst.setString(3, uFull);
            pst.setString(4, uPhone);
            pst.setString(5, uAddr);
            pst.setString(6, uEmail);

            pst.executeUpdate();

            // Success -> Go to Login
            response.sendRedirect("login.jsp?msg=Account Created! Please Login.");


        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
