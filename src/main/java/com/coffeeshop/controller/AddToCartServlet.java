package com.coffeeshop.controller;

import com.coffeeshop.model.CartItem;
import com.coffeeshop.model.Product;
import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddToCartServlet", value = "/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) { response.sendRedirect("menu.jsp"); return; }

        int productId = Integer.parseInt(idParam);
        HttpSession session = request.getSession();

        // 1. Get or Create the Cart List
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // 2. Check if item is already in cart
        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(item.getQuantity() + 1); // Increase Qty
                found = true;
                break;
            }
        }

        // 3. If new item, fetch from DB and add to list
        if (!found) {
            try {
                Connection con = DBConnection.getConnection();
                PreparedStatement pst = con.prepareStatement("SELECT * FROM products WHERE id = ?");
                pst.setInt(1, productId);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    Product p = new Product(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("category"),
                            rs.getDouble("price"),
                            rs.getString("image_url")
                    );
                    cart.add(new CartItem(p, 1));
                }
                con.close();
            } catch (Exception e) { e.printStackTrace(); }
        }

        // 4. Save back to session
        session.setAttribute("cart", cart);
        response.sendRedirect("menu.jsp");
    }
}