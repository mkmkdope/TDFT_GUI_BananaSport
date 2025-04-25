<%@ page import="model.Staff" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>
<%@ page import="jakarta.persistence.TypedQuery" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Calendar" %>

<html>
    <head>
        <title>Dashboard</title>
        <link rel="stylesheet" type="text/css" href="../css/admin.css">
        <script type="text/javascript">
            function confirmChange(staffId) {
                if (confirm("Are you sure you want to change this staff member to a manager?")) {
                    window.location.href = "${pageContext.request.contextPath}/myAdmin/changeToManager.jsp?staffId=" + staffId;
                }
            }

            function confirmDelete(staffId) {
                if (confirm("Are you sure you want to delete this staff member?")) {
                    window.location.href = "${pageContext.request.contextPath}/myAdmin/deleteStaff.jsp?staffId=" + staffId;
                }
            }

            function resetSearch() {
                window.location.href = "${pageContext.request.contextPath}/myAdmin/AdminModule.jsp";
            }
        </script>
        <style>
            /* Header Navigation */
            .header-nav {
                background-color: #333;
                overflow: hidden;
                margin-bottom: 20px;
                border-radius: 5px;
            }
            .header-nav a {
                float: left;
                color: white;
                text-align: center;
                padding: 14px 20px;
                text-decoration: none;
                font-size: 16px;
                transition: background-color 0.3s;
            }
            .header-nav a:hover {
                background-color: #555;
            }
            .header-nav a.active {
                background-color: #4CAF50;
            }

            /* Logout Button */
            .logout-btn {
                float: right;
                background-color: #f44336;
                color: white;
                padding: 14px 20px;
                border: none;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
            }
            .logout-btn:hover {
                background-color: #d32f2f;
            }

            /* Reports styling */
            .report-section {
                margin-top: 30px;
                border: 1px solid #ddd;
                padding: 15px;
                border-radius: 5px;
            }
            .reports-nav {
                margin-bottom: 15px;
                background-color: #f1f1f1;
                overflow: hidden;
                border-radius: 5px;
            }
            .reports-nav a {
                float: left;
                display: block;
                color: #333;
                text-align: center;
                padding: 10px 16px;
                text-decoration: none;
                font-size: 14px;
            }
            .reports-nav a:hover {
                background-color: #ddd;
            }
            .reports-nav a.active {
                background-color: #333;
                color: #ffcc00;
            }
            .sales-data {
                margin-top: 20px;
            }
            .section {
                display: none;
            }
            .section.active {
                display: block;
            }

            /* Restricted Access Banner */
            .restricted-banner {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                text-align: center;
                font-weight: bold;
                margin-bottom: 20px;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <h1>Admin Dashboard</h1>
        <!-- Top navigation bar -->
        <div class="header-nav">
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Manage Staff</a>
            <a href="${pageContext.request.contextPath}/myStaff/addProdM.jsp">Add Products</a>
            <a href="${pageContext.request.contextPath}/myStaff/ControlProdM">Modify Products</a>
            <a href="${pageContext.request.contextPath}/CustomerServlet">Manage Customers</a>
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp?section=reports" class="<%= "reports".equals(request.getParameter("section"))%>">Sales Reports</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
        </div>

        <!-- Employee Management Section -->
        <div id="employeeSection" class="section <%= request.getParameter("section") == null || "employees".equals(request.getParameter("section")) ? "active" : ""%>">
            <div style="margin-bottom: 15px;">
                <form action="${pageContext.request.contextPath}/myAdmin/addStaff.jsp" method="get" style="display:inline;">
                    <button>Add new Staff</button>
                </form>
                <form action="${pageContext.request.contextPath}/myAdmin/managerList.jsp" method="get" style="display:inline;">
                    <button>Manager List</button>
                </form>
            </div>

            <h2>Employee List</h2>

            <!-- Search Form -->
            <form method="get" style="margin-bottom: 15px;">
                <input type="hidden" name="section" value="employees">
                <label for="search">Search by Name or Email:</label>
                <input type="text" id="search" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : ""%>">
                <button type="submit">Search</button>
                <button type="button" onclick="resetSearch()">Reset</button>
            </form>

            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <th>Staff ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Position</th>
                    <th>Contact Number</th>
                    <th>Actions</th>
                </tr>
                <%
                    String search = request.getParameter("search");
                    EntityManager em = JPAUtil.getEntityManager();
                    List<Staff> staffList = null;
                    try {
                        String queryStr = "SELECT s FROM Staff s";
                        if (search != null && !search.trim().isEmpty()) {
                            queryStr += " WHERE s.staffName LIKE :search OR s.staffEmail LIKE :search";
                        }
                        TypedQuery<Staff> query = em.createQuery(queryStr, Staff.class);
                        if (search != null && !search.trim().isEmpty()) {
                            query.setParameter("search", "%" + search + "%");
                        }
                        staffList = query.getResultList();
                        for (Staff staff : staffList) {
                %>
                <tr>
                    <td><%= staff.getStaffId()%></td>
                    <td><%= staff.getStaffName()%></td>
                    <td><%= staff.getStaffEmail()%></td>
                    <td><%= staff.getStaffPosition()%></td>
                    <td><%= staff.getStaffContactNumber()%></td>
                    <td>
                        <form action="${pageContext.request.contextPath}/myAdmin/editStaff.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="staffId" value="<%= staff.getStaffId()%>">
                            <button type="submit">Edit</button>
                        </form>
                        <button onclick="confirmDelete(<%= staff.getStaffId()%>)">Delete</button>
                        <button onclick="confirmChange(<%= staff.getStaffId()%>)">Grant Full Access</button>
                    </td>
                </tr>
                <%
                        }
                    } catch (NumberFormatException e) {
                        out.println("<p>Invalid Staff ID format. Please enter a valid number.</p>");
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Error retrieving staff list: " + e.getMessage() + "</p>");
                    } finally {
                        em.close();
                    }
                %>
            </table>
        </div>

        <!-- Sales Report Section -->
        <div id="reportSection" class="section <%= "reports".equals(request.getParameter("section")) ? "active" : ""%>">
            <h2>Sales Reports</h2>

            <!-- Reports Navigation -->
            <div class="reports-nav">
                <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp?section=reports&report=salesByPeriod" class="<%= "salesByPeriod".equals(request.getParameter("report")) || request.getParameter("report") == null ? "active" : ""%>">Sales by Period</a>
                <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp?section=reports&report=top10Products" class="<%= "top10Products".equals(request.getParameter("report")) ? "active" : ""%>">Top 10 Products</a>
            </div>

            <!-- Sales by Period Report -->
            <div id="salesByPeriodSection" class="<%= "salesByPeriod".equals(request.getParameter("report")) || (request.getParameter("report") == null && "reports".equals(request.getParameter("section"))) ? "active" : ""%> section">
                <h3>Sales by Period</h3>

                <form method="get" action="">
                    <input type="hidden" name="section" value="reports">
                    <input type="hidden" name="report" value="salesByPeriod">
                    <select name="reportType">
                        <option value="daily" <%= "daily".equals(request.getParameter("reportType")) ? "selected" : ""%>>Daily</option>
                        <option value="monthly" <%= "monthly".equals(request.getParameter("reportType")) ? "selected" : ""%>>Monthly</option>
                        <option value="yearly" <%= "yearly".equals(request.getParameter("reportType")) ? "selected" : ""%>>Yearly</option>
                    </select>

                    <%
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String today = sdf.format(new Date());
                    %>

                    <input type="date" name="startDate" value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : today%>">
                    <input type="date" name="endDate" value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : today%>">
                    <button type="submit">Generate Report</button>
                </form>

                <%
                    if ("salesByPeriod".equals(request.getParameter("report"))) {
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            // Get database connection
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/tree", "tree", "tree");

                            String reportType = request.getParameter("reportType");
                            if (reportType == null) {
                                reportType = "daily"; // Default to daily if not specified
                            }
                            
                            // Use the existing sdf and today variables instead of redeclaring them
                            String startDate = request.getParameter("startDate");
                            String endDate = request.getParameter("endDate");
                            
                            // If dates are null, use today's date
                            if (startDate == null || startDate.trim().isEmpty()) {
                                startDate = today;
                            }
                            
                            if (endDate == null || endDate.trim().isEmpty()) {
                                endDate = today;
                            }
                            
                            StringBuilder sqlQuery = new StringBuilder();

                            // Start building the SELECT clause
                            sqlQuery.append("SELECT ");

                            if ("daily".equals(reportType)) {
                                sqlQuery.append("DATE(order_date) as period, ");
                            } else if ("monthly".equals(reportType)) {
                                sqlQuery.append("YEAR(order_date) as yr, MONTH(order_date) as mn, ");
                            } else if ("yearly".equals(reportType)) {
                                sqlQuery.append("YEAR(order_date) as period, ");
                            }

                            sqlQuery.append("COUNT(order_id) as order_count, SUM(total_amount) as revenue, ")
                                    .append("SUM(sales_tax) as total_tax, SUM(shipping_fee) as total_shipping ")
                                    .append("FROM Orders ")
                                    .append("WHERE order_date BETWEEN ? AND ? ");
                                    
                            // Add the appropriate GROUP BY clause based on report type
                            if ("daily".equals(reportType)) {
                                sqlQuery.append("GROUP BY DATE(order_date) ");
                            } else if ("monthly".equals(reportType)) {
                                sqlQuery.append("GROUP BY YEAR(order_date), MONTH(order_date) ");
                            } else if ("yearly".equals(reportType)) {
                                sqlQuery.append("GROUP BY YEAR(order_date) ");
                            }
                            
                            // Add the appropriate ORDER BY clause
                            if ("daily".equals(reportType)) {
                                sqlQuery.append("ORDER BY DATE(order_date)");
                            } else if ("monthly".equals(reportType)) {
                                sqlQuery.append("ORDER BY YEAR(order_date), MONTH(order_date)");
                            } else if ("yearly".equals(reportType)) {
                                sqlQuery.append("ORDER BY YEAR(order_date)");
                            }

                            pstmt = conn.prepareStatement(sqlQuery.toString());
                            
                            // Format dates properly for timestamp
                            java.sql.Timestamp startTimestamp = null;
                            java.sql.Timestamp endTimestamp = null;
                            
                            try {
                                // Parse the dates and create proper timestamps
                                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                                
                                java.util.Date startUtilDate = inputFormat.parse(startDate);
                                java.util.Date endUtilDate = inputFormat.parse(endDate);
                                
                                // Add time components
                                Calendar startCal = Calendar.getInstance();
                                startCal.setTime(startUtilDate);
                                startCal.set(Calendar.HOUR_OF_DAY, 0);
                                startCal.set(Calendar.MINUTE, 0);
                                startCal.set(Calendar.SECOND, 0);
                                
                                Calendar endCal = Calendar.getInstance();
                                endCal.setTime(endUtilDate);
                                endCal.set(Calendar.HOUR_OF_DAY, 23);
                                endCal.set(Calendar.MINUTE, 59);
                                endCal.set(Calendar.SECOND, 59);
                                
                                startTimestamp = new java.sql.Timestamp(startCal.getTimeInMillis());
                                endTimestamp = new java.sql.Timestamp(endCal.getTimeInMillis());
                            } catch (Exception e) {
                                throw new Exception("Error formatting dates: " + e.getMessage());
                            }
                            
                            pstmt.setTimestamp(1, startTimestamp);
                            pstmt.setTimestamp(2, endTimestamp);
                            
                            rs = pstmt.executeQuery();

                %>
                <div class="sales-data">
                    <table border="1" cellpadding="5" cellspacing="0">
                        <tr>
                            <th>Period</th>
                            <th>Order Count</th>
                            <th>Revenue</th>
                            <th>Tax</th>
                            <th>Shipping</th>
                            <th>Net Revenue</th>
                        </tr>
                        <%                                double totalRevenue = 0;
                            int totalOrders = 0;

                            while (rs.next()) {
                                String period;
                                
                                // Handle different report types
                                if ("monthly".equals(reportType)) {
                                    int year = rs.getInt("yr");
                                    int month = rs.getInt("mn");
                                    period = year + "-" + month;
                                } else {
                                    period = rs.getString("period");
                                }
                                
                                int orderCount = rs.getInt("order_count");
                                double revenue = rs.getDouble("revenue");
                                double tax = rs.getDouble("total_tax");
                                double shipping = rs.getDouble("total_shipping");
                                double netRevenue = revenue - tax - shipping;

                                totalRevenue += revenue;
                                totalOrders += orderCount;
                        %>
                        <tr>
                            <td><%= period%></td>
                            <td><%= orderCount%></td>
                            <td>$<%= String.format("%.2f", revenue)%></td>
                            <td>$<%= String.format("%.2f", tax)%></td>
                            <td>$<%= String.format("%.2f", shipping)%></td>
                            <td>$<%= String.format("%.2f", netRevenue)%></td>
                        </tr>
                        <% }%>
                        <tr style="font-weight: bold; background-color: #f2f2f2;">
                            <td>Total</td>
                            <td><%= totalOrders%></td>
                            <td>$<%= String.format("%.2f", totalRevenue)%></td>
                            <td colspan="3"></td>
                        </tr>
                    </table>
                </div>
                <%
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<p>Error generating sales report: " + e.getMessage() + "</p>");
                        } finally {
                            try {
                                if (rs != null) {
                                    rs.close();
                                }
                            } catch (Exception e) {
                            }
                            try {
                                if (pstmt != null) {
                                    pstmt.close();
                                }
                            } catch (Exception e) {
                            }
                            try {
                                if (conn != null) {
                                    conn.close();
                                }
                            } catch (Exception e) {
                            }
                        }
                    }
                %>
            </div>

            <!-- Top 10 Products Report -->
            <div id="top10ProductsSection" class="<%= "top10Products".equals(request.getParameter("report")) ? "active" : ""%> section">
                <h3>Top 10 Products by Sales</h3>

                <form method="get" action="">
                    <input type="hidden" name="section" value="reports">
                    <input type="hidden" name="report" value="top10Products">
                    <label for="period">Time Period:</label>
                    <select name="period" id="period">
                        <option value="7" <%= "7".equals(request.getParameter("period")) ? "selected" : ""%>>Last 7 Days</option>
                        <option value="30" <%= "30".equals(request.getParameter("period")) ? "selected" : ""%>>Last 30 Days</option>
                        <option value="90" <%= "90".equals(request.getParameter("period")) ? "selected" : ""%>>Last 90 Days</option>
                        <option value="365" <%= "365".equals(request.getParameter("period")) ? "selected" : ""%>>Last Year</option>
                        <option value="all" <%= "all".equals(request.getParameter("period")) ? "selected" : ""%>>All Time</option>
                    </select>
                    <button type="submit">Generate Report</button>
                </form>

                <%
                    if ("top10Products".equals(request.getParameter("report"))) {
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            // Get database connection
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/tree", "tree", "tree");

                            String period = request.getParameter("period");
                            if (period == null) {
                                period = "30"; // Default to last 30 days if no period is specified
                            }

                            StringBuilder sqlQuery = new StringBuilder();
                            sqlQuery.append("SELECT p.product_id, p.product_name, p.product_category, ")
                                    .append("SUM(od.quantity) AS total_quantity, ")
                                    .append("SUM(od.quantity * od.price) AS total_revenue ")
                                    .append("FROM Order_Details od ")
                                    .append("JOIN Orders o ON od.order_id = o.order_id ")
                                    .append("JOIN tree.Products p ON od.product_id = p.product_id ");

                            if (!"all".equals(period)) {
                                sqlQuery.append("WHERE o.order_date >= ? ");
                            }

                            sqlQuery.append("GROUP BY p.product_id, p.product_name, p.product_category ")
                                    .append("ORDER BY total_quantity DESC ")
                                    .append("FETCH FIRST 10 ROWS ONLY");

                            pstmt = conn.prepareStatement(sqlQuery.toString());

                            if (!"all".equals(period)) {
                                // Calculate the date X days ago
                                Calendar cal = Calendar.getInstance();
                                cal.add(Calendar.DAY_OF_MONTH, -Integer.parseInt(period));
                                Date startDate = cal.getTime();
                                pstmt.setTimestamp(1, new Timestamp(startDate.getTime()));
                            }

                            rs = pstmt.executeQuery();

                %>
                <div class="sales-data">
                    <table border="1" cellpadding="5" cellspacing="0">
                        <tr>
                            <th>Rank</th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Category</th>
                            <th>Quantity Sold</th>
                            <th>Revenue</th>
                        </tr>
                        <%                                int rank = 1;
                            while (rs.next()) {
                                String productId = rs.getString("product_id");
                                String productName = rs.getString("product_name");
                                String category = rs.getString("product_category");
                                int quantity = rs.getInt("total_quantity");
                                double revenue = rs.getDouble("total_revenue");
                        %>
                        <tr>
                            <td><%= rank++%></td>
                            <td><%= productId%></td>
                            <td><%= productName%></td>
                            <td><%= category%></td>
                            <td><%= quantity%></td>
                            <td>$<%= String.format("%.2f", revenue)%></td>
                        </tr>
                        <% } %>
                    </table>
                </div>
                <%
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<p>Error generating top products report: " + e.getMessage() + "</p>");
                        } finally {
                            try {
                                if (rs != null) {
                                    rs.close();
                                }
                            } catch (Exception e) {
                            }
                            try {
                                if (pstmt != null) {
                                    pstmt.close();
                                }
                            } catch (Exception e) {
                            }
                            try {
                                if (conn != null) {
                                    conn.close();
                                }
                            } catch (Exception e) {
                            }
                        }
                    }
                %>
            </div>
        </div>
    </body>
</html>