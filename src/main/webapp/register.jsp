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

<div id="tcModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Terms & Conditions</h3>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <p style="font-size: 0.9em; color: #888; margin-bottom: 20px;">
                Last Updated: January 2026
            </p>

            <h4>1. Privacy & Data Protection (PDPA)</h4>
            <p>We value your privacy. Your personal information (including name, phone number, and address) is collected strictly for the purpose of order processing and delivery. We do not sell or share your data with third parties, in accordance with the Personal Data Protection Act 2010.</p>

            <h4>2. Zero-Tolerance Policy on Abuse</h4>
            <p>The safety and dignity of our delivery staff are paramount. We strictly prohibit any form of harassment, verbal abuse, or threatening behavior towards our riders. Violation of this policy will result in immediate account suspension.</p>

            <h4>3. Payment Terms (COD)</h4>
            <p>All transactions are currently <strong>Cash on Delivery (COD)</strong>. By placing an order, you enter a binding contract to accept the items and pay the full amount upon arrival. Please ensure you are present at the delivery location.</p>

            <h4>4. Food Quality & Liability</h4>
            <p>We strive to serve the freshest local coffee and cuisine. To ensure quality and safety, we recommend consuming all meals immediately upon delivery. Guan Heng Kopitiam is not liable for spoilage due to delayed consumption.</p>

            <h4>5. Community Integrity</h4>
            <p>We are a community-focused establishment. Users agree to refrain from spreading false information, defamatory rumors, or malicious content regarding the business or other patrons. We reserve the right to ban users who disrupt our community harmony.</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-agree" id="btnAgree">I Understand</button>
        </div>
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

    // Open the modal
    link.onclick = function(e) {
        e.preventDefault(); // Stop it from jumping to top
        modal.style.display = "flex"; // Show it
    }

    // Close buttons
    link.onclick = function(e) { e.preventDefault(); modal.style.display = "flex"; }
    span.onclick = function() { modal.style.display = "none"; }

    // "I Understand" button closes modal AND checks the box
    btnAgree.onclick = function() {
        modal.style.display = "none";
        checkbox.checked = true; // Auto-check the box for better UX
    }

    // Close if user clicks outside the box
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    link.onclick = function(e) { e.preventDefault(); modal.style.display = "flex"; }
    span.onclick = function() { modal.style.display = "none"; }
    btnAgree.onclick = function() { modal.style.display = "none"; checkbox.checked = true; }
    window.onclick = function(event) { if (event.target == modal) { modal.style.display = "none"; } }
</script>

</body>
</html>