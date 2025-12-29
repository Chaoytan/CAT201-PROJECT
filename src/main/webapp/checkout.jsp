<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.coffeeshop.model.CartItem" %>
<%@ page import="java.text.DecimalFormat" %>

<%
  // Security: Kick out if not logged in
  User currentUser = (User) session.getAttribute("currentUser");
  if (currentUser == null) {
    response.sendRedirect("login.jsp?errorMessage=Please login to checkout.");
    return;
  }

  // Security: Kick out if cart is empty
  List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
  if (cart == null || cart.isEmpty()) {
    response.sendRedirect("menu.jsp");
    return;
  }

  // Calculate Total Again
  double grandTotal = 0.0;
  for (CartItem item : cart) { grandTotal += item.getTotalPrice(); }
  DecimalFormat df = new DecimalFormat("0.00");
%>

<html>
<head>
  <title>Checkout | Guan Heng Kopitiam</title>
  <link rel="stylesheet" href="css/cart.css"> </head>
<body>

<div class="cart-container">
  <h2>Checkout Confirmation</h2>

  <form action="PlaceOrderServlet" method="post">

    <div style="margin-bottom: 20px;">
      <h3>1. Delivery Address</h3>
      <p>We will deliver to:</p>
      <textarea name="address" rows="3" style="width:100%; padding:10px;" required><%= currentUser.getAddress() %></textarea>
    </div>

    <div style="margin-bottom: 20px;">
      <h3>2. Payment Method</h3>
      <select name="payment" style="width:100%; padding:10px;">
        <option value="cash">Cash on Delivery (COD)</option>
        <option value="qr">DuitNow QR</option>
        <option value="bank">Online Banking</option>
      </select>
    </div>

    <div style="margin-bottom: 30px; border-top: 1px solid #eee; padding-top: 20px;">
      <h3>3. Order Summary</h3>
      <div style="font-size: 1.5rem; font-weight: bold; color: #8B4513;">
        Total to Pay: RM <%= df.format(grandTotal) %>
      </div>
      <p style="color:#666;">(<%= cart.size() %> items)</p>
    </div>

    <div style="text-align: right;">
      <a href="cart.jsp" class="btn-continue">Back to Cart</a>
      <button type="submit" class="btn-checkout">Confirm & Pay</button>
    </div>

  </form>
</div>

</body>
</html>