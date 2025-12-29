package com.coffeeshop.controller;

import com.coffeeshop.model.CartItem;
import com.coffeeshop.model.User;
import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet(name = "PlaceOrderServlet", value = "/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (user == null || cart == null || cart.isEmpty()) {
            response.sendRedirect("menu.jsp");
            return;
        }

        String address = request.getParameter("address");

        // Calculate Total
        double totalAmount = 0;
        for (CartItem item : cart) { totalAmount += item.getTotalPrice(); }

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            // 1. Insert into ORDERS table
            // We use 'generatedKeys' to get the new Order ID back immediately
            String orderSql = "INSERT INTO orders (user_id, total_amount, delivery_address, status) VALUES (?, ?, ?, 'Pending')";
            PreparedStatement pstOrder = con.prepareStatement(orderSql, new String[]{"id"}); // Request the generated ID

            pstOrder.setInt(1, user.getId());
            pstOrder.setDouble(2, totalAmount);
            pstOrder.setString(3, address);
            pstOrder.executeUpdate();

            // 2. Get the new Order ID
            ResultSet rs = pstOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // 3. Insert into ORDER_ITEMS table (Loop through cart)
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES (?, ?, ?, ?)";
            PreparedStatement pstItem = con.prepareStatement(itemSql);

            for (CartItem item : cart) {
                pstItem.setInt(1, orderId);
                pstItem.setInt(2, item.getProduct().getId());
                pstItem.setInt(3, item.getQuantity());
                pstItem.setDouble(4, item.getProduct().getPrice());
                pstItem.addBatch(); // Group them together for speed
            }
            pstItem.executeBatch(); // Run all inserts at once

            // 4. CLEAR THE CART from Session
            session.removeAttribute("cart");

            // 5. Success!
            response.sendRedirect("order-success.jsp?id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Order Failed: " + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}