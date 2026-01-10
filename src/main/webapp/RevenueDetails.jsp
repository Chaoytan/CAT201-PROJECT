<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Revenue Details - Kopitiam Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/RevenueDetails.css">
</head>
<body>

<nav class="navbar">
    <div class="brand-name"><i class="fa-solid fa-layer-group"></i> KOPITIAM ADMIN</div>
    <div class="user-profile"><i class="fa-solid fa-circle-user"></i> Hello, Albert</div>
</nav>

<div class="main-content">
    <div class="welcome-section">
        <h1>Revenue Details</h1>
        <p>View detailed revenue reports and analytics</p>
    </div>

    <div class="revenue-container">
        <div class="revenue-header">
            <a href="index.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
            <h3>Revenue Report: <%= new SimpleDateFormat("MMMM dd, yyyy").format(new Date()) %></h3>
        </div>

        <div class="revenue-cards">
            <div class="revenue-card today">
                <div class="revenue-label">Today</div>
                <div class="revenue-amount">RM<%= String.format("%.2f", request.getAttribute("today")) %></div>
                <div style="color: #888; font-size: 12px;">Daily Revenue</div>
            </div>

            <div class="revenue-card week">
                <div class="revenue-label">This Week</div>
                <div class="revenue-amount">RM<%= String.format("%.2f", request.getAttribute("week")) %></div>
                <div style="color: #888; font-size: 12px;">Last 7 Days</div>
            </div>

            <div class="revenue-card month">
                <div class="revenue-label">This Month</div>
                <div class="revenue-amount">RM<%= String.format("%.2f", request.getAttribute("month")) %></div>
                <div style="color: #888; font-size: 12px;">Monthly Revenue</div>
            </div>

            <div class="revenue-card year">
                <div class="revenue-label">This Year</div>
                <div class="revenue-amount">RM<%= String.format("%.2f", request.getAttribute("year")) %></div>
                <div style="color: #888; font-size: 12px;">Yearly Revenue</div>
            </div>
        </div>

        <div style="margin: 30px 0;">
            <h3>Filter by Date Range</h3>
            <form method="get" action="RevenueDetailsServlet">
                <label style="color: white; margin-right: 10px;">From:</label>
                <input type="date" name="startDate" class="date-filter" value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>">

                <label style="color: white; margin: 0 10px 0 20px;">To:</label>
                <input type="date" name="endDate" class="date-filter" value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>">

                <button type="submit" class="filter-btn">Filter</button>
                <a href="RevenueDetailsServlet" style="margin-left:10px; color:#aaa; font-size:12px;">Clear Filter</a>
            </form>
        </div>

        <h3>Detailed Orders</h3>
        <table class="revenue-table">
            <thead>
            <tr>
                <th>Order ID</th>
                <th>Date</th>
                <th>User ID</th>
                <th>Items</th>
                <th>Status</th>
                <th>Amount</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Map<String, Object>> list = (List<Map<String, Object>>) request.getAttribute("revenueList");

                if (list != null && !list.isEmpty()) {
                    SimpleDateFormat fmt = new SimpleDateFormat("MMM dd, yyyy HH:mm");
                    for (Map<String, Object> row : list) {
                        String status = (String) row.get("status");
                        String statusColor = "completed".equalsIgnoreCase(status) ? "#2ecc71" : "#f39c12";
            %>
            <tr onclick="window.location='ViewOrdersServlet'" style="cursor: pointer;">
                <td>#<%= row.get("id") %></td>
                <td><%= fmt.format((Date)row.get("date")) %></td>
                <td><%= row.get("userId") %></td>
                <td><%= row.get("items") %> items</td>
                <td>
                    <span style="background:<%= statusColor %>; color:white; padding:3px 8px; border-radius:10px; font-size:12px;">
                        <%= status != null ? status.toUpperCase() : "UNKNOWN" %>
                    </span>
                </td>
                <td style="color: #d4af37; font-weight: bold;">RM<%= String.format("%.2f", row.get("amount")) %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" style="text-align: center; padding: 40px; color: #888;">
                    <i class="fa-solid fa-chart-line" style="font-size: 48px; margin-bottom: 15px;"></i>
                    <p>No orders found in selected date range</p>
                </td>
            </tr>
            <% } %>
            </tbody>
            <tfoot>
            <tr style="background: #2a304d; font-weight: bold;">
                <td colspan="5" style="text-align: right; color: white;">Total Revenue:</td>
                <td style="color: #d4af37; font-size: 18px;">RM<%= String.format("%.2f", request.getAttribute("totalFiltered")) %></td>
            </tr>
            <tr style="background: #2a304d;">
                <td colspan="5" style="text-align: right; color: white;">Number of Orders:</td>
                <td style="color: #d4af37; font-size: 18px;"><%= request.getAttribute("countFiltered") %></td>
            </tr>
            </tfoot>
        </table>

    </div>
</div>

<div class="footer">© 2026 Kopitiam Admin System</div>

</body>
</html>