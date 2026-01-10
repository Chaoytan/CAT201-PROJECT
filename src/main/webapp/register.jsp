<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>Sign Up | Guan Heng Coffee Shop</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/register.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
</head>
<body>

<div class="home">
    <button><a href="main.jsp">Home</a></button>
</div>

<div class="register-container">
    <h2>Create Account</h2>
    <p class="subtitle">Join us to start ordering delicious food!</p>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message show-error">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form action="RegisterServlet" method="post" onsubmit="return handleRegister()">

        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Pick a username" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" id="password" name="password" placeholder="Create a strong password" required>
        </div>

        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullname" placeholder="e.g. Ali Baba" required>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email"
                   placeholder="e.g. ali@gmail.com"
                   pattern="[^@]+@[^@]+\.[a-zA-Z]{2,}"
                   title="Must be a valid email (e.g. user@domain.com)"
                   required>
        </div>

        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="phone"
                   placeholder="e.g. 012-3456789"
                   pattern="01[0-9]-[0-9]{7,8}"
                   title="Format: 012-3456789 (e.g., 012-1234567)"
                   required>
        </div>

        <div class="form-group">
            <label>Delivery Address</label>
            <input type="text" name="address" placeholder="Unit No, Street, City" style="height: 50px;" required>
        </div>

        <div class="form-group checkbox-group">
            <input type="checkbox" id="terms" name="terms" required>
            <label for="terms">
                I agree to the <a href="#" id="tcLink">Terms & Conditions</a>
            </label>
        </div>

        <button type="submit" class="btn-login">Sign Up</button>
    </form>

    <div class="links">
        Already have an account? <a href="login.jsp">Login here</a>
    </div>
</div>

<script>
    // 3. 新增加密逻辑函数
    function handleRegister() {
        const passInput = document.getElementById('password');
        const rawPassword = passInput.value;

        if (rawPassword) {
            // 在客户端计算 SHA-256 哈希
            const hashedPassword = CryptoJS.SHA256(rawPassword).toString();
            // 替换输入框的值为密文
            passInput.value = hashedPassword;
        }
        return true; // 继续提交给 RegisterServlet
    }

    // --- 原有的 Modal 逻辑保持不变 ---
    var modal = document.getElementById("tcModal");
    var link = document.getElementById("tcLink");
    var span = document.getElementsByClassName("close")[0];
    var btnAgree = document.getElementById("btnAgree");
    var checkbox = document.getElementById("terms");

    link.onclick = function(e) { e.preventDefault(); modal.style.display = "flex"; }
    span.onclick = function() { modal.style.display = "none"; }
    btnAgree.onclick = function() { modal.style.display = "none"; checkbox.checked = true; }
    window.onclick = function(event) { if (event.target == modal) { modal.style.display = "none"; } }
</script>

</body>
</html>