<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Feedback Inbox</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        /* --- THEME VARIABLES --- */
        :root {
            --bg-dark: #0f172a;
            --bg-card: #1e293b;
            --bg-lighter: #334155;
            --accent-gold: #eab308;
            --text-main: #ffffff;
            --text-muted: #94a3b8;
            --danger: #f43f5e;
            --success: #10b981;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            font-family: 'Poppins', sans-serif; /* or Arial */
            margin: 0;
            padding: 40px;
        }

        /* --- HEADER --- */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--bg-lighter);
        }

        .header h1 {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .btn-home {
            background: transparent;
            border: 2px solid #475569;
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-home:hover {
            border-color: var(--accent-gold);
            color: var(--accent-gold);
        }

        /* --- STATS ROW (The Summary) --- */
        .stats-row {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: var(--bg-card);
            padding: 20px;
            border-radius: 12px;
            width: 200px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
        }

        .stat-icon {
            font-size: 24px;
            color: var(--accent-gold);
            background-color: rgba(234, 179, 8, 0.1);
            padding: 12px;
            border-radius: 10px;
        }

        .stat-info h3 { margin: 0; font-size: 24px; }
        .stat-info p { margin: 0; color: var(--text-muted); font-size: 12px; }

        /* --- THE INBOX LIST --- */
        .feedback-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* SINGLE MESSAGE CARD */
        .feedback-card {
            background-color: var(--bg-card);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            border-left: 4px solid transparent; /* Hidden border for logic */
            transition: transform 0.2s;
        }

        /* Hover effect */
        .feedback-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.4);
        }

        /* A "New" unread message gets a Gold border on the left */
        .feedback-card.unread {
            border-left-color: var(--accent-gold);
            background-color: #263345; /* Slightly lighter to show it's new */
        }

        /* Card Top Row: Name, Date, Stars */
        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--bg-lighter);
            padding-bottom: 10px;
            margin-bottom: 5px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: bold;
        }

        .user-avatar {
            width: 35px;
            height: 35px;
            background-color: var(--bg-lighter);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--accent-gold);
        }

        .stars { color: var(--accent-gold); font-size: 14px; }
        .date { color: var(--text-muted); font-size: 12px; }

        /* Card Body: The Message */
        .card-message {
            color: #d1d5db; /* Light grey */
            line-height: 1.5;
            font-size: 14px;
        }

        /* Card Footer: Buttons */
        .card-actions {
            display: flex;
            justify-content: flex-end; /* Pushes buttons to right */
            gap: 10px;
            margin-top: 10px;
        }

        .btn-action {
            background: transparent;
            border: 1px solid var(--bg-lighter);
            color: var(--text-muted);
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .btn-action:hover { background-color: var(--bg-lighter); color: white; }

        .btn-delete:hover { border-color: var(--danger); color: var(--danger); }

    </style>
</head>
<body>

<div class="header">
    <h1>
        <a href="index.jsp"><button class="btn-home"><i class="fa-solid fa-house"></i></button></a>
        Feedback Inbox
    </h1>
    <input type="text" placeholder="Search feedback..." style="background: #1e293b; border: 1px solid #334155; padding: 10px; border-radius: 8px; color: white;">
</div>

<div class="stats-row">
    <div class="stat-card">
        <div class="stat-icon"><i class="fa-solid fa-star"></i></div>
        <div class="stat-info">
            <h3>4.8</h3>
            <p>Average Rating</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon"><i class="fa-solid fa-envelope"></i></div>
        <div class="stat-info">
            <h3>24</h3>
            <p>Total Reviews</p>
        </div>
    </div>
</div>

<div class="feedback-container">
    <%
        String url2 = "jdbc:oracle:thin:@localhost:1521:xe";
        String user2 = "SYSTEM";
        String pass2 = "admin123";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con2 = DriverManager.getConnection(url2, user2, pass2);
            Statement stmt2 = con2.createStatement();
            ResultSet rs2 = stmt2.executeQuery("SELECT * FROM feedback ORDER BY submission_date DESC");

            while(rs2.next()) {
                String customer = rs2.getString("customer_name");
                int rating = rs2.getInt("rating");
                String msg = rs2.getString("message");
                int isRead = rs2.getInt("is_read");

                // If unread (0), use the 'unread' class for gold border
                String cssClass = (isRead == 0) ? "feedback-card unread" : "feedback-card";
    %>
    <div class="<%= cssClass %>">
        <div class="card-top">
            <div class="user-info">
                <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
                <span><%= customer %></span>
            </div>
            <div style="text-align: right;">
                <div class="stars">
                    <% for(int i=0; i<rating; i++) { %> <i class="fa-solid fa-star"></i> <% } %>
                </div>
            </div>
        </div>
        <div class="card-message"><%= msg %></div>
        <div class="card-actions">
            <a href="delete-feedback?id=<%= rs2.getInt("id") %>" onclick="return confirm('Delete this review?');">
                <button class="btn-action btn-delete" type="button"><i class="fa-solid fa-trash"></i> Delete</button>
            </a>
        </div>
    </div>
    <%
            }
            con2.close();
        } catch (Exception e) { out.println("Error: " + e.getMessage()); }
    %>
</div>

</body>
</html>