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
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/feedback.css">
</head>
<body>

<div class="login-container" style="max-width: 500px;">
    <h2>Submit Feedback</h2>
    <p class="subtitle">Found a dirty table or have a suggestion? Let us know.</p>

    <form action="FeedbackServlet" method="post">

        <div class="form-group">
            <label>Rate your experience:</label>
            <div class="star-rating">
                <input type="radio" id="star5" name="rating" value="5" required /><label for="star5">★</label>
                <input type="radio" id="star4" name="rating" value="4" /><label for="star4">★</label>
                <input type="radio" id="star3" name="rating" value="3" /><label for="star3">★</label>
                <input type="radio" id="star2" name="rating" value="2" /><label for="star2">★</label>
                <input type="radio" id="star1" name="rating" value="1" /><label for="star1">★</label>
            </div>
        </div>

        <div class="form-group">
            <label>Subject</label>
            <select name="subject" style="width:100%; padding:10px;">
                <option value="Missing Food">Report Missing Food</option>
                <option value="Food Quality">Food Quality</option>
                <option value="Service">Service</option>
                <option value="Condition">Food Condition</option>
                <option value="Portion">Portion</option>
                <option value="Other">Other Suggestion</option>
            </select>
        </div>

        <div class="form-group">
            <label>Message</label>
            <textarea name="message" rows="4" placeholder="Describe the issue..." required style="width:100%; padding:10px;"></textarea>
        </div>

        <button type="submit" class="btn-login">Submit Feedback</button>
        <div class="cancel">
            <a href="main.jsp" class="btn-link" style="margin-top: 15px;">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>