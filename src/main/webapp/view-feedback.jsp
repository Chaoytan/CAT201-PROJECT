<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
<head>
    <title>Customer Feedback | Guan Heng Kopitiam</title>
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

<div class="feedback-container">
    <h2 class="section-title">What our customers are saying</h2>

    <%
        try {
            Connection con = DBConnection.getConnection();
            // Select all feedback, newest first
            String sql = "SELECT * FROM feedback ORDER BY id DESC";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, h:mm a");

            while (rs.next()) {
                String subject = rs.getString("subject");
                String message = rs.getString("message");
                Timestamp ts = rs.getTimestamp("submitted_at");
                String dateStr = (ts != null) ? sdf.format(ts) : "Unknown Date";

                int rating = rs.getInt("rating");
                if (rating == 0) rating = 5;
    %>

    <div class="feedback-card">
        <div class="fb-header">
            <span><%= dateStr %></span>
        </div>

        <div class="star-display" style="color: #FFD700; font-size: 1.5rem; margin: 10px 0;">
            <%
                // Loop 5 times to print stars
                for(int i=1; i<=5; i++) {
                    if(i <= rating) {
            %>
            <span>★</span> <%
        } else {
        %>
            <span style="color: #e0e0e0;">★</span> <%
                }
            }
        %>
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