<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Today's Orders - Kopitiam Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/index.css">
    <style>
        .orders-container { background: #1a1f3c; border-radius: 10px; padding: 25px; margin-top: 20px; }
        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 1px solid #2a304d; }
        .back-btn { background: #2a304d; color: white; border: 1px solid #d4af37; padding: 8px 20px; border-radius: 5px; text-decoration: none; }
        .order-card { background: #232946; border-radius: 8px; padding: 20px; margin-bottom: 20px; border-left: 4px solid #3498db; }
        .order-id { color: #d4af37; font-weight: bold; font-size: 18px; }
        .order-status { background: #2ecc71; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .order-status.pending { background: #f39c12; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #2a304d; color: #d4af37; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #2a304d; color: #ddd; }
        .no-orders { text-align: center; padding: 50px; color: #888; }
        .error { color: #e74c3c; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="brand-name"><i class="fa-solid fa-layer-group"></i> KOPITIAM ADMIN</div>
    <div class="user-profile"><i class="fa-solid fa-circle-user"></i> Hello, Albert</div>
</nav>

<div class="main-content">
    <div class="welcome-section">
        <h1>Today's Orders</h1>
        <p>View all orders placed today with their details</p>
    </div>

    <div class="orders-container">
        <div class="order-header">
            <a href="index.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
            <h3>Orders for: <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></h3>
        </div>

        <%
            // DECLARE VARIABLES OUTSIDE TRY BLOCK SO THEY'RE ACCESSIBLE EVERYWHERE
            String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe";
            String dbUser = "kopitiam";
            String dbPass = "password123";

            java.sql.Connection con = null;
            java.sql.PreparedStatement stmt = null;
            java.sql.ResultSet rs = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = java.sql.DriverManager.getConnection(dbUrl, dbUser, dbPass);

                // Get orders without joining with USERS table
                String sql = "SELECT ID, USER_ID, TOTAL_AMOUNT, ORDER_DATE, STATUS, DELIVERY_ADDRESS " +
                        "FROM ORDERS " +
                        "WHERE TRUNC(ORDER_DATE) = TRUNC(SYSDATE) " +
                        "ORDER BY ORDER_DATE DESC";

                stmt = con.prepareStatement(sql);
                rs = stmt.executeQuery();

                boolean hasOrders = false;

                while (rs.next()) {
                    hasOrders = true;
                    int orderId = rs.getInt("ID");
                    String status = rs.getString("STATUS");
                    String statusClass = status != null && status.equalsIgnoreCase("pending") ? "pending" : "";
        %>
        <div class="order-card">
            <div style="display: flex; justify-content: space-between; margin-bottom: 15px;">
                <div>
                    <div class="order-id">Order #<%= orderId %></div>
                    <div>User ID: <%= rs.getInt("USER_ID") %></div>
                    <div>Time: <%= new java.text.SimpleDateFormat("hh:mm a").format(rs.getTimestamp("ORDER_DATE")) %></div>
                </div>
                <div class="order-status <%= statusClass %>">
                    <%= status != null ? status.toUpperCase() : "UNKNOWN" %>
                </div>
            </div>

            <%
                // Now get items for this order
                java.sql.PreparedStatement itemStmt = null;
                java.sql.ResultSet itemRs = null;
                try {
                    itemStmt = con.prepareStatement(
                            "SELECT oi.QUANTITY, oi.PRICE_AT_TIME, p.NAME as PRODUCT_NAME " +
                                    "FROM ORDER_ITEMS oi " +
                                    "LEFT JOIN PRODUCTS p ON oi.PRODUCT_ID = p.ID " +
                                    "WHERE oi.ORDER_ID = ?"
                    );
                    itemStmt.setInt(1, orderId);
                    itemRs = itemStmt.executeQuery();

                    if (itemRs.next()) {
            %>
            <table>
                <thead>
                <tr>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Subtotal</th>
                </tr>
                </thead>
                <tbody>
                <%
                    do {
                        int quantity = itemRs.getInt("QUANTITY");
                        double price = itemRs.getDouble("PRICE_AT_TIME");
                        double subtotal = quantity * price;
                        String productName = itemRs.getString("PRODUCT_NAME");
                %>
                <tr>
                    <td><%= productName != null ? productName : "Product" %></td>
                    <td><%= quantity %></td>
                    <td>$<%= String.format("%.2f", price) %></td>
                    <td>$<%= String.format("%.2f", subtotal) %></td>
                </tr>
                <%
                    } while (itemRs.next());
                %>
                </tbody>
            </table>
            <%
            } else {
                // No items found for this order
            %>
            <div style="color: #888; text-align: center; padding: 20px;">
                No items found for this order
            </div>
            <%
                }
            } catch(Exception itemError) {
                // If PRODUCTS join fails, try without it
            %>
            <div style="color: #888; text-align: center; padding: 20px;">
                Could not load product details: <%= itemError.getMessage() %>
            </div>
            <%
                } finally {
                    try { if (itemRs != null) itemRs.close(); } catch(Exception e) {}
                    try { if (itemStmt != null) itemStmt.close(); } catch(Exception e) {}
                }
            %>

            <div style="text-align: right; margin-top: 15px; color: #d4af37; font-weight: bold;">
                Total: $<%= String.format("%.2f", rs.getDouble("TOTAL_AMOUNT")) %>
                <% if (rs.getString("DELIVERY_ADDRESS") != null && !rs.getString("DELIVERY_ADDRESS").isEmpty()) { %>
                <div style="font-size: 12px; color: #aaa; margin-top: 5px;">
                    <i class="fa-solid fa-truck"></i>
                    <%= rs.getString("DELIVERY_ADDRESS") %>
                </div>
                <% } %>
            </div>
        </div>
        <%
            }

            if (!hasOrders) {
        %>
        <div class="no-orders">
            <i class="fa-solid fa-clipboard" style="font-size: 48px; margin-bottom: 20px;"></i>
            <p>No orders placed today.</p>
        </div>
        <%
            }

        } catch(Exception e) {
        %>
        <div class="no-orders error">
            <i class="fa-solid fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 20px;"></i>
            <p>Error loading orders. Please try again later.</p>
            <p style="font-size: 12px;">Error: <%= e.getMessage() %></p>
        </div>

        <%-- Simple fallback display --%>
        <%
            // Try a simpler query
            java.sql.Connection con2 = null;
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con2 = java.sql.DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "kopitiam", "password123");

                java.sql.PreparedStatement stmt2 = con2.prepareStatement(
                        "SELECT ID, USER_ID, TOTAL_AMOUNT FROM ORDERS WHERE TRUNC(ORDER_DATE) = TRUNC(SYSDATE)"
                );
                java.sql.ResultSet rs2 = stmt2.executeQuery();

                if (rs2.next()) {
        %>
        <h3>Simple Order List:</h3>
        <div style="background: #2a304d; padding: 15px; border-radius: 8px;">
            <%
                do {
            %>
            <div style="padding: 10px; border-bottom: 1px solid #1a1f3c;">
                Order #<%= rs2.getInt("ID") %> -
                User: <%= rs2.getInt("USER_ID") %> -
                Total: $<%= rs2.getDouble("TOTAL_AMOUNT") %>
            </div>
            <%
                } while (rs2.next());
            %>
        </div>
        <%
                }

                rs2.close();
                stmt2.close();
                con2.close();

            } catch(Exception e2) {
                out.println("<p style='color:red'>Could not retrieve any order data.</p>");
            }
        %>
        <%
            } finally {
                try { if (rs != null) rs.close(); } catch(Exception e) {}
                try { if (stmt != null) stmt.close(); } catch(Exception e) {}
                try { if (con != null) con.close(); } catch(Exception e) {}
            }
        %>
    </div>
</div>

<div class="footer">© 2026 Kopitiam Admin System</div>

</body>
</html>