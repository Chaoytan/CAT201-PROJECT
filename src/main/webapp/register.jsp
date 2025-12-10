<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Sign Up | Guan Heng Kopitiam</title>
    <link rel="stylesheet" href="styles.css"> <style>
    .auth-container {
        max-width: 400px;
        margin: 100px auto;
        padding: 30px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        text-align: center;
    }
    input, textarea {
        width: 100%;
        padding: 12px;
        margin: 10px 0;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-sizing: border-box;
    }
    button {
        width: 100%;
        padding: 12px;
        background-color: #8B4513;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }
    button:hover { background-color: #D2691E; }
</style>
</head>
<body>
<div class="auth-container">
    <h2 style="color: #8B4513;">Create Account</h2>
    <p>Join Guan Heng Kopitiam today!</p>

    <form action="RegisterServlet" method="post">
        <input type="text" name="username" placeholder="Username (e.g. ali123)" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="text" name="fullname" placeholder="Full Name (e.g. Ali Baba)" required>
        <input type="text" name="phone" placeholder="Phone Number (e.g. 012-3456789)">

        <textarea name="address" rows="3" placeholder="Delivery Address (e.g. 10, Jalan Universiti, Penang)"></textarea>

        <button type="submit">Sign Up</button>
    </form>

    <p style="margin-top: 15px;">
        Already have an account? <a href="login.jsp" style="color: #D2691E; font-weight: bold;">Login here</a>
    </p>
</div>
</body>
</html>