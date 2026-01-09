package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // REQUIRED
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "UpdateItemServlet", value = "/UpdateItemServlet")
@MultipartConfig // 1. REQUIRED to read data from multipart/form-data
public class UpdateItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 2. Retrieve Text Data
            String id = request.getParameter("id");
            String name = request.getParameter("item_name");
            String price = request.getParameter("item_price");
            String cat = request.getParameter("cat");

            // 3. Handle Image Logic
            Part filePart = request.getPart("item_image");
            String imageFileName = filePart.getSubmittedFileName();

            Connection con = DBConnection.getConnection();
            String sql;
            PreparedStatement stmt;

            // CHECK: Did the user upload a NEW image?
            if (imageFileName != null && !imageFileName.isEmpty()) {
                // A. YES: Update everything including the image

                // Save the new file to server (Same logic as AddItem)
                String uploadPath = getServletContext().getRealPath("") + "images/" + imageFileName;
                FileOutputStream fos = new FileOutputStream(uploadPath);
                InputStream is = filePart.getInputStream();
                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
                fos.close();

                // SQL with Image update
                sql = "UPDATE PRODUCTS SET name=?, price=?, category=?, image_url=? WHERE id=?";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setDouble(2, Double.parseDouble(price));
                stmt.setString(3, cat);
                stmt.setString(4, imageFileName); // New Image Name
                stmt.setString(5, id);

            } else {
                // B. NO: Update only text fields, KEEP old image
                sql = "UPDATE PRODUCTS SET name=?, price=?, category=? WHERE id=?";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setDouble(2, Double.parseDouble(price));
                stmt.setString(3, cat);
                stmt.setString(4, id);
            }

            stmt.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("Admin-Menu.jsp");
    }
}