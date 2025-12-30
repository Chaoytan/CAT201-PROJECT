package com.coffeeshop.controller;

import com.coffeeshop.model.User;
import com.coffeeshop.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uEmail = request.getParameter("email");
        String uPass = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, uEmail);
            pst.setString(2, uPass);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // 1. Fetch User Details from Database
                int id = rs.getInt("id");
                String username = rs.getString("username");
                String full = rs.getString("full_name");
                String phone = rs.getString("phone");
                String addr = rs.getString("address");
                String role = rs.getString("role");    // "admin" or "customer"

                // 2. Create the User Object (The "Session Key")
                // Make sure your User.java constructor matches this!
                User user = new User(id, username, full, phone, addr, uEmail, role);

                // 3. Save User to Session
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);

                // 4. THE REDIRECT LOGIC (Linking to the correct page)
                if ("admin".equalsIgnoreCase(role)) {
                    // If Admin -> Go to Dashboard
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    // If Customer -> Go to Home Page (main.jsp)
                    response.sendRedirect("main.jsp");
                }

            } else {
                // Login Failed
                request.setAttribute("errorMessage", "Invalid Email Address or Password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
