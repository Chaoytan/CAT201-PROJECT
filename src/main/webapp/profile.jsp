<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
%>
<script>
    // 1. Show the popup
    alert("Please log in in order to proceed");

    // 2. When click OK, move to login page
    window.location.href = "login.jsp";
</script>
<%
        return;
    }
%>

<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="css/profile.css">
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

    <div class="action-buttons">
        <a href="edit-profile.jsp" class="btn btn-edit">Edit Details</a>
        <a href="LogoutServlet" class="btn btn-danger">Log Out</a>
        <a href="main.jsp" class="btn btn-link-plain">Back to Home</a>
    </div>

</div>

</body>
</html>
