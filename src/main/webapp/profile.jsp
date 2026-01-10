<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Check if user is logged in
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
%>
<script>
    alert("Please log in in order to proceed");
    window.location.href = "login.jsp";
</script>
<%
        return;
    }
%>

<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Extra styles for the Order Table */
        .order-history-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            font-size: 0.9em;
        }
        .order-table th, .order-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .order-table th {
            background-color: #f8f9fa;
            color: #333;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

<div class="profile-container">

    <div class="profile-header">
        <h2>My Profile</h2>
        <p>Welcome back, ${currentUser.username}!</p>
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
        <label>Saved Address</label>
        <textarea rows="3" readonly>${currentUser.address}</textarea>
    </div>

    <div class="order-history-section">
        <h3><i class="fa-solid fa-clock-rotate-left"></i> Order History</h3>

        <table class="order-table">
            <thead>
            <tr>
                <th style="width: 10%;">Order ID</th>
                <th style="width: 20%;">Date</th>
                <th style="width: 40%;">Items Ordered</th> <th style="width: 15%;">Total</th>
                <th style="width: 15%;">Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                boolean hasOrders = false;
                Connection con = null;
                try {
                    con = DBConnection.getConnection();
                    // 1. Get Orders
                    String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY id DESC";
                    PreparedStatement pst = con.prepareStatement(sql);
                    pst.setInt(1, currentUser.getId());
                    ResultSet rs = pst.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                    while(rs.next()){
                        hasOrders = true;
                        int oId = rs.getInt("id");
                        Timestamp oDate = rs.getTimestamp("order_date");
                        double oTotal = rs.getDouble("total_amount");
                        String oStatus = rs.getString("status");

                        // Badge Color Logic
                        String badgeClass = "status-pending";
                        if("Completed".equalsIgnoreCase(oStatus)) badgeClass = "status-completed";
                        if("Cancelled".equalsIgnoreCase(oStatus)) badgeClass = "status-cancelled";
            %>
            <tr>
                <td style="vertical-align: top;"><strong>#<%= oId %></strong></td>
                <td style="vertical-align: top; color: #666;"><%= sdf.format(oDate) %></td>

                <td style="vertical-align: top;">
                    <ul style="list-style: none; padding: 0; margin: 0; font-size: 0.95em; color: #444;">
                        <%
                            // 2. Nested Query to get Items for THIS Order
                            try {
                                String itemSql = "SELECT p.name, oi.quantity FROM order_items oi " +
                                        "JOIN products p ON oi.product_id = p.id " +
                                        "WHERE oi.order_id = ?";
                                PreparedStatement pstItem = con.prepareStatement(itemSql);
                                pstItem.setInt(1, oId);
                                ResultSet rsItem = pstItem.executeQuery();

                                while(rsItem.next()){
                                    String pName = rsItem.getString("name");
                                    int qty = rsItem.getInt("quantity");
                        %>
                        <li style="margin-bottom: 2px;">• <%= pName %> <span style="color:#888;">(x<%= qty %>)</span></li>
                        <%
                                }
                                rsItem.close();
                                pstItem.close();
                            } catch (Exception e) { out.print("<li>Error loading items</li>"); }
                        %>
                    </ul>
                </td>

                <td style="vertical-align: top; font-weight: bold; color: #d4af37;">
                    RM <%= String.format("%.2f", oTotal) %>
                </td>
                <td style="vertical-align: top;">
                    <span class="badge <%= badgeClass %>"><%= oStatus %></span>
                </td>
            </tr>
            <%
                    }
                    // Don't close connection here, wait for finally or end of page
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if(con != null) try { con.close(); } catch(Exception e){}
                }

                if (!hasOrders) {
            %>
            <tr>
                <td colspan="5" style="text-align:center; color:#999; padding:30px;">
                    <i class="fa-solid fa-utensils" style="font-size: 30px; margin-bottom: 10px; display:block;"></i>
                    No orders found. Go buy some coffee! ☕
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

</div>

</body>
</html>