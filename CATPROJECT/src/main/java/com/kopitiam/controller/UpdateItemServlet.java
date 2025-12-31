package com.kopitiam.controller;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "UpdateItemServlet", value = "/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            String name = request.getParameter("item_name");
            String price = request.getParameter("item_price");
            String cat = request.getParameter("cat");
            String img = request.getParameter("item_image");

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "SYSTEM", "admin123");

            // The UPDATE Query
            String sql = "UPDATE menu_items SET name=?, price=?, category=?, image_url=? WHERE id=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setDouble(2, Double.parseDouble(price));
            stmt.setString(3, cat);
            stmt.setString(4, img);
            stmt.setString(5, id); // crucial!

            stmt.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("Menu.jsp");
    }
}
