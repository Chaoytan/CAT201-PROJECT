<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<%
    // 初始化变量
    int ordersToday = 0;
    double totalRevenue = 0.0;
    int newComplaints = 0;

    Connection conn = null;
    try {
        // 使用和你 Admin-menu 一致的连接方式
        conn = DBConnection.getConnection();

        // 1. 获取今日订单数 (修正了 TRUNC 逻辑，确保匹配 Oracle 日期)
        Statement stmt1 = conn.createStatement();
        ResultSet rs1 = stmt1.executeQuery("SELECT COUNT(*) FROM orders WHERE TRUNC(order_date) = TRUNC(SYSDATE)");
        if (rs1.next()) {
            ordersToday = rs1.getInt(1);
        }

        // 2. 获取总营收 (只有已完成的订单才算营收，或者你可以去掉 WHERE 子句算总数)
        Statement stmt2 = conn.createStatement();
        ResultSet rs2 = stmt2.executeQuery("SELECT SUM(total_amount) FROM orders");
        if (rs2.next()) {
            totalRevenue = rs2.getDouble(1);
        }

        // 3. 获取反馈总数
        Statement stmt3 = conn.createStatement();
        ResultSet rs3 = stmt3.executeQuery("SELECT COUNT(*) FROM feedback");
        if (rs3.next()) {
            newComplaints = rs3.getInt(1);
        }

    } catch (Exception e) {
        // 如果报错，直接在页面顶端显示，方便排查
        out.println("");
    } finally {
        if (conn != null) try { conn.close(); } catch(SQLException e) {}
    }
%>
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

<nav class="navbar">
    <div class="brand-name">
        <i class="fa-solid fa-layer-group"></i> KOPITIAM ADMIN
    </div>
    <div class="user-profile">
        <i class="fa-solid fa-circle-user"></i> Hello, Albert
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

        <a href="Feedback.jsp" class="action-card">
            <i class="fa-solid fa-comments"></i>
            <span>Feedback Inbox</span>
        </a>
    </div>

    <div class="stats-container">

        <div class="stat-card blue-accent">
            <div class="icon-box"><i class="fa-solid fa-clipboard-check"></i></div>
            <div class="text-box">
                <h3><%= ordersToday %></h3>
                <p>Orders Today</p>
            </div>
        </div>

        <div class="stat-card green-accent">
            <div class="icon-box"><i class="fa-solid fa-dollar-sign"></i></div>
            <div class="text-box">
                <h3>RM <%= String.format("%.2f", totalRevenue) %></h3>
                <p>Total Revenue</p>
            </div>
        </div>

        <div class="stat-card red-accent">
            <div class="icon-box"><i class="fa-solid fa-circle-exclamation"></i></div>
            <div class="text-box">
                <h3><%= newComplaints %></h3>
                <p>New Complaints</p>
            </div>
        </div>

    </div>
</div>

<div class="footer">
    © 2026 Kopitiam Admin System
</div>

</body>
</html>