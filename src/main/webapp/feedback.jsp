<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>

<%
    // Security: Only logged-in users can complain
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp?errorMessage=Please login to submit feedback.");
        return;
    }
%>

<html>
<head>
    <title>Submit Feedback | Guan Heng Kopitiam</title>
    <link rel="stylesheet" href="css/login.css"> </head>
<body>

<div class="login-container" style="max-width: 500px;">
    <h2>Submit Feedback</h2>
    <p class="subtitle">Found a dirty table or have a suggestion? Let us know.</p>

    <form action="FeedbackServlet" method="post">

        <div class="form-group">
            <label>Subject</label>
            <select name="subject" style="width:100%; padding:10px;">
                <option value="Dirty Table">Report Missing Food</option>
                <option value="Food Quality">Food Quality Issue</option>
                <option value="Service">Slow Service</option>
                <option value="Other">Other Suggestion</option>
            </select>
        </div>

        <div class="form-group">
            <label>Message</label>
            <textarea name="message" rows="4" placeholder="Describe the issue..." required style="width:100%; padding:10px;"></textarea>
        </div>

        <button type="submit" class="btn-login">Submit Feedback</button>
        <a href="index.jsp" class="btn-link" style="margin-top: 15px;">Cancel</a>
    </form>
</div>

</body>
</html>