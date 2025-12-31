package com.kopitiam.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // CHANGE THESE IF NEEDED
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USER = "kopitiam"; // Or 'SYSTEM'
    private static final String PASS = "password123"; // Your Password

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("DB Connection Failed!");
        }
        return con;
    }
}