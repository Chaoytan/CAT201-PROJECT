package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import com.coffeeshop.util.PasswordUtil; // 引入工具类
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
        String uPass = request.getParameter("password"); // 这是明文
        String uFull = request.getParameter("fullname");
        String uPhone = request.getParameter("phone");
        String uAddr = request.getParameter("address");
        String uEmail = request.getParameter("email");

        // 核心修正：哈希加密
        String hashedPass = PasswordUtil.hashPassword(uPass);

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password, full_name, phone, address, email, role) VALUES (?, ?, ?, ?, ?, ?, 'customer')";

            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, uName);
            pst.setString(2, hashedPass); // 存入加密后的密文
            pst.setString(3, uFull);
            pst.setString(4, uPhone);
            pst.setString(5, uAddr);
            pst.setString(6, uEmail);

            pst.executeUpdate();
            response.sendRedirect("login.jsp?msg=Account Created! Please Login.");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}