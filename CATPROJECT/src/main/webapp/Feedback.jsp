<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Feedback Inbox</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/CSS.Feedback-style">
</head>

<body>

<%
    // --- 1. SETUP DATABASE & VARIABLES ---
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "SYSTEM";
    String pass = "admin123";

    String search = request.getParameter("q"); // Get search text

    int totalReviews = 0;
    double avgRating = 0.0;
    int sumRating = 0;

    // We use a list to store data temporarily so we can count stats first
    java.util.ArrayList<java.util.Map<String, Object>> reviews = new java.util.ArrayList<>();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection(url, user, pass);

        // --- 2. BUILD QUERY DYNAMICALLY ---
        String sql = "SELECT * FROM feedback WHERE 1=1";

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (UPPER(customer_name) LIKE UPPER(?) OR UPPER(message) LIKE UPPER(?))";
        }

        sql += " ORDER BY submission_date DESC";

        PreparedStatement stmt = con.prepareStatement(sql);

        if (search != null && !search.trim().isEmpty()) {
            stmt.setString(1, "%" + search + "%");
            stmt.setString(2, "%" + search + "%");
        }

        ResultSet rs = stmt.executeQuery();

        // --- 3. PROCESS DATA (Count Stats & Save Rows) ---
        while(rs.next()) {
            totalReviews++;
            sumRating += rs.getInt("rating");

            // Save row data to show later
            java.util.Map<String, Object> row = new java.util.HashMap<>();
            row.put("id", rs.getInt("id"));
            row.put("customer", rs.getString("customer_name"));
            row.put("rating", rs.getInt("rating"));
            row.put("msg", rs.getString("message"));
            row.put("isRead", rs.getInt("is_read"));
            reviews.add(row);
        }

        // Calculate Average
        if (totalReviews > 0) {
            avgRating = (double) sumRating / totalReviews;
        }

        con.close();
    } catch (Exception e) { e.printStackTrace(); }
%>

<div class="header">
    <h1>
        <a href="index.jsp"><button class="btn-home"><i class="fa-solid fa-house"></i></button></a>
        Feedback Inbox
    </h1>

    <form action="Feedback.jsp" method="get" style="display: flex; gap: 10px;">
        <input type="text" name="q" placeholder="Search name or message..."
               value="<%= search == null ? "" : search %>"
               style="background: #1e293b; border: 1px solid #334155; padding: 10px; border-radius: 8px; color: white; width: 250px;">

        <button type="submit" style="background: #d4af37; border: none; padding: 0 15px; border-radius: 8px; color: white; cursor: pointer;">Search</button>
        <a href="Feedback.jsp"><button type="button" style="background: #555; border: none; padding: 10px 15px; border-radius: 8px; color: white; cursor: pointer;">Reset</button></a>
    </form>
</div>

<div class="stats-row">
    <div class="stat-card">
        <div class="stat-icon"><i class="fa-solid fa-star"></i></div>
        <div class="stat-info">
            <h3><%= String.format("%.1f", avgRating) %></h3> <p>Average Rating</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon"><i class="fa-solid fa-envelope"></i></div>
        <div class="stat-info">
            <h3><%= totalReviews %></h3> <p>Total Reviews</p>
        </div>
    </div>
</div>

<div class="feedback-container">
    <%
        // --- 4. DISPLAY SAVED REVIEWS ---
        if (reviews.isEmpty()) {
    %>
    <h3 style="color: #64748b; text-align: center; width: 100%; margin-top: 50px;">No reviews found.</h3>
    <%
    } else {
        for (java.util.Map<String, Object> review : reviews) {
            String customer = (String) review.get("customer");
            int rating = (int) review.get("rating");
            String msg = (String) review.get("msg");
            int id = (int) review.get("id");

            // Show stars
            StringBuilder starsHtml = new StringBuilder();
            for(int i=0; i<rating; i++) { starsHtml.append("<i class='fa-solid fa-star'></i>"); }
    %>
    <div class="feedback-card">
        <div class="card-top">
            <div class="user-info">
                <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
                <span><%= customer %></span>
            </div>
            <div style="text-align: right;">
                <div class="stars">
                    <%= starsHtml.toString() %>
                </div>
            </div>
        </div>
        <div class="card-message"><%= msg %></div>
        <div class="card-actions">
            <a href="delete-feedback?id=<%= id %>" onclick="return confirm('Delete this review?');">
                <button class="btn-action btn-delete" type="button"><i class="fa-solid fa-trash"></i> Delete</button>
            </a>
        </div>
    </div>
    <%
            }
        }
    %>
</div>

</body>
</html>