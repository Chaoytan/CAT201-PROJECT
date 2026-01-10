<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Today's Orders - Kopitiam Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/ViewOrders.css">
    <style>
        /* New Button Style */
        .btn-complete {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 0.9em;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-complete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        /* Style for Disabled/Completed State */
        .completed-text {
            color: #10b981;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 5px;
        }
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
        <p>Manage and track daily orders.</p>
    </div>

    <div class="orders-container">

        <div class="order-header">
            <a href="index.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
            <h3>Date: <%= new SimpleDateFormat("MMMM dd, yyyy").format(new Date()) %></h3>
        </div>

        <%
            List<Map<String, Object>> orders = (List<Map<String, Object>>) request.getAttribute("todayOrders");

            if (orders == null || orders.isEmpty()) {
        %>
        <div class="no-orders" style="text-align:center; padding:40px; color:#888;">
            <i class="fa-solid fa-clipboard" style="font-size: 40px; margin-bottom:10px;"></i>
            <p>No orders found for today.</p>
        </div>
        <%
        } else {
            SimpleDateFormat timeFmt = new SimpleDateFormat("hh:mm a");
            for (Map<String, Object> order : orders) {
                String status = (String) order.get("status");
                boolean isCompleted = "Completed".equalsIgnoreCase(status);
        %>

        <div class="order-card" style="background:#1e293b; padding:20px; border-radius:10px; margin-bottom:20px; box-shadow:0 4px 6px rgba(0,0,0,0.3);">

            <div style="display:flex; justify-content:space-between; margin-bottom:15px; border-bottom:1px solid #334155; padding-bottom:10px;">
                <div>
                    <span style="font-size:1.2em; font-weight:bold; color:#fff;">Order #<%= order.get("id") %></span>
                    <span style="color:#94a3b8; font-size:0.9em; margin-left:10px;">
                        <i class="fa-regular fa-clock"></i> <%= timeFmt.format((java.util.Date)order.get("time")) %>
                    </span>
                </div>
                <span style="padding:5px 10px; border-radius:15px; font-size:0.8em; font-weight:bold; background:<%= isCompleted ? "#10b981" : "#f59e0b" %>; color:#000;">
                    <%= status %>
                </span>
            </div>

            <div style="margin-bottom:15px;">
                <%
                    List<String> items = (List<String>) order.get("items");
                    for(String item : items) {
                %>
                <div style="color:#cbd5e1; margin-bottom:5px;">• <%= item %></div>
                <% } %>
            </div>

            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:10px; border-top:1px solid #334155; padding-top:15px;">

                <div style="font-size:1.2em; font-weight:bold; color:#d4af37;">
                    Total: $<%= String.format("%.2f", order.get("total")) %>
                </div>

                <div>
                    <% if (!isCompleted) { %>
                    <form action="UpdateOrderStatusServlet" method="post">
                        <input type="hidden" name="orderId" value="<%= order.get("id") %>">
                        <input type="hidden" name="status" value="Completed">
                        <button type="submit" class="btn-complete">
                            <i class="fa-solid fa-check"></i> Mark Complete
                        </button>
                    </form>
                    <% } else { %>
                    <div class="completed-text">
                        <i class="fa-solid fa-circle-check"></i> Done
                    </div>
                    <% } %>
                </div>

            </div>

            <div style="font-size:0.9em; color:#64748b; margin-top:10px;">
                <i class="fa-solid fa-location-dot"></i> <%= order.get("address") %>
            </div>

        </div>

        <%
                } // End For Loop
            } // End Else
        %>

    </div>
</div>

</body>
</html>