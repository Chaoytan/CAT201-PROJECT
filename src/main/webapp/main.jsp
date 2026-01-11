<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>
<%
    // 1. FORBID BROWSER CACHING
    // This forces the browser to ask the server for a fresh page every time you click "Back"
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    User currentUser = (User) session.getAttribute("currentUser");
%>
<html>
<head>
    <title>Welcome | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/main.css">

    <script>
        // 2. BF-CACHE KILLER
        // This script detects if the page is loaded from the browser's "frozen" memory (Back Button)
        window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
                // If loaded from cache, force a hard reload from the server
                window.location.reload();
            }
        });
    </script>
</head>
<body>

<div class="header-nav">
    <div class="brand-title">Guan Heng Coffee Shop</div>
    <div class="nav-links">
        <% if (currentUser == null) { %>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
        <% } else { %>
        <a href="profile.jsp">Hi, <%= currentUser.getUsername() %></a>
        <a href="LogoutServlet">Logout</a>
        <% } %>
    </div>
</div>

<div class="hero-section">
    <h1 class="hero-title">Delicious Local Food</h1>
    <p class="hero-subtitle">Experience the best Local Food and Drinks in town.</p>

    <div class="card-row">

        <div class="action-card">
            <div class="card-content">
                <span class="card-icon">🍚</span>
                <h3>Order Food</h3>
                <p>Browse our menu and order online.</p>
            </div>
            <a href="menu.jsp" class="btn-action btn-menu">View Menu</a>
            <a href="cart.jsp" class="btn-action btn-cart">Cart</a>
        </div>

        <div class="action-card">
            <div class="card-content">
                <span class="card-icon">💬</span>
                <h3>Community</h3>
                <p>See what others are saying.</p>
            </div>
            <a href="view-feedback.jsp" class="btn-action btn-secondary">Read Feedback</a>
            <a href="feedback.jsp" class="btn-action btn-danger">Submit Feedback</a>
        </div>

        <% if (currentUser != null) { %>
        <div class="action-card">
            <div class="card-content">
                <span class="card-icon">👤</span>
                <h3>My Profile</h3>
                <p>Manage your profile and view orders.</p>
            </div>
            <a href="profile.jsp" class="btn-action btn-account">My Account</a>
        </div>
        <% } %>

        <%
            // Check if user is logged in AND is an admin
            if (currentUser != null && "admin".equals(currentUser.getRole())) {
        %>
        <div class="action-card" style="border: 2px solid #8B4513;">
            <div class="card-content">
                <span class="card-icon">⚙️</span> <h3>Admin Panel</h3>
                <p>Manage orders, menu items, and feedback.</p>
            </div>
            <a href="index.jsp" class="btn-action" style="background-color: #333;">Go to Dashboard</a>
        </div>
        <% } %>

    </div>
</div>

<%
    // 3. FLASH MESSAGE LOGIC
    String feedbackMsg = (String) session.getAttribute("feedbackMsg");
    if (feedbackMsg != null) {
%>
<script>
    // Display the message once
    alert("<%= feedbackMsg %>");
</script>
<%
        // 4. CONSUME THE MESSAGE
        // It is removed from the server immediately after it is sent to the browser
        session.removeAttribute("feedbackMsg");
    }
%>

</body>
</html>