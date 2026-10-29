<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.collegeevent.util.DBConnection" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    String sql = "SELECT r.registration_id, s.full_name, s.email, "
               + "e.event_name, r.participation_type, r.team_name, "
               + "r.registration_date, r.status "
               + "FROM registrations r "
               + "JOIN students s ON r.student_id = s.student_id "
               + "JOIN events e ON r.event_id = e.event_id "
               + "ORDER BY r.registration_date DESC";

    int total = 0;
    String dbError = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registrations | CampusConnect</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f5f9;
            color: #202b3c;
        }

        header {
            padding: 22px 5%;
            background: #17243b;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        header h1 { margin: 0; font-size: 24px; }

        .back {
            color: white;
            background: #315bd6;
            padding: 10px 14px;
            border-radius: 7px;
            text-decoration: none;
        }

        main {
            max-width: 1200px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .table-container {
            background: white;
            border-radius: 12px;
            padding: 20px;
            overflow-x: auto;
            box-shadow: 0 4px 16px rgba(20, 35, 60, 0.07);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        th, td {
            padding: 13px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            font-size: 14px;
        }

        th { background: #edf1f8; }

        .status {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 15px;
            background: #e7f8ee;
            color: #17663a;
        }

        .empty, .error {
            padding: 18px;
            border-radius: 8px;
        }

        .empty { background: #f1f5f9; }
        .error { background: #fff0ef; color: #b42318; }
    </style>
</head>
<body>
    <header>
        <h1>Student Registrations</h1>
        <a class="back"
           href="<%= request.getContextPath() %>/admin/dashboard.jsp">
            Back to Dashboard
        </a>
    </header>

    <main>
        <h2>All Event Registrations</h2>
        <p>Review student registrations and participation details.</p>

        <div class="table-container">
            <%
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {

                    boolean hasRows = false;
            %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Event</th>
                            <th>Participation</th>
                            <th>Team</th>
                            <th>Registered On</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        while (rs.next()) {
                            hasRows = true;
                            total++;
                    %>
                        <tr>
                            <td><%= rs.getInt("registration_id") %></td>
                            <td><%= rs.getString("full_name") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("event_name") %></td>
                            <td><%= rs.getString("participation_type") %></td>
                            <td><%= rs.getString("team_name") == null
                                    ? "—" : rs.getString("team_name") %></td>
                            <td><%= rs.getTimestamp("registration_date") %></td>
                            <td>
                                <span class="status">
                                    <%= rs.getString("status") %>
                                </span>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>

                <% if (!hasRows) { %>
                    <p class="empty">No registrations have been submitted yet.</p>
                <% } %>

            <%
                } catch (Exception e) {
                    application.log("Unable to load admin registrations.", e);
                    dbError = "Unable to load registrations. Check the database schema and server logs.";
                }

                if (dbError != null) {
            %>
                <p class="error"><%= dbError %></p>
            <%
                }
            %>
        </div>

        <p><strong>Total registrations displayed:</strong> <%= total %></p>
    </main>
</body>
</html>

