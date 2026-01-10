package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RevenueDetailsServlet")
public class RevenueDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Variables for KPI Cards
        double todayRevenue = 0;
        double weekRevenue = 0;
        double monthRevenue = 0;
        double yearRevenue = 0;

        // List for the Table
        List<Map<String, Object>> revenueList = new ArrayList<>();
        double totalFilteredRevenue = 0;
        int orderCount = 0;

        // Get Date Filters from URL (if user clicked "Filter")
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        try {
            Connection con = DBConnection.getConnection();

            // --- PART 1: CALCULATE KPI CARDS ---
            // Today
            PreparedStatement ps1 = con.prepareStatement("SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE TRUNC(ORDER_DATE) = TRUNC(SYSDATE)");
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) todayRevenue = rs1.getDouble(1);

            // Week (Last 7 Days)
            PreparedStatement ps2 = con.prepareStatement("SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE ORDER_DATE >= TRUNC(SYSDATE) - 7");
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()) weekRevenue = rs2.getDouble(1);

            // Month
            PreparedStatement ps3 = con.prepareStatement("SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE EXTRACT(YEAR FROM ORDER_DATE) = EXTRACT(YEAR FROM SYSDATE) AND EXTRACT(MONTH FROM ORDER_DATE) = EXTRACT(MONTH FROM SYSDATE)");
            ResultSet rs3 = ps3.executeQuery();
            if(rs3.next()) monthRevenue = rs3.getDouble(1);

            // Year
            PreparedStatement ps4 = con.prepareStatement("SELECT NVL(SUM(TOTAL_AMOUNT), 0) FROM ORDERS WHERE EXTRACT(YEAR FROM ORDER_DATE) = EXTRACT(YEAR FROM SYSDATE)");
            ResultSet rs4 = ps4.executeQuery();
            if(rs4.next()) yearRevenue = rs4.getDouble(1);


            // --- PART 2: GET DETAILED TABLE DATA ---
            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("SELECT o.ID, o.USER_ID, o.TOTAL_AMOUNT, o.ORDER_DATE, o.STATUS, COUNT(oi.ID) as ITEM_COUNT ");
            sqlBuilder.append("FROM ORDERS o LEFT JOIN ORDER_ITEMS oi ON o.ID = oi.ORDER_ID ");

            // Apply Date Filter Logic
            boolean hasFilter = (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty());

            if (hasFilter) {
                sqlBuilder.append("WHERE TRUNC(o.ORDER_DATE) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') ");
            } else {
                // Default: Last 30 Days
                sqlBuilder.append("WHERE o.ORDER_DATE >= TRUNC(SYSDATE) - 30 ");
            }

            sqlBuilder.append("GROUP BY o.ID, o.USER_ID, o.TOTAL_AMOUNT, o.ORDER_DATE, o.STATUS ");
            sqlBuilder.append("ORDER BY o.ORDER_DATE DESC");

            PreparedStatement psList = con.prepareStatement(sqlBuilder.toString());

            if (hasFilter) {
                psList.setString(1, startDate);
                psList.setString(2, endDate);
            }

            ResultSet rsList = psList.executeQuery();
            while(rsList.next()){
                Map<String, Object> row = new HashMap<>();
                double amount = rsList.getDouble("TOTAL_AMOUNT");

                row.put("id", rsList.getInt("ID"));
                row.put("userId", rsList.getInt("USER_ID"));
                row.put("amount", amount);
                row.put("date", rsList.getTimestamp("ORDER_DATE"));
                row.put("status", rsList.getString("STATUS"));
                row.put("items", rsList.getInt("ITEM_COUNT"));

                revenueList.add(row);

                // Calculate totals for the footer
                totalFilteredRevenue += amount;
                orderCount++;
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Send everything to the JSP
        request.setAttribute("today", todayRevenue);
        request.setAttribute("week", weekRevenue);
        request.setAttribute("month", monthRevenue);
        request.setAttribute("year", yearRevenue);

        request.setAttribute("revenueList", revenueList);
        request.setAttribute("totalFiltered", totalFilteredRevenue);
        request.setAttribute("countFiltered", orderCount);

        request.getRequestDispatcher("RevenueDetails.jsp").forward(request, response);
    }
}