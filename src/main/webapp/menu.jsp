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
            // Fetch products
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

            <a href="javascript:void(0);" onclick="addToCart(<%= id %>)" class="btn-add">
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

<script>
    function addToCart(productId) {
        // 1. Send Background Request
        fetch('AddToCartServlet?id=' + productId)
            .then(response => {
                if (response.ok) {
                    // 2. Success! Show a small popup (Toast)
                    showToast("Item added to cart!");

                    // 3. Update the "Cart (X)" number automatically
                    let cartBtn = document.querySelector(".cart-btn");
                    let currentText = cartBtn.innerText;
                    // Extract number, add 1, put it back
                    let newText = currentText.replace(/(\d+)/, function(n){ return parseInt(n)+1; });
                    cartBtn.innerText = newText;
                } else {
                    alert("Failed to add item.");
                }
            })
            .catch(error => console.error('Error:', error));
    }

    // A simple "Toast" notification function
    function showToast(message) {
        // Create the box
        let toast = document.createElement("div");
        toast.innerText = message;
        toast.style.position = "fixed";
        toast.style.bottom = "20px";
        toast.style.right = "20px";
        toast.style.background = "#28a745"; // Green
        toast.style.color = "white";
        toast.style.padding = "10px 20px";
        toast.style.borderRadius = "5px";
        toast.style.boxShadow = "0 2px 10px rgba(0,0,0,0.2)";
        toast.style.zIndex = "1000";

        // Add to screen
        document.body.appendChild(toast);

        // Remove after 3 seconds
        setTimeout(() => {
            toast.remove();
        }, 3000);
    }
</script>

</body>
</html>