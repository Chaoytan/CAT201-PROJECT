<!DOCTYPE html>
<html>
<head>
    <title>Item Form Page</title>
    <link rel="stylesheet" href="CSS/CSS.Item-Form-style">
</head>
<body>
<form action="AddItemServlet" method="post">

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
                <input type="radio" name="cat" value="Main" checked>
                <span>Main Course</span>
            </label>
            <label class="radio-item">
                <input type="radio" name="cat" value="Drink">
                <span>Drink</span>
            </label>
            <label class="radio-item">
                <input type="radio" name="cat" value="Dessert">
                <span>Dessert</span>
            </label>
        </div>

        <div class="Upload-Image">Image Filename</div>
        <input class="textbox1" type="text" name="item_image" placeholder="e.g. burger.jpg">

        <div class="Save-Button">
            <button class="Save" type="submit">Save</button>
            <a href="Menu.jsp"><button class="Cancel" type="button">Cancel</button></a>
        </div>

    </div>
</form>
</body>
</html>