<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Menu Management Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/Admin-Menu.css">
</head>

<body>

<div class="main">

    <div class="header">
        <div class="header1">
            <h1>Menu Management</h1>
        </div>
        <a href="Item-Form.jsp">
            <button class="header2">
                + Add Items
            </button>
        </a>
    </div>

    <div class="body">

        <div class="body-head">
            <input class="search" type="text" placeholder="Search...">
            <div class="filter-container">
                <select class="category" id="category">
                    <option value="all">All Categories</option>
                    <option value="main-course">Main Course</option>
                    <option value="drinks">Drinks</option>
                </select>
            </div>
        </div>

        <table>
            <thead>
            <tr>
                <th style="width: 50px;">NO.</th>
                <th>Image</th>
                <th>Name</th>
                <th>Price</th>
                <th>Category</th>
                <th>Action</th>
            </tr>
            </thead>

            <tbody>
            <%

                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    Connection con = DBConnection.getConnection();

                    // QUERY: Get all items, newest first
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM PRODUCTS ORDER BY id ASC");

                    // LOOP THROUGH RESULTS
                    int count = 1;
                    while(rs.next()) {
                        int dbId = rs.getInt("id");
                        // Get data from current row
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        String cat = rs.getString("category");
                        String img = rs.getString("image_url");
                        // Safety check for null images
                        if (img == null || img.isEmpty()) { img = "default.png"; }
            %>
            <tr>
                <td><%= count++ %></td>
                <td><img class="food-img" src="images/<%= img %>" alt="Item"></td>
                <td><%= name %></td>
                <td>$<%= String.format("%.2f", price) %></td>
                <td><%= cat %></td>
                <td>
                    <a href="EditItem.jsp?id=<%= dbId %>">
                        <button class="btn-icon btn-edit" type="button"><i class="fa-solid fa-pen-to-square"></i></button>
                    </a>

                    <a href="delete-item?id=<%= rs.getInt("id") %>" onclick="return confirm('Delete this item?');">
                        <button class="btn-icon btn-delete" type="button"><i class="fa-solid fa-trash"></i></button>
                    </a>
                </td>
            </tr>
            <%
                    } // END LOOP
                    con.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
            </tbody>
        </table>

    </div>

    <div class="Home-button">
        <a href="index.jsp" style="text-decoration: none;">
            <button class="btn-home" title="Go Back Home">
                <i class="fa-solid fa-house"></i>
            </button>
        </a>
    </div>
</div>

</body>
</html>