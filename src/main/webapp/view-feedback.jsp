<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
<head>
    <title>Customer Feedback | Guan Heng Kopitiam</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/view-feedback.css">
</head>
<body>

<div class="header-nav">
    <div class="brand-title">Community Feedback</div>
    <div class="nav-links">
        <a href="main.jsp">Home</a>
        <a href="feedback.jsp" class="cart-btn" style="background:#8B4513;">Submit Feedback</a>
    </div>
</div>

<%@ page import="com.coffeeshop.model.User" %> <div class="feedback-container">
    <h2 class="section-title">What our customers are saying</h2>

    <%
        // 1. Check if current user is Admin
        User currentUser = (User) session.getAttribute("currentUser");
        boolean isAdmin = (currentUser != null && "Admin".equalsIgnoreCase(currentUser.getRole()));

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM feedback ORDER BY id DESC";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, h:mm a");

            while (rs.next()) {
                // 2. GET THE ID SO WE CAN DELETE IT
                int id = rs.getInt("id");
                String subject = rs.getString("subject");
                String message = rs.getString("message");
                Timestamp ts = rs.getTimestamp("submitted_at");
                String dateStr = (ts != null) ? sdf.format(ts) : "Unknown Date";
                int rating = rs.getInt("rating");
                if (rating == 0) rating = 5;
    %>

    <div class="feedback-card" style="position: relative;">
        <div class="fb-header" style="display: flex; justify-content: space-between; align-items: center;">
            <span><%= dateStr %></span>

            <%-- 3. ONLY SHOW DELETE BUTTON FOR ADMIN --%>
            <% if (isAdmin) { %>
            <a href="DeleteFeedbackServlet?id=<%= id %>"
               onclick="return confirm('Are you sure you want to delete this review?');"
               style="color: #ff4d4d; text-decoration: none; font-size: 1.2rem;"
               title="Delete Review">
                <i class="fa-solid fa-trash"></i> </a>
            <% } %>
        </div>

        <div class="star-display" style="color: #FFD700; font-size: 1.5rem; margin: 10px 0;">
            <% for(int i=1; i<=5; i++) {
                if(i <= rating) { %> <span>★</span> <% }
        else { %> <span style="color: #e0e0e0;">★</span> <% }
        } %>
        </div>

        <div class="fb-subject"><%= subject %></div>
        <div class="fb-message"><%= message %></div>
    </div>

    <%
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error loading feedback.</p>");
        }
    %>
</div>

</body>
</html>