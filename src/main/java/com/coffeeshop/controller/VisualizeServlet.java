package com.coffeeshop.controller;

import com.coffeeshop.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

@WebServlet("/VisualizeServlet")
public class VisualizeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String part = request.getParameter("part");
        String type = request.getParameter("type");
        String period = request.getParameter("period");
        String productFilter = request.getParameter("category");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if ("getProducts".equals(action)) {
            fetchProducts(out);
            return;
        }

        if (period != null) period = period.toUpperCase().trim();

        try (Connection conn = DBConnection.getConnection()) {
            boolean isWeek = "week".equals(type);
            String dbFormat = isWeek ? "IYYY-\"W\"IW" : "YYYY-MM";

            // Monday=1 ... Sunday=7 for week; 01...31 for month
            String labelExpr = isWeek ?
                    "(CASE TO_CHAR(order_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') " +
                            "WHEN 'MON' THEN '1' WHEN 'TUE' THEN '2' WHEN 'WED' THEN '3' " +
                            "WHEN 'THU' THEN '4' WHEN 'FRI' THEN '5' WHEN 'SAT' THEN '6' " +
                            "WHEN 'SUN' THEN '7' END)" : "TO_CHAR(order_date, 'DD')";

            if ("p1".equals(part)) {
                String sql = "SELECT " + labelExpr + " as lbl, SUM(total_amount) as val " +
                        "FROM orders WHERE TO_CHAR(order_date, '" + dbFormat + "') = ? " +
                        "GROUP BY " + labelExpr + " ORDER BY 1";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, period);
                handleSimpleQuery(ps, out);
            }
            else if ("p2".equals(part) || "p3".equals(part)) {
                String valueExpr = ("p2".equals(part)) ? "COUNT(oi.id)" : "SUM(oi.quantity * oi.price_at_time)";
                String sql;
                if ("all".equals(productFilter) || productFilter == null) {
                    sql = "SELECT p.name as series, " + labelExpr + " as lbl, " + valueExpr + " as val " +
                            "FROM order_items oi JOIN orders o ON oi.order_id = o.id JOIN products p ON oi.product_id = p.id " +
                            "WHERE TO_CHAR(o.order_date, '" + dbFormat + "') = ? " +
                            "GROUP BY p.name, " + labelExpr + " ORDER BY 2, 1";
                } else {
                    sql = "SELECT p.name as series, " + labelExpr + " as lbl, " + valueExpr + " as val " +
                            "FROM order_items oi JOIN orders o ON oi.order_id = o.id JOIN products p ON oi.product_id = p.id " +
                            "WHERE p.name = ? AND TO_CHAR(o.order_date, '" + dbFormat + "') = ? " +
                            "GROUP BY p.name, " + labelExpr + " ORDER BY 2, 1";
                }

                PreparedStatement ps = conn.prepareStatement(sql);
                if ("all".equals(productFilter) || productFilter == null) {
                    ps.setString(1, period);
                } else {
                    ps.setString(1, productFilter);
                    ps.setString(2, period);
                }
                renderMultiJson(ps, out);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void fetchProducts(PrintWriter out) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT DISTINCT name FROM products ORDER BY name";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            List<String> products = new ArrayList<>();
            while (rs.next()) { products.add("\"" + rs.getString("name") + "\""); }
            out.write("{\"products\":" + products + "}");
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private void handleSimpleQuery(PreparedStatement ps, PrintWriter out) throws SQLException {
        ResultSet rs = ps.executeQuery();
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();
        while (rs.next()) {
            labels.add("\"" + rs.getString("lbl").trim() + "\"");
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
            String lbl = rs.getString("lbl").trim();
            double val = rs.getDouble("val");
            allNames.add(name);
            allLabels.add(lbl);
            map.computeIfAbsent(name, k -> new HashMap<>()).put(lbl, val);
        }

        List<String> sortedLabels = new ArrayList<>(allLabels);
        Collections.sort(sortedLabels);

        StringBuilder sb = new StringBuilder("{\"labels\":[");
        for (int i = 0; i < sortedLabels.size(); i++) {
            sb.append(i > 0 ? "," : "").append("\"").append(sortedLabels.get(i)).append("\"");
        }
        sb.append("],\"datasets\":{");

        int j = 0;
        for (String n : allNames) {
            if (j++ > 0) sb.append(",");
            sb.append("\"").append(n).append("\":[");
            for (int k = 0; k < sortedLabels.size(); k++) {
                String l = sortedLabels.get(k);
                Double val = map.get(n).get(l);
                sb.append(k > 0 ? "," : "").append(val != null ? val : 0.0);
            }
            sb.append("]");
        }
        sb.append("}}");
        out.write(sb.toString());
    }
}