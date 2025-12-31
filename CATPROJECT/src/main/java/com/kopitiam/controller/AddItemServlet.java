import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet(name = "AddItemServlet", value = "/AddItemServlet")
public class AddItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. GET DATA FROM FORM
        String name = request.getParameter("item_name");
        String priceStr = request.getParameter("item_price");
        String category = request.getParameter("cat");
        String image = request.getParameter("item_image");

        // 2. ORACLE DB CONNECTION
        String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUser = "SYSTEM";
        String dbPassword = "admin123"; // Your new password

        try {
            // 3. LOAD DRIVER
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // 4. CONNECT
            Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // 5. INSERT QUERY
            String sql = "INSERT INTO menu_items (name, price, category, image_url) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setString(1, name);
            statement.setDouble(2, Double.parseDouble(priceStr));
            statement.setString(3, category);
            statement.setString(4, image);

            // 6. EXECUTE AND CLOSE
            statement.executeUpdate();
            connection.close();

            // 7. REDIRECT BACK TO MENU
            response.sendRedirect("Menu.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
