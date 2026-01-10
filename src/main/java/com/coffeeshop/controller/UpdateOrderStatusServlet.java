package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status"); // We will send "Completed"

        try {
            Connection con = DBConnection.getConnection();

            // Update Query
            String sql = "UPDATE orders SET status = ? WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, newStatus);
            pst.setString(2, orderId);

            pst.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Refresh the page by going back to the main Servlet
        response.sendRedirect("ViewOrdersServlet");
    }
}