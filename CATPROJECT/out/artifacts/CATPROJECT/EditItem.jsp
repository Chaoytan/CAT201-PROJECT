<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Item Form Page</title>
    <link rel="stylesheet" href="CSS/CSS.Item-Form-style">
</head>

<body>
<%
    // 1. Get the ID of the item to edit
    String editId = request.getParameter("id");
    String oldName="", oldCat="", oldImg="";
    double oldPrice=0.0;

    // 2. Fetch its current details from Oracle
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
        } catch(Exception e){}
    }
%>

<form action="UpdateItemServlet" method="post">
    <input type="hidden" name="id" value="<%= editId %>">

    <div class="Container">
        <div class="header">Edit Item</div>

        <div class="item-name">ITEM NAME</div>
        <input class="textbox1" type="text" name="item_name" value="<%= oldName %>" required>

        <div class="Price">Price ($)</div>
        <input class="textbox1" type="number" step="0.01" name="item_price" value="<%= oldPrice %>" required>

        <div class="Category">Category (Current: <%= oldCat %>)</div>
        <div class="category-options">
            <label class="radio-item"><input type="radio" name="cat" value="Main" <%= oldCat.equals("Main")?"checked":"" %>> <span>Main</span></label>
            <label class="radio-item"><input type="radio" name="cat" value="Drink" <%= oldCat.equals("Drink")?"checked":"" %>> <span>Drink</span></label>
            <label class="radio-item"><input type="radio" name="cat" value="Dessert" <%= oldCat.equals("Dessert")?"checked":"" %>> <span>Dessert</span></label>
        </div>

        <div class="Upload-Image">Image Filename</div>
        <input class="textbox1" type="text" name="item_image" value="<%= oldImg %>">

        <div class="Save-Button">
            <button class="Save" type="submit">Update</button>
            <a href="Menu.jsp"><button class="Cancel" type="button">Cancel</button></a>
        </div>
    </div>
</form>
</body>
</html>
