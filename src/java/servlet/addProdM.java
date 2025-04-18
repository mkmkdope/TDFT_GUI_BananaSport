package servlet;

import java.io.IOException;
import java.sql.Connection; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.io.PrintWriter;

@MultipartConfig(fileSizeThreshold = 1024 * 1024,  // 1MB
                 maxFileSize = 1024 * 1024 * 5,    // 5MB
                 maxRequestSize = 1024 * 1024 * 10) // 10MB

@WebServlet(name = "addProdM", urlPatterns = {"/myStaff/addProdM"})
public class addProdM extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        Connection conn = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            DBConnection db = new DBConnection();
            conn = db.getConnection();

           //this is for the id generating
            String selectQuery = "SELECT PRODUCT_ID FROM PRODUCTS ORDER BY PRODUCT_ID DESC FETCH FIRST ROW ONLY";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(selectQuery);

            String newId = "P001";
            if (rs.next()) {
                String lastId = rs.getString("PRODUCT_ID");
                int num = Integer.parseInt(lastId.substring(1));
                newId = String.format("P%03d", num + 1);
            }

            
            //this part is for save the image and combine change the imgae name to store
            Part imagePart = request.getPart("image");
            String submittedImageName = java.nio.file.Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            
            String imageExtension = "";
            int i = submittedImageName .lastIndexOf('.');
            
            if(i >= 0){
             imageExtension = submittedImageName.substring(i);
            }

            String newImageName = String.format("%s%s",newId,imageExtension);
            
            String uploadPath = getServletContext().getInitParameter("uploadPath");

            //java.io.File.separator
            
              String fullImagePath =  uploadPath + java.io.File.separator + newImageName;
            
              try(InputStream input = imagePart.getInputStream()){
                  
                  java.nio.file.Files.copy(
                  input,
                          java.nio.file.Paths.get(fullImagePath),
                          java.nio.file.StandardCopyOption.REPLACE_EXISTING
                  );
                  
              }catch(IOException e){
         try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet addProdM</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>The path is " + fullImagePath + "</h1>");
            out.println("<h1>Error " + e.getMessage() + "</h1>");
            out.println("</body>");
            out.println("</html>");
         }
         return;
        }
            
            //this is the insert data part
            String queryInsert = "INSERT INTO PRODUCTS (PRODUCT_ID, PRODUCT_NAME, PRODUCT_CATEGORY, PRODUCT_QTY, PRODUCT_PRICE, PRODUCT_POPULARITY, PRODUCT_CREATEDTIME, IMAGELINK,DESCRIPTION) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)";
            PreparedStatement ps = conn.prepareStatement(queryInsert);
            ps.setString(1, newId);
            ps.setString(2, request.getParameter("name"));
            ps.setString(3, request.getParameter("category"));
            ps.setInt(4, Integer.parseInt(request.getParameter("quantity")));
            ps.setDouble(5, Double.parseDouble(request.getParameter("price")));
            ps.setInt(6, 0); // popularity default
            ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            ps.setString(8, newImageName);
             ps.setString(9, request.getParameter("description"));

            int inserted = ps.executeUpdate();
            if (inserted > 0) {
                request.setAttribute("message", "Product added successfully with ID: " + newId);
                 request.getRequestDispatcher("/myStaff/controlPanelM.jsp").forward(request, response); 
            } else {
                request.setAttribute("error", "Failed to insert product.");
                 request.getRequestDispatcher("/error.jsp").forward(request, response);
            }

            
request.getRequestDispatcher("/myStaff/controlPanelM.jsp").forward(request, response); 
//            request.getRequestDispatcher("success.jsp").forward(request, response); 

        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Database driver not found: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("error", "SQL error: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
        return "Servlet to add a new product";
    }
}
