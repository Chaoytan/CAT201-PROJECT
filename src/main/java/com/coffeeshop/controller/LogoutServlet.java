package com.coffeeshop.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", value = "/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Fetch the current session (if it exists)
        HttpSession session = request.getSession(false); // 'false' means don't create a new one if none exists

        if (session != null) {
            // 2. Destroy it! This removes 'currentUser' and everything else.
            session.invalidate();
        }

        // 3. Send them back to Login Page with a message
        response.sendRedirect("login.jsp?msg=You have been logged out successfully.");
    }
}