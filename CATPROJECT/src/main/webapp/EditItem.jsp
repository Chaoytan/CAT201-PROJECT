<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Item</title>
    <link rel="stylesheet" href="CSS/CSS.Item-Form-style">
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
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "SYSTEM", "admin123");

            PreparedStatement stmt = con.prepareStatement("SELECT * FROM menu_items WHERE id=?");
            stmt.setString(1, editId);

            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                oldName = rs.getString("name");
                oldPrice = rs.getDouble("price");
                oldCat = rs.getString("category");
                oldImg = rs.getString("image_url");
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
            <button class="add-icon" type="button"><i class="fa-solid fa-pen"></i></button>
            Edit Menu Item
        </div>

        <div class="item-name">ITEM NAME</div>
        <input class="textbox1" type="text" name="item_name" value="<%= oldName %>" required>

        <div class="Price">Price ($)</div>
        <input class="textbox1" type="number" step="0.01" name="item_price" value="<%= oldPrice %>" required>

        <div class="Category">Category (Current: <%= oldCat %>)</div>
        <div class="category-options">
            <label class="radio-item">
                <input type="radio" name="cat" value="Main" <%= "Main".equals(oldCat) ? "checked" : "" %>>
                <span>Main Course</span>
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
        <div style="margin-bottom: 10px; color: #aaa; font-size: 0.9em;">Current: <%= oldImg %></div>
        <input class="textbox1" type="file" name="item_image" accept="image/*">

        <div class="Save-Button">
            <button class="Save" type="submit">Update</button>
            <a href="Menu.jsp"><button class="Cancel" type="button">Cancel</button></a>
        </div>
    </div>
</form>

</body>
</html>