package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewOrdersServlet")
public class ViewOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // We will store Orders in a list of Maps for easy display
        List<Map<String, Object>> ordersList = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            // 1. Get All Orders for Today
            String sql = "SELECT id, user_id, total_amount, status, delivery_address, order_date " +
                    "FROM orders WHERE TRUNC(order_date) = TRUNC(SYSDATE) ORDER BY id DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                Map<String, Object> order = new HashMap<>();
                int orderId = rs.getInt("id");
                order.put("id", orderId);
                order.put("userId", rs.getInt("user_id"));
                order.put("total", rs.getDouble("total_amount"));
                order.put("status", rs.getString("status"));
                order.put("address", rs.getString("delivery_address"));
                order.put("time", rs.getTimestamp("order_date"));

                // 2. Get Items for THIS Order (Nested List)
                List<String> items = new ArrayList<>();
                String itemSql = "SELECT p.name, oi.quantity FROM order_items oi " +
                        "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
                PreparedStatement psItem = con.prepareStatement(itemSql);
                psItem.setInt(1, orderId);
                ResultSet rsItem = psItem.executeQuery();

                while(rsItem.next()) {
                    items.add(rsItem.getString("name") + " (x" + rsItem.getInt("quantity") + ")");
                }
                order.put("items", items); // Store the list of items inside the order map

                ordersList.add(order);
            }
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Send the clean list to the JSP
        request.setAttribute("todayOrders", ordersList);
        request.getRequestDispatcher("ViewOrders.jsp").forward(request, response);
    }
}