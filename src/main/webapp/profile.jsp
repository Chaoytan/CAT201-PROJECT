<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Session Security Check
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
%>
<script>
    alert("Please log in to view your profile.");
    window.location.href = "login.jsp";
</script>
<%
        return;
    }
%>

<html>
<head>
    <title>My Profile | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .order-history-section { margin-top: 30px; padding-top: 20px; border-top: 2px solid #f4f4f4; }
        .order-table { width: 100%; border-collapse: collapse; margin-top: 15px; background: #fff; }
        .order-table th { background-color: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #dee2e6; }
        .order-table td { padding: 12px; border-bottom: 1px solid #eee; vertical-align: top; }
        .badge { padding: 5px 10px; border-radius: 20px; font-size: 0.8em; font-weight: 600; text-transform: uppercase; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .item-list { list-style: none; padding: 0; margin: 0; font-size: 0.9em; color: #555; }
        .price-total { font-weight: bold; color: #2c3e50; }
    </style>
</head>
<body>

<div class="profile-container">
    <div class="profile-header">
        <h2><i class="fa-solid fa-user-circle"></i> My Profile</h2>
        <p>Manage your account and view your history</p>
    </div>

    <div class="user-details-card">
        <div class="form-group">
            <label>Username</label>
            <input type="text" value="${currentUser.username}" readonly>
        </div>
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" value="${currentUser.fullName}" readonly>
        </div>
        <div class="form-group">
            <label>Email Address</label>
            <input type="text" value="${currentUser.email}" readonly>
        </div>
        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" value="${currentUser.phone}" readonly>
        </div>
        <div class="form-group">
            <label>Delivery Address</label>
            <textarea rows="2" readonly>${currentUser.address}</textarea>
        </div>
    </div>

    <div class="order-history-section">
        <h3><i class="fa-solid fa-bag-shopping"></i> Recent Orders</h3>
        <table class="order-table">
            <thead>
            <tr>
                <th>Order ID</th>
                <th>Date</th>
                <th>Items</th>
                <th>Total</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                boolean hasOrders = false;
                // Try-with-resources ensures resources are closed automatically
                String orderSql = "SELECT id, total_amount, order_date, status FROM orders WHERE user_id = ? ORDER BY id DESC";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement pst = con.prepareStatement(orderSql)) {

                    pst.setInt(1, currentUser.getId());
                    try (ResultSet rs = pst.executeQuery()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

                        while(rs.next()){
                            hasOrders = true;
                            int oId = rs.getInt("id");
                            String status = rs.getString("status");

                            String badgeClass = "status-pending";
                            if("Completed".equalsIgnoreCase(status)) badgeClass = "status-completed";
                            if("Cancelled".equalsIgnoreCase(status)) badgeClass = "status-cancelled";
            %>
            <tr>
                <td>#<%= oId %></td>
                <td><%= sdf.format(rs.getTimestamp("order_date")) %></td>
                <td>
                    <ul class="item-list">
                        <%
                            // Nested retrieval for items
                            String itemSql = "SELECT p.name, oi.quantity FROM order_items oi " +
                                    "JOIN products p ON oi.product_id = p.id " +
                                    "WHERE oi.order_id = ?";
                            try (PreparedStatement pstItem = con.prepareStatement(itemSql)) {
                                pstItem.setInt(1, oId);
                                try (ResultSet rsItem = pstItem.executeQuery()) {
                                    while(rsItem.next()) {
                        %>
                        <li><%= rsItem.getString("name") %> x<%= rsItem.getInt("quantity") %></li>
                        <%
                                    }
                                }
                            }
                        %>
                    </ul>
                </td>
                <td class="price-total">RM <%= String.format("%.2f", rs.getDouble("total_amount")) %></td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
            </tr>
            <%
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='5' style='color:red;'>System error loading orders.</td></tr>");
                }

                if (!hasOrders) {
            %>
            <tr>
                <td colspan="5" style="text-align:center; padding: 40px; color: #999;">
                    No orders yet. Time for a coffee? <br>
                    <a href="main.jsp" style="color: #d4af37; text-decoration: underline;">Browse Menu</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <div class="action-buttons" style="margin-top:20px;">
        <a href="edit-profile.jsp" class="btn btn-edit">Edit Details</a>
        <a href="LogoutServlet" class="btn btn-danger">Log Out</a>
        <a href="main.jsp" class="btn btn-link-plain">Back to Home</a>
    </div>

</body>
</html>