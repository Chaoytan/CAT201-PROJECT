<%@ page import="com.coffeeshop.model.User" %>
<%
    // 1. Get the current user from the session
    User currentUser = (User) session.getAttribute("currentUser");

    // 2. Check if user is NOT logged in OR if user is NOT an admin
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        // 3. Kick them to login page with an error message
        session.setAttribute("errorMessage", "Access Denied! Admins only.");
        response.sendRedirect("login.jsp");
        return; // Stop the rest of the page from loading
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add New Item</title>
    <link rel="stylesheet" href="css/Item-Form.css">
</head>
<body>

<form action="AddItemServlet" method="post" enctype="multipart/form-data">

    <div class="Container">
        <div class="header">
            <button class="add-icon" type="button">+</button>
            Add Menu Items
        </div>

        <div class="item-name">ITEM NAME</div>
        <input class="textbox1" type="text" name="item_name" placeholder="Enter Name" required>

        <div class="Price">Price ($)</div>
        <input class="textbox1" type="number" step="0.01" name="item_price" placeholder="Enter Price" required>

        <div class="Category">Category</div>
        <div class="category-options">
            <label class="radio-item">
                <input type="radio" name="cat" value="Food" checked>
                <span>Food</span>
            </label>
            <label class="radio-item">
                <input type="radio" name="cat" value="Drink">
                <span>Drink</span>
            </label>
        </div>

        <div class="Upload-Image">Upload Image</div>
        <input class="textbox1" type="file" name="item_image" accept="image/*" required>

        <div class="Save-Button">
            <button class="Save" type="submit">Save</button>
            <a href="Admin-Menu.jsp"><button class="Cancel" type="button">Cancel</button></a>
        </div>

    </div>
</form>

</body>
</html>