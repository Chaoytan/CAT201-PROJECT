package com.coffeeshop.controller;

import com.coffeeshop.model.User;
import com.coffeeshop.util.DBConnection;
import com.coffeeshop.util.HashUtil; // Import the new utility
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uEmail = request.getParameter("email");
        String plainPassword = request.getParameter("password");

        // Hash the incoming plain text password
        String hashedPass = HashUtil.hashSHA256(plainPassword);

        String sql = "SELECT id, username, full_name, phone, address, email, role FROM users WHERE email = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, uEmail);
            pst.setString(2, hashedPass);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("email"),
                            rs.getString("role")
                    );

                    HttpSession session = request.getSession();
                    session.setAttribute("currentUser", user);

                    response.sendRedirect("main.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid Email or Password!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}