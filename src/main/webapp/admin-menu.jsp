<%@ page import="java.sql.*" %>
<%@ page import="com.coffeeshop.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Menu Management Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin-dashboard.css">
    <link rel="stylesheet" href="css/admin-menu.css">

    <style>
        td a { text-decoration: none !important; }
    </style>
</head>

<body>

<div class="main">

    <nav class="navbar">
        <div class="brand-name"><i class="fa-solid fa-layer-group"></i> MENU MANAGEMENT</div>
        <div class="user-profile"><i class="fa-solid fa-circle-user"></i> Hello, Admin</div>
    </nav>

    <div class="body">

        <div class="body-head">
            <div class="Home-button">
                <a href="admin-dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
            </div>

            <input id="searchInput" class="search" type="text" placeholder="Search item name..." onkeyup="filterTable()">

            <div class="filter-container">
                <select class="category" id="categoryFilter" onchange="filterTable()">
                    <option value="all">All Categories</option>
                    <option value="food">Food</option>
                    <option value="drink">Drink</option>
                </select>
            </div>

            <a href="add-product.jsp" class="header2"> + Add Items </a>
        </div>

        <table id="menuTable"> <thead>
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
                    // No Class.forName needed for newer JDBC, but kept for safety
                    Connection con = DBConnection.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM PRODUCTS ORDER BY id ASC");

                    int count = 1;
                    while(rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        String cat = rs.getString("category");
                        String img = rs.getString("image_url");
                        if (img == null || img.isEmpty()) { img = "default.png"; }
            %>
            <tr class="item-row">
                <td><%= count++ %></td>
                <td><img class="food-img" src="images/<%= img %>" alt="Item"></td>

                <td class="item-name"><%= name %></td>
                <td>$<%= String.format("%.2f", price) %></td>
                <td class="item-category"><%= cat %></td>

                <td>
                    <a href="edit-product.jsp?id=<%= id %>" style="text-decoration: none;">
                        <button class="btn-icon btn-edit" type="button"><i class="fa-solid fa-pen-to-square"></i></button>
                    </a>

                    <a href="delete-item?id=<%= id %>" onclick="return confirm('Delete this item?');" style="text-decoration: none;">
                        <button class="btn-icon btn-delete" type="button"><i class="fa-solid fa-trash"></i></button>
                    </a>
                </td>
            </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
            </tbody>
        </table>

    </div>
</div>

<script>
    function filterTable() {
        // 1. Get Input Values
        var searchInput = document.getElementById("searchInput").value.toLowerCase();
        var categoryFilter = document.getElementById("categoryFilter").value.toLowerCase();

        // 2. Get all Rows
        var rows = document.getElementsByClassName("item-row");

        // 3. Loop through rows and Hide/Show
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];

            // Get Name text and Category text from specific columns
            var name = row.querySelector(".item-name").innerText.toLowerCase();
            var category = row.querySelector(".item-category").innerText.toLowerCase();

            // Check if matches Search
            var matchesSearch = name.includes(searchInput);

            // Check if matches Category (or if 'all' is selected)
            var matchesCategory = (categoryFilter === "all" || category === categoryFilter);

            // Show if BOTH match, otherwise Hide
            if (matchesSearch && matchesCategory) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        }
    }
</script>

</body>
</html>