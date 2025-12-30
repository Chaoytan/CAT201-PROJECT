<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="com.coffeeshop.model.CartItem" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // 1. Get Cart from Session
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double grandTotal = 0.0;
    DecimalFormat df = new DecimalFormat("0.00");
%>

<html>
<head>
    <title>My Cart | Guan Heng Kopitiam</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/cart.css">
</head>
<body>

<div class="cart-container">
    <h2>Your Shopping Cart</h2>

    <%-- CHECK IF CART IS EMPTY --%>
    <% if (cart == null || cart.isEmpty()) { %>

    <div style="text-align: center; padding: 40px;">
        <p style="font-size: 1.2rem; color: #888;">Your cart is empty.</p>
        <a href="menu.jsp" class="btn-checkout" style="background:#8B4513;">Go to Menu</a>
    </div>

    <% } else { %>

    <%-- SHOW TABLE IF ITEMS EXIST --%>
    <table>
        <thead>
        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (CartItem item : cart) {
                double lineTotal = item.getTotalPrice();
                grandTotal += lineTotal;
        %>
        <tr>
            <td>
                <div style="display: flex; align-items: center; gap: 15px;">
                    <img src="images/<%= item.getProduct().getImageUrl() %>" class="cart-img">
                    <span><%= item.getProduct().getName() %></span>
                </div>
            </td>
            <td>RM <%= df.format(item.getProduct().getPrice()) %></td>
            <td>x <%= item.getQuantity() %></td>
            <td style="font-weight: bold; color: #8B4513;">
                RM <%= df.format(lineTotal) %>
            </td>
            <td>
                <a href="RemoveFromCartServlet?id=<%= item.getProduct().getId() %>" class="btn-remove">Remove</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <%-- FOOTER: TOTAL & CHECKOUT --%>
    <div class="checkout-section">
        <div class="total-price">Grand Total: RM <%= df.format(grandTotal) %></div>

        <a href="menu.jsp" class="btn-continue">Continue Shopping</a>

        <%-- Link to Checkout Logic (We will build this next) --%>
        <a href="checkout.jsp" class="btn-checkout">Proceed to Checkout</a>
    </div>

    <% } %>
</div>

</body>
</html>