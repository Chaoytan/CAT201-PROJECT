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