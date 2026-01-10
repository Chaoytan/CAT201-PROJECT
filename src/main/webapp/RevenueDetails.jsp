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
            <h3>Revenue Report: <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></h3>
        </div>

        <%
            // Database connection variables
            String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe";
            String dbUser = "kopitiam";
            String dbPass = "password123";

            java.sql.Connection con = null;
            double todayRevenue = 0;
            double weekRevenue = 0;
            double monthRevenue = 0;
            double yearRevenue = 0;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = java.sql.DriverManager.getConnection(dbUrl, dbUser, dbPass);

                // 1. TODAY'S REVENUE
                java.sql.PreparedStatement stmt = con.prepareStatement(
                        "SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE TRUNC(ORDER_DATE) = TRUNC(SYSDATE)"
                );
                java.sql.ResultSet rs = stmt.executeQuery();
                if(rs.next()) todayRevenue = rs.getDouble(1);

                // 2. THIS WEEK'S REVENUE (last 7 days)
                stmt = con.prepareStatement(
                        "SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE ORDER_DATE >= TRUNC(SYSDATE) - 7"
                );
                rs = stmt.executeQuery();
                if(rs.next()) weekRevenue = rs.getDouble(1);

                // 3. THIS MONTH'S REVENUE
                stmt = con.prepareStatement(
                        "SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS " +
                                "WHERE EXTRACT(YEAR FROM ORDER_DATE) = EXTRACT(YEAR FROM SYSDATE) " +
                                "AND EXTRACT(MONTH FROM ORDER_DATE) = EXTRACT(MONTH FROM SYSDATE)"
                );
                rs = stmt.executeQuery();
                if(rs.next()) monthRevenue = rs.getDouble(1);

                // 4. THIS YEAR'S REVENUE
                stmt = con.prepareStatement(
                        "SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS " +
                                "WHERE EXTRACT(YEAR FROM ORDER_DATE) = EXTRACT(YEAR FROM SYSDATE)"
                );
                rs = stmt.executeQuery();
                if(rs.next()) yearRevenue = rs.getDouble(1);

            } catch(Exception e) {
                e.printStackTrace();
            } finally {
                try { if (con != null) con.close(); } catch(Exception e) {}
            }
        %>

        <!-- Revenue Summary Cards -->
        <div class="revenue-cards">
            <div class="revenue-card today">
                <div class="revenue-label">Today</div>
                <div class="revenue-amount">$<%= String.format("%.2f", todayRevenue) %></div>
                <div style="color: #888; font-size: 12px;">Daily Revenue</div>
            </div>

            <div class="revenue-card week">
                <div class="revenue-label">This Week</div>
                <div class="revenue-amount">$<%= String.format("%.2f", weekRevenue) %></div>
                <div style="color: #888; font-size: 12px;">Last 7 Days</div>
            </div>

            <div class="revenue-card month">
                <div class="revenue-label">This Month</div>
                <div class="revenue-amount">$<%= String.format("%.2f", monthRevenue) %></div>
                <div style="color: #888; font-size: 12px;">Monthly Revenue</div>
            </div>

            <div class="revenue-card year">
                <div class="revenue-label">This Year</div>
                <div class="revenue-amount">$<%= String.format("%.2f", yearRevenue) %></div>
                <div style="color: #888; font-size: 12px;">Yearly Revenue</div>
            </div>
        </div>

        <!-- Date Range Filter -->
        <div style="margin: 30px 0;">
            <h3>Filter by Date Range</h3>
            <form method="get" action="RevenueDetails.jsp">
                <label style="color: white; margin-right: 10px;">From:</label>
                <input type="date" name="startDate" class="date-filter">

                <label style="color: white; margin: 0 10px 0 20px;">To:</label>
                <input type="date" name="endDate" class="date-filter">

                <button type="submit" class="filter-btn">Filter</button>
            </form>
        </div>

        <!-- Detailed Revenue Table -->
        <%
            // Get date range from URL parameters (if any)
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            java.sql.Connection con2 = null;
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con2 = java.sql.DriverManager.getConnection(dbUrl, dbUser, dbPass);

                String sql = "SELECT o.ID, o.USER_ID, o.TOTAL_AMOUNT, o.ORDER_DATE, o.STATUS, " +
                        "COUNT(oi.ID) as ITEM_COUNT " +
                        "FROM ORDERS o " +
                        "LEFT JOIN ORDER_ITEMS oi ON o.ID = oi.ORDER_ID ";

                // Add WHERE clause if dates are specified
                if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
                    sql += "WHERE TRUNC(o.ORDER_DATE) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') ";
                } else {
                    // Default: show last 30 days
                    sql += "WHERE o.ORDER_DATE >= TRUNC(SYSDATE) - 30 ";
                }

                sql += "GROUP BY o.ID, o.USER_ID, o.TOTAL_AMOUNT, o.ORDER_DATE, o.STATUS " +
                        "ORDER BY o.ORDER_DATE DESC";

                java.sql.PreparedStatement stmt = con2.prepareStatement(sql);

                // Set parameters if dates are specified
                if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
                    stmt.setString(1, startDate);
                    stmt.setString(2, endDate);
                }

                java.sql.ResultSet rs = stmt.executeQuery();

                double totalFilteredRevenue = 0;
                int orderCount = 0;
        %>

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

                while (rs.next()) {
                    orderCount++;
                    totalFilteredRevenue += rs.getDouble("TOTAL_AMOUNT");
            %>
            <tr onclick="window.location='ViewOrders.jsp#order-<%= rs.getInt("ID") %>'" style="cursor: pointer;">
                <td>#<%= rs.getInt("ID") %></td>
                <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(rs.getTimestamp("ORDER_DATE")) %></td>
                <td><%= rs.getInt("USER_ID") %></td>
                <td><%= rs.getInt("ITEM_COUNT") %> items</td>
                <td>
                        <span style="background:<%= rs.getString("STATUS").equals("completed") ? "#2ecc71" : "#f39c12" %>;
                                color:white; padding:3px 8px; border-radius:10px; font-size:12px;">
                            <%= rs.getString("STATUS").toUpperCase() %>
                        </span>
                </td>
                <td style="color: #d4af37; font-weight: bold;">$<%= String.format("%.2f", rs.getDouble("TOTAL_AMOUNT")) %></td>
            </tr>
            <%
                }

                if (orderCount == 0) {
            %>
            <tr>
                <td colspan="6" style="text-align: center; padding: 40px; color: #888;">
                    <i class="fa-solid fa-chart-line" style="font-size: 48px; margin-bottom: 15px;"></i>
                    <p>No orders found in selected date range</p>
                </td>
            </tr>
            <%
                }

                rs.close();
                stmt.close();
            %>
            </tbody>
            <tfoot>
            <tr style="background: #2a304d; font-weight: bold;">
                <td colspan="5" style="text-align: right; color: white;">Total Revenue:</td>
                <td style="color: #d4af37; font-size: 18px;">$<%= String.format("%.2f", totalFilteredRevenue) %></td>
            </tr>
            <tr style="background: #2a304d;">
                <td colspan="5" style="text-align: right; color: white;">Number of Orders:</td>
                <td style="color: #d4af37; font-size: 18px;"><%= orderCount %></td>
            </tr>
            </tfoot>
        </table>
        <%

        } catch(Exception e) {
        %>
        <div style="color: #e74c3c; text-align: center; padding: 30px;">
            <i class="fa-solid fa-exclamation-triangle" style="font-size: 48px;"></i>
            <p>Error loading revenue details: <%= e.getMessage() %></p>
        </div>
        <%
            } finally {
                try { if (con2 != null) con2.close(); } catch(Exception e) {}
            }
        %>

        <!-- Revenue Chart Placeholder -->
        <div style="margin-top: 40px; padding: 20px; background: #232946; border-radius: 10px;">
            <h3>Revenue Trend</h3>
            <div style="text-align: center; padding: 50px; color: #888;">
                <i class="fa-solid fa-chart-bar" style="font-size: 48px; margin-bottom: 20px;"></i>
                <p>Revenue chart would be displayed here</p>
                <p style="font-size: 12px;">(Could be implemented with Chart.js or any charting library)</p>
            </div>
        </div>

    </div>
</div>

<div class="footer">© 2026 Kopitiam Admin System</div>

</body>
</html>