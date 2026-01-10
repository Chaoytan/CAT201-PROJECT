<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="com.coffeeshop.model.CartItem" %>

<%-- Calculate Cart Count (To show number of items in the button) --%>
<%
    List<CartItem> myCart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (myCart != null) {
        for (CartItem item : myCart) {
            cartCount += item.getQuantity();
        }
    }
%>

<html>
<head>
    <title>Menu | Guan Heng Kopitiam</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/menu.css">

</head>
<body>

<div class="header-nav">
    <div class="brand-title">Guan Heng Menu</div>

    <div class="nav-links">
        <a href="main.jsp">Home</a>

        <a href="profile.jsp">My Profile</a>

        <a href="cart.jsp" class="cart-btn">Cart (<%= cartCount %>)</a>
    </div>
</div>

<div class="menu-grid">
    <%
        try {
            Connection con = DBConnection.getConnection();
            // Fetch products (Make sure you have inserted some data into DB first!)
            String sql = "SELECT * FROM products ORDER BY category, name";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();
            DecimalFormat df = new DecimalFormat("0.00");

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String cat = rs.getString("category");
                double price = rs.getDouble("price");
                String img = rs.getString("image_url");

                // Fallback image if null
                if(img == null || img.isEmpty()) { img = "default.png"; }
    %>
    <div class="food-card">
        <img src="images/<%= img %>" class="food-img" alt="<%= name %>">

        <div class="food-details">
            <span class="category-tag"><%= cat %></span>
            <h3 class="food-name"><%= name %></h3>
            <div class="food-price">RM <%= df.format(price) %></div>

            <a href="AddToCartServlet?id=<%= id %>" class="btn-add">
                + Add to Cart
            </a>
        </div>
    </div>
    <%
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
</div>

</body>
</html>