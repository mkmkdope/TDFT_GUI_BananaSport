 package util;

import java.sql.*;

public class DBConnection {

    private final String host = "jdbc:derby://localhost:1527/tree";
    private final String user = "tree";
    private final String password = "tree";

    private java.sql.Connection conn;

    public DBConnection() {
    }

    public java.sql.Connection getConnection() {
        try {
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("Database connected successfully.");
        } catch (SQLException ex) {
            System.out.println("Database connection failed: " + ex.getMessage());
        }
        return conn;
    }

    public static void main(String[] args) {
        DBConnection db = new DBConnection();
        java.sql.Connection conn = db.getConnection();
        // Optional: Test if connected
        if (conn != null) {
            System.out.println("Connection is not null, connected!");
        } else {
            System.out.println("Connection failed.");
        }
    }
}
