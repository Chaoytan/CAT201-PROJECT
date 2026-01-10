<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/index.css">
</head>
<body>

<nav class="navbar" style="display: flex; justify-content: space-between; align-items: center; padding: 0 20px;">

    <div class="brand-name">
        <i class="fa-solid fa-layer-group"></i> KOPITIAM ADMIN
    </div>

    <div class="nav-actions" style="display: flex; gap: 20px; align-items: center;">

        <a href="main.jsp" style="text-decoration: none; color: white; font-weight: bold; font-size: 1.1rem; display: flex; align-items: center; gap: 8px; transition: color 0.3s;">
            <i class="fa-solid fa-house"></i> Home
        </a>

        <div class="user-profile">
            <i class="fa-solid fa-circle-user"></i> Hello, <%= (session.getAttribute("currentUser") != null) ? ((com.coffeeshop.model.User)session.getAttribute("currentUser")).getUsername() : "Admin" %>
        </div>

    </div>

</nav>

<div class="main-content">

    <div class="welcome-section">
        <h1>Overview</h1>
        <p>Welcome back. Here is what's happening at your restaurant today.</p>
    </div>

    <div class="action-container">
        <a href="Admin-Menu.jsp" class="action-card">
            <i class="fa-solid fa-utensils"></i>
            <span>Menu Management</span>
        </a>

        <a href="view-feedback.jsp" class="action-card">
            <i class="fa-solid fa-comments"></i>
            <span>Feedback Inbox</span>
        </a>

        <a href="visualize.jsp" class="action-card">
            <i class="fa-solid fa-comments"></i>
            <span>Data visualize</span>
        </a>
    </div>

    <div class="stats-container">

        <a href="ViewOrdersServlet" style="text-decoration: none; color: inherit;">
            <div class="stat-card blue-accent">
                <div class="icon-box"><i class="fa-solid fa-clipboard-check"></i></div>
                <div class="text-box">
                    <%
                        int orderCount = 0;
                        try {
                            // USE YOUR HELPER CLASS!
                            Connection con = DBConnection.getConnection();

                            // Count today's orders
                            String sql = "SELECT COUNT(*) FROM ORDERS WHERE TRUNC(ORDER_DATE) = TRUNC(SYSDATE)";
                            PreparedStatement stmt = con.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            if(rs.next()){
                                orderCount = rs.getInt(1);
                            }
                            con.close();
                        } catch(Exception e){
                            e.printStackTrace();
                        }
                    %>
                    <h3><%= orderCount %></h3>
                    <p>Orders Today</p>
                </div>
            </div>
        </a>

        <a href="RevenueDetailsServlet" style="text-decoration: none; color: inherit;">
            <div class="stat-card green-accent">
                <div class="icon-box"><i class="fa-solid fa-dollar-sign"></i></div>
                <div class="text-box">
                    <%
                        double totalRevenue = 0.0;
                        try {
                            // USE YOUR HELPER CLASS!
                            Connection con = DBConnection.getConnection();

                            // Sum total amount (Handle NULL with NVL if no orders yet)
                            String sql = "SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE TRUNC(ORDER_DATE) = TRUNC(SYSDATE)";
                            PreparedStatement stmt = con.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            if(rs.next()){
                                totalRevenue = rs.getDouble(1);
                            }
                            con.close();
                        } catch(Exception e){
                            e.printStackTrace();
                        }
                    %>
                    <h3>$<%= String.format("%.2f", totalRevenue) %></h3>
                    <p>Revenue Today</p>
                </div>
            </div>
        </a>

    </div>
</div>

<div class="footer">
    © 2026 Kopitiam Admin System
</div>

</body>
</html>