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
    <style>
        /* Specific Styles for Menu Layout */
        body { background-color: #f4f1ea; }

        .header-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .food-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.08);
            overflow: hidden;
            transition: transform 0.2s;
            display: flex;
            flex-direction: column;
        }
        .food-card:hover { transform: translateY(-5px); }

        .food-img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-bottom: 1px solid #f0f0f0;
        }

        .food-info { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; }
        .food-cat { font-size: 0.8rem; color: #999; text-transform: uppercase; letter-spacing: 0.5px; }
        .food-name { font-size: 1.1rem; color: #8B4513; margin: 5px 0; font-weight: 700; }
        .food-price { font-size: 1.2rem; color: #28a745; font-weight: bold; margin-bottom: 15px; }

        .btn-add {
            margin-top: auto; /* Pushes button to bottom */
            background-color: #8B4513;
            color: white;
            padding: 10px;
            text-align: center;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: background 0.3s;
        }
        .btn-add:hover { background-color: #A0522D; }

        .cart-badge {
            background-color: #ff9800;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="header-nav">
    <h2 style="margin:0; color:#8B4513;">Guan Heng Menu</h2>
    <div>
        <a href="profile.jsp" style="margin-right: 15px; color:#555; text-decoration:none;">My Profile</a>
        <a href="cart.jsp" class="cart-badge">Cart (<%= cartCount %>)</a>
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