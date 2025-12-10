package com.coffeeshop.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USER = "guanheng";
    private static final String PASS = "admin123";

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
