<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Item</title>
    <link rel="stylesheet" href="css/Item-Form.css">
</head>
<body>

<%
    // 1. GET THE ID FROM THE URL
    String editId = request.getParameter("id");

    // Variables to hold the current data
    String oldName = "";
    String oldCat = "";
    String oldImg = "";
    double oldPrice = 0.0;

    // 2. FETCH CURRENT DETAILS FROM DATABASE
    if(editId != null) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement stmt = con.prepareStatement("SELECT * FROM PRODUCTS WHERE id=?");
            stmt.setString(1, editId);

            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                oldName = rs.getString("name");
                oldPrice = rs.getDouble("price");
                oldCat = rs.getString("category");
                oldImg = rs.getString("image_url"); // Filename from DB
            }
            con.close();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
%>

<form action="UpdateItemServlet" method="post" enctype="multipart/form-data">

    <input type="hidden" name="id" value="<%= editId %>">

    <div class="Container">
        <div class="header">
            <span class="add-icon">&#9998;</span>
            Edit Menu Item
        </div>

        <div class="item-name">ITEM NAME</div>
        <input class="textbox1" type="text" name="item_name" value="<%= oldName %>" required>

        <div class="Price">Price ($)</div>
        <input class="textbox1" type="number" step="0.01" name="item_price" value="<%= oldPrice %>" required>

        <div class="Category">Category</div>
        <div class="category-options">
            <label class="radio-item">
                <input type="radio" name="cat" value="Food" <%= "Food".equals(oldCat) ? "checked" : "" %>>
                <span>Food</span>
            </label>
            <label class="radio-item">
                <input type="radio" name="cat" value="Drink" <%= "Drink".equals(oldCat) ? "checked" : "" %>>
                <span>Drink</span>
            </label>
            <label class="radio-item">
                <input type="radio" name="cat" value="Dessert" <%= "Dessert".equals(oldCat) ? "checked" : "" %>>
                <span>Dessert</span>
            </label>
        </div>

        <div class="Upload-Image">Update Image (Optional)</div>

        <% if(oldImg != null && !oldImg.isEmpty()) { %>
        <div class="image-preview-box">
            <img src="images/<%= oldImg %>" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;">
            <span style="color: #aaa; font-size: 12px;">Current: <%= oldImg %></span>
        </div>
        <% } %>

        <input class="textbox1" type="file" name="item_image" accept="image/*">
        <small style="color: #888; font-size: 11px;">Leave empty to keep current image</small>

        <div class="Save-Button">
            <button class="Save" type="submit">Update</button>
            <button class="Cancel" type="button" onclick="window.location.href='Admin-Menu.jsp'">Cancel</button>
        </div>

    </div>
</form>

</body>
</html>