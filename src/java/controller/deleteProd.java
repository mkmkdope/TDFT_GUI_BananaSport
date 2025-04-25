package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "deleteProd", urlPatterns = {"/myStaff/deleteProd"})
public class deleteProd extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        Connection conn = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            DBConnection db = new DBConnection();
            conn = db.getConnection();

            String id = request.getParameter("id");
            String delAction = request.getParameter("delAction");

            if ("confirm".equals(delAction)) {
                String queryDelete = "DELETE FROM PRODUCTS WHERE PRODUCT_ID = ?";
                PreparedStatement ps = conn.prepareStatement(queryDelete);
                ps.setString(1, id);
                int deleted = ps.executeUpdate();

                if (deleted > 0) {
                    request.setAttribute("message", "Product deleted successfully!");
                } else {
                    request.setAttribute("error", "Failed to delete product.");
                     request.getRequestDispatcher("/staticView/error.jsp").forward(request, response);
                }

                request.getRequestDispatcher("ControlProdM").forward(request, response);

            } else if ("Noconfirm".equals(delAction)) {
                request.setAttribute("message", "Product deletion cancelled.");
                request.getRequestDispatcher("ControlProdM").forward(request, response);
            }
            

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/staticView/error.jsp").forward(request, response);
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles product deletion or cancellation.";
    }
}
