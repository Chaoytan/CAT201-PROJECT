package com.kopitiam.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // Required for uploads
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // Required for the file object
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet(name = "AddItemServlet", value = "/AddItemServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class AddItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Get Text Data
            String name = request.getParameter("item_name");
            String priceStr = request.getParameter("item_price");
            String category = request.getParameter("cat");

            // 2. Get File Data
            Part filePart = request.getPart("item_image");
            String fileName = filePart.getSubmittedFileName();

            // 3. Define where to save the file
            // This saves it into the "Uploads" folder inside your running server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "Uploads";

            // Create the directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            // 4. Save the file
            filePart.write(uploadPath + File.separator + fileName);

            // 5. Save to Database
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "SYSTEM", "admin123");

            String sql = "INSERT INTO menu_items (name, price, category, image_url) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setDouble(2, Double.parseDouble(priceStr));
            statement.setString(3, category);
            statement.setString(4, fileName); // Save only the NAME of the file (e.g., "burger.jpg")

            statement.executeUpdate();
            connection.close();

            response.sendRedirect("Menu.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}