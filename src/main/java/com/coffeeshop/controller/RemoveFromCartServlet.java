package com.coffeeshop.controller;

import com.coffeeshop.model.CartItem;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RemoveFromCartServlet", value = "/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Get the Product ID to remove
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int productId = Integer.parseInt(idStr);

            // 2. Get the Cart
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                // 3. Find and Remove the item
                for (int i = 0; i < cart.size(); i++) {
                    if (cart.get(i).getProduct().getId() == productId) {
                        cart.remove(i);
                        break; // Stop after removing (avoids errors)
                    }
                }
                // 4. Update Session
                session.setAttribute("cart", cart);
            }
        }

        // 5. Go back to cart page
        response.sendRedirect("cart.jsp");
    }
}