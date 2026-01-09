package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // Required for uploads
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // Required for the file object
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
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

            // === 3. DEFINE PATHS (THE COMBINATION MAGIC) ===

            // Path A: The "Live Server" Path (For Immediate Display)
            String serverPath = getServletContext().getRealPath("") + File.separator + "images";

            // Path B: The "Source Code" Path (For Permanent Storage)
            String sourcePath = "C:/Users/chaoy/IdeaProjects/CAT201_Project/src/main/webapp/images";

            // Create directories if missing
            File serverDir = new File(serverPath);
            if (!serverDir.exists()) serverDir.mkdir();

            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) sourceDir.mkdir();

            // === 4. SAVE THE FILE ===

            // A. Save to Server (So it works NOW)
            String fullServerPath = serverPath + File.separator + fileName;
            filePart.write(fullServerPath);

            // B. Copy to Source (So it works TOMORROW)
            try {
                if (!sourcePath.contains("C:/Users/chaoy/IdeaProjects/CAT201_Project/src/main/webapp/images")) { // Only run if you updated the path
                    File sourceFile = new File(fullServerPath);
                    File destFile = new File(sourcePath + File.separator + fileName);
                    Files.copy(sourceFile.toPath(), destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (Exception ignored) {
                System.out.println("Warning: Could not backup to source folder. Check path.");
            }

            // 5. Save to Database
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO PRODUCTS (name, price, category, image_url) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = con.prepareStatement(sql);
            statement.setString(1, name);
            statement.setDouble(2, Double.parseDouble(priceStr));
            statement.setString(3, category);
            statement.setString(4, fileName); // Save only the NAME of the file (e.g., "burger.jpg")

            statement.executeUpdate();
            con.close();

            response.sendRedirect("Admin-Menu.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}