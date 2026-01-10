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

    <div class="header" style="display: flex; justify-content: space-between; align-items: center;">

        <div class="header1">
            <h1 style="margin: 0;">Menu Management</h1>
        </div>

        <div class="action-buttons" style="display: flex; gap: 15px; align-items: center;">

            <a href="index.jsp" style="text-decoration: none;">
                <button class="header2" style="background-color: #4b5563; min-width: 100px;">
                    Admin Dashboard
                </button>
            </a>

            <a href="Item-Form.jsp" style="text-decoration: none;">
                <button class="header2">
                    <i class="fa-solid fa-plus"></i> Add Items
                </button>
            </a>

        </div>

    </div>

    <div class="body">

        <div class="body-head">
            <input class="search" type="text" placeholder="Search...">
            <div class="filter-container">
                <select class="category" id="category">
                    <option value="all">All Categories</option>
                    <option value="food">Food</option>
                    <option value="drink">Drink</option>
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


</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const searchInput = document.querySelector(".search");
        const categorySelect = document.getElementById("category");
        const tableRows = document.querySelectorAll("tbody tr");

        function filterTable() {
            // 1. Get current values
            const searchText = searchInput.value.toLowerCase();
            const selectedCategory = categorySelect.value.toLowerCase();

            // 2. Loop through all rows
            tableRows.forEach(row => {
                // Get Name (Column 3) and Category (Column 5)
                // Note: cells[2] is the 3rd <td> (Name)
                // Note: cells[4] is the 5th <td> (Category)
                const nameText = row.cells[2].textContent.toLowerCase();
                const categoryText = row.cells[4].textContent.toLowerCase();

                // 3. Check if Name matches
                const matchesSearch = nameText.includes(searchText);

                // 4. Check if Category matches
                let matchesCategory = false;
                if (selectedCategory === "all") {
                    matchesCategory = true;
                } else {
                    // Handle "main-course" vs "Main Course" logic
                    // We replace '-' with space to match the database style
                    const normalizedSelect = selectedCategory.replace("-", " ");
                    matchesCategory = categoryText.includes(normalizedSelect);
                }

                // 5. Show or Hide
                if (matchesSearch && matchesCategory) {
                    row.style.display = ""; // Show
                } else {
                    row.style.display = "none"; // Hide
                }
            });
        }

        // Attach events to trigger the function
        searchInput.addEventListener("input", filterTable);
        categorySelect.addEventListener("change", filterTable);
    });
</script>

</body>
</html>

</body>
</html>