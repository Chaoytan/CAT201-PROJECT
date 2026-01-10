package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

// ... 前面 import 保持不变 ...

@WebServlet("/VisualizeServlet")
public class VisualizeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String part = request.getParameter("part");
        String type = request.getParameter("type");
        String period = request.getParameter("period");
        String productFilter = request.getParameter("category"); // 此时接收的是具体的商品名或 "all"

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 功能：获取产品名单（用于初始化 P2/P3 下拉框）
        if ("getProducts".equals(action)) {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT DISTINCT name FROM products ORDER BY name";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                List<String> products = new ArrayList<>();
                while (rs.next()) { products.add("\"" + rs.getString("name") + "\""); }
                out.write("{\"products\":" + products + "}");
                return;
            } catch (SQLException e) { e.printStackTrace(); return; }
        }

        if (period != null) period = period.toUpperCase().trim();
        String dbFormat = (type != null && type.equals("week")) ? "IYYY-\"W\"IW" : "YYYY-MM";

        try (Connection conn = DBConnection.getConnection()) {
            if ("p1".equals(part)) {
                String sql = "SELECT TO_CHAR(order_date, 'MM-DD') as lbl, SUM(total_amount) as val " +
                        "FROM orders WHERE TO_CHAR(order_date, '" + dbFormat + "') = ? " +
                        "GROUP BY TO_CHAR(order_date, 'MM-DD') ORDER BY 1";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, period);
                handleSimpleQuery(ps, out);
            }
            else if ("p2".equals(part) || "p3".equals(part)) {
                // P2 统计 COUNT (数量)，P3 统计 SUM (营收)
                String valueExpr = ("p2".equals(part)) ? "COUNT(oi.id)" : "SUM(oi.quantity * oi.price_at_time)";
                String sql;
                PreparedStatement ps;

                if ("all".equals(productFilter) || productFilter == null) {
                    sql = "SELECT p.name as series, TO_CHAR(o.order_date, 'MM-DD') as lbl, " + valueExpr + " as val " +
                            "FROM order_items oi JOIN orders o ON oi.order_id = o.id JOIN products p ON oi.product_id = p.id " +
                            "WHERE TO_CHAR(o.order_date, '" + dbFormat + "') = ? " +
                            "GROUP BY p.name, TO_CHAR(o.order_date, 'MM-DD') ORDER BY 2, 1";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, period);
                } else {
                    sql = "SELECT p.name as series, TO_CHAR(o.order_date, 'MM-DD') as lbl, " + valueExpr + " as val " +
                            "FROM order_items oi JOIN orders o ON oi.order_id = o.id JOIN products p ON oi.product_id = p.id " +
                            "WHERE p.name = ? AND TO_CHAR(o.order_date, '" + dbFormat + "') = ? " +
                            "GROUP BY p.name, TO_CHAR(o.order_date, 'MM-DD') ORDER BY 2, 1";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, productFilter);
                    ps.setString(2, period);
                }
                renderMultiJson(ps, out);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void handleSimpleQuery(PreparedStatement ps, PrintWriter out) throws SQLException {
        ResultSet rs = ps.executeQuery();
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();
        while (rs.next()) {
            labels.add("\"" + rs.getString("lbl") + "\"");
            values.add(rs.getDouble("val"));
        }
        out.write("{\"labels\":" + labels + ", \"values\":" + values + "}");
    }

    private void renderMultiJson(PreparedStatement ps, PrintWriter out) throws SQLException {
        ResultSet rs = ps.executeQuery();
        Map<String, Map<String, Double>> map = new TreeMap<>();
        Set<String> allNames = new TreeSet<>();
        Set<String> allLabels = new TreeSet<>();
        while (rs.next()) {
            String name = rs.getString("series");
            String lbl = rs.getString("lbl");
            double val = rs.getDouble("val");
            allNames.add(name);
            allLabels.add(lbl);
            map.computeIfAbsent(name, k -> new HashMap<>()).put(lbl, val);
        }
        StringBuilder sb = new StringBuilder("{\"labels\":[");
        int i=0; for(String l : allLabels) sb.append(i++>0?",":"").append("\"").append(l).append("\"");
        sb.append("],\"datasets\":{");
        int j=0; for(String n : allNames) {
            sb.append(j++>0?",":"").append("\"").append(n).append("\":[");
            int k=0; for(String l : allLabels) sb.append(k++>0?",":"").append(map.get(n).getOrDefault(l, 0.0));
            sb.append("]");
        }
        sb.append("}}");
        out.write(sb.toString());
    }
}