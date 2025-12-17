package com.coffeeshop.controller;

import com.coffeeshop.model.User;
import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Get Current User Session (To get role, email, username which don't change)
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
        String newPass = request.getParameter("newPassword");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement pst;

            // 3. Check if Password field is empty
            if (newPass == null || newPass.trim().isEmpty()) {
                // CASE A: Update Info ONLY (Keep old password)
                String sql = "UPDATE users SET full_name=?, phone=?, address=? WHERE id=?";
                pst = con.prepareStatement(sql);
                pst.setString(1, newName);
                pst.setString(2, newPhone);
                pst.setString(3, newAddr);
                pst.setInt(4, currentUser.getId());
            } else {
                // CASE B: Update Info AND Password
                String sql = "UPDATE users SET full_name=?, phone=?, address=?, password=? WHERE id=?";
                pst = con.prepareStatement(sql);
                pst.setString(1, newName);
                pst.setString(2, newPhone);
                pst.setString(3, newAddr);
                pst.setString(4, newPass); // Save new password
                pst.setInt(5, currentUser.getId());
            }

            pst.executeUpdate();

            // 4. CRITICAL: Update the Session Object!
            // If we don't do this, the website will still show the OLD name until logout.
            // We recreate the User object with the NEW data.
            User updatedUser = new User(
                    currentUser.getId(),
                    currentUser.getUsername(),
                    newName,               // New Name
                    newPhone,              // New Phone
                    newAddr,               // New Address
                    currentUser.getEmail(),
                    currentUser.getRole()
            );
            session.setAttribute("currentUser", updatedUser);

            // 5. Done
            response.sendRedirect("profile.jsp?msg=Profile Updated Successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating profile: " + e.getMessage());
        }
    }
}