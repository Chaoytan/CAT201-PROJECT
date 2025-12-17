<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Sign Up | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/register.css">
    <style>
        .login-container { max-width: 450px; }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Create Account</h2>
    <p class="subtitle">Join us to start ordering delicious food!</p>

    <%-- Error Message Block --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message show-error">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form action="RegisterServlet" method="post">

        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Pick a username" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Create a strong password" required>
        </div>

        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullname" placeholder="e.g. Ali Baba" required>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="e.g. ali@gmail.com" required>
        </div>

        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="phone" placeholder="e.g. 012-3456789">
        </div>

        <div class="form-group">
            <label>Delivery Address</label>
            <input type="text" name="address" placeholder="Unit No, Street, City" style="height: 50px;">
        </div>

        <div class="form-group checkbox-group">
            <input type="checkbox" id="terms" name="terms" required>
            <label for="terms">
                I agree to the <a href="#" onclick="alert('Rule 1: No fighting.\nRule 2: Enjoy the food!'); return false;">Terms & Conditions</a>
            </label>
        </div>

        <button type="submit" class="btn-login">Sign Up</button>
    </form>

    <div class="links">
        Already have an account? <a href="login.jsp">Login here</a>
    </div>
</div>

</body>
</html>