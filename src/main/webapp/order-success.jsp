<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
  <title>Order Success!</title>
  <link rel="stylesheet" href="css/login.css"> </head>
<body style="text-align: center; padding-top: 50px;">

<div class="login-container" style="max-width: 500px;">
  <h1 style="color: #28a745; font-size: 3rem;">✔</h1>
  <h2 style="color: #8B4513;">Order Placed Successfully!</h2>
  <p>Thank you for ordering from Guan Heng Kopitiam.</p>

  <p style="background: #f9f9f9; padding: 10px; border-radius: 5px;">
    Order ID: <strong>#<%= request.getParameter("id") %></strong>
  </p>

  <div style="margin-top: 30px;">
    <a href="menu.jsp" class="btn-login" style="text-decoration:none; display:inline-block;">Order More Food</a>
    <br><br>
    <a href="main.jsp" style="color:#888;">Back to Home</a>
  </div>
</div>

</body>
</html>