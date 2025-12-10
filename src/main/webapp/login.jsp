<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Kopitiam Login</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding-top: 50px; }
        form { display: inline-block; border: 1px solid #ccc; padding: 20px; border-radius: 10px; }
        input { display: block; margin: 10px auto; padding: 8px; width: 200px; }
        button { background-color: #8B4513; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        .error { color: red; }
    </style>
</head>
<body>

<h2>Login to Guan Heng Kopitiam</h2>

<form action="LoginServlet" method="post">
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>

    <button type="submit">Login</button>
</form>

<%-- Display Error Message if Login Fails --%>
<p class="error">${errorMessage}</p>

<br>
<a href="register.jsp">Don't have an account? Sign Up</a>

</body>
</html>