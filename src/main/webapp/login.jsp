<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Login | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/login.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
</head>
<body>

<div class="home">
    <button><a href="main.jsp">Home</a></button>
</div>

<div class="login-container">
    <h2>Welcome Back</h2>
    <p class="subtitle">Please enter your details to sign in.</p>

    <%-- 错误信息显示 --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message show-error">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

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

<script>
    function handleLogin() {
        const passInput = document.getElementById('password');
        const rawPassword = passInput.value;

        if (rawPassword) {
            // 使用 CryptoJS 进行 SHA256 哈希
            const hashedPassword = CryptoJS.SHA256(rawPassword).toString();
            // 关键：将输入框的值替换为密文，这样发往 Servlet 的 Payload 就是加密后的
            passInput.value = hashedPassword;
        }
        return true; // 继续提交
    }
</script>

</body>
</html>