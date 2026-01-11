<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Login | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

<div class="home">
    <button><a href="main.jsp">Home</a></button>
</div>

<div class="login-container">
    <h2>Welcome Back</h2>
    <p class="subtitle">Please enter your details to sign in.</p>

    <%
        String errorMsg = (String) session.getAttribute("errorMessage");
        if (errorMsg != null) {
    %>
    <div style="background-color: #fee2e2; color: #dc2626; border: 1px solid #fecaca; padding: 10px; border-radius: 6px; margin-bottom: 15px; text-align: center; font-weight: bold;">
        <i class="fa-solid fa-triangle-exclamation"></i> <%= errorMsg %>
    </div>
    <%
            // Remove it so it doesn't stay forever
            session.removeAttribute("errorMessage");
        }
    %>

    <form action="LoginServlet" method="post" onsubmit="return handleLogin()">
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="e.g. ali@gmail.com" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>

        <button type="submit">Sign In</button>
    </form>

    <div class="links">
        Don't have an account? <a href="register.jsp">Create account</a>
    </div>
</div>

</body>
</html>