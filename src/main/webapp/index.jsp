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
]
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
        <a href="Menu.jsp" class="action-card">
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
                <h3>54</h3>
                <p>Orders Today</p>
            </div>
        </div>

        <div class="stat-card green-accent">
            <div class="icon-box"><i class="fa-solid fa-dollar-sign"></i></div>
            <div class="text-box">
                <h3>$1,240</h3>
                <p>Total Revenue</p>
            </div>
        </div>

        <div class="stat-card red-accent">
            <div class="icon-box"><i class="fa-solid fa-circle-exclamation"></i></div>
            <div class="text-box">
                <h3>3</h3>
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