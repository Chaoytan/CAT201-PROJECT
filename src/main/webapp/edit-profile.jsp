<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.coffeeshop.model.User" %>

<%-- Security Check --%>
<%
  User currentUser = (User) session.getAttribute("currentUser");
  if (currentUser == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>

<html>
<head>
  <title>Edit Profile</title>
  <link rel="stylesheet" href="css/profile.css">
</head>
<body>

<div class="profile-container">

  <div class="profile-header">
    <h2>Edit Profile</h2>
    <p>Update your details below</p>
  </div>

  <form action="UpdateProfileServlet" method="post">
    <input type="hidden" name="id" value="${currentUser.id}">

    <div class="form-group">
      <label>Full Name</label>
      <input type="text" name="fullname" value="${currentUser.fullName}" required>
    </div>

    <div class="form-group">
      <label>Phone Number</label>
      <input type="text" name="phone" value="${currentUser.phone}">
    </div>

    <div class="form-group">
      <label>Address</label>
      <textarea name="address" rows="3">${currentUser.address}</textarea>
    </div>

    <div class="form-group" style="border-top: 1px dashed #ccc; padding-top: 20px;">
      <label>New Password <small>(Optional)</small></label>
      <input type="password" name="newPassword" placeholder="Leave blank to keep current">
    </div>

    <div class="action-buttons">
      <button type="submit" class="btn btn-primary">Save Changes</button>
      <a href="profile.jsp" class="btn btn-link-plain">Cancel</a>
    </div>
  </form>
</div>

</body>
</html>