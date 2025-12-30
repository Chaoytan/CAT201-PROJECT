<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
%>
<html>
<head>
    <title>Welcome | Guan Heng Kopitiam</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/main.css">
</head>
<body>

<div class="header-nav">
    <div class="brand-title">Guan Heng Kopitiam</div>
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
    <h1 class="hero-title">Delicious Local Coffee</h1>
    <p class="hero-subtitle">Experience the best Nasi Lemak and Kopi O in town.</p>

    <div class="card-row">

        <div class="action-card">
            <div class="card-content">
                <span class="card-icon">🍔</span>
                <h3>Order Food</h3>
                <p>Browse our menu and order online.</p>
            </div>
            <a href="menu.jsp" class="btn-action">View Menu</a>
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
                <p>Manage your address and settings.</p>
            </div>
            <a href="profile.jsp" class="btn-action btn-account">My Account</a>
        </div>
        <% } %>

    </div> </div>

<% String msg = request.getParameter("msg"); if (msg != null) { %>
<script>alert("<%= msg %>");</script>
<% } %>

</body>
</html>