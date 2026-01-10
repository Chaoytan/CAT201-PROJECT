package com.coffeeshop.controller;

import com.coffeeshop.model.User;
import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Validate Session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Get Form Data
        String newName = request.getParameter("fullname");
        String newPhone = request.getParameter("phone");
        String newAddr = request.getParameter("address");
        String newPass = request.getParameter("newPassword"); // This will be SHA-256 hashed from JSP

        // Use try-with-resources to prevent connection leaks
        try (Connection con = DBConnection.getConnection()) {

            boolean isChangingPassword = (newPass != null && !newPass.trim().isEmpty());
            String sql;
            PreparedStatement pst;

            if (!isChangingPassword) {
                // Case A: Update profile details only
                sql = "UPDATE users SET full_name = ?, phone = ?, address = ? WHERE id = ?";
                pst = con.prepareStatement(sql);
                pst.setString(1, newName);
                pst.setString(2, newPhone);
                pst.setString(3, newAddr);
                pst.setInt(4, currentUser.getId());
            } else {
                // Case B: Update profile details AND password
                sql = "UPDATE users SET full_name = ?, phone = ?, address = ?, password = ? WHERE id = ?";
                pst = con.prepareStatement(sql);
                pst.setString(1, newName);
                pst.setString(2, newPhone);
                pst.setString(3, newAddr);
                pst.setString(4, newPass);
                pst.setInt(5, currentUser.getId());
            }

            int rowsAffected = pst.executeUpdate();
            pst.close();

            if (rowsAffected > 0) {
                // 3. Update the Session Object so the UI reflects changes immediately
                User updatedUser = new User(
                        currentUser.getId(),
                        currentUser.getUsername(),
                        newName,
                        newPhone,
                        newAddr,
                        currentUser.getEmail(),
                        currentUser.getRole()
                );
                session.setAttribute("currentUser", updatedUser);

                response.sendRedirect("profile.jsp?msg=success");
            } else {
                response.sendRedirect("edit-profile.jsp?error=Update failed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Redirect back with an error message
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
        }
    }
}