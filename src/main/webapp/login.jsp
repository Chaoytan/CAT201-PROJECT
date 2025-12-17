<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Login | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

<div class="login-container">
    <h2>Welcome Back</h2>
    <p class="subtitle">Please enter your details to sign in.</p>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message show-error">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form action="LoginServlet" method="post">
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="e.g. ali@gmail.com" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>

        <button type="submit" class="btn-login">Sign In</button>
    </form>

    <div class="links">
        Don't have an account? <a href="register.jsp">Create account</a>
    </div>
</div>

</body>
</html>