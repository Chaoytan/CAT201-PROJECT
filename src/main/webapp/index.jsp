<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/index.css">
    <title>Main Page | Guan Heng Coffee Shop</title>
</head>
<body>
<h1>GUAN HENG KOPITIAM</h1>


    <div id="login">
        <a href="login.jsp" class="btn-link">Login</a>
    </div>

    <div id="register">
        <a href="register.jsp" class="btn-link">Register</a>
    </div>

    <div id="profile">
        <a href="profile.jsp" class="btn-link">Profile</a>
    </div>

<%
    String msg = request.getParameter("msg");
    if (msg != null) {
%>
<script>alert("<%= msg %>");</script>
<%
    }
%>
</body>
</html>
