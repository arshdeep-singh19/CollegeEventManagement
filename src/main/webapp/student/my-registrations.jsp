<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.collegeevent.util.DBConnection" %>

<%
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/student/login.jsp"
        );
        return;
    }

    int loggedInStudentId =
        (Integer) session.getAttribute("studentId");
%>
<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Registrations | CampusConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">


<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        background: #f4f7fb;
        color: #1f2937;
        font-family: Arial, sans-serif;
    }

    .navbar {
        background: #172554;
        color: white;
        padding: 18px 7%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
    }

    .brand {
        font-size: 23px;
        font-weight: bold;
    }

    .navbar a {
        color: white;
        text-decoration: none;
        margin-left: 18px;
        font-size: 14px;
    }

    .navbar a:hover {
        color: #93c5fd;
    }

    .container {
        max-width: 1100px;
        margin: 35px auto;
        padding: 0 20px;
    }

    .page-heading {
        margin-bottom: 25px;
    }

    .page-heading h1 {
        margin-bottom: 8px;
        color: #172554;
    }

    .page-heading p {
        color: #64748b;
        line-height: 1.6;
    }

    .summary {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 18px;
        margin-bottom: 30px;
    }

    .summary-card {
        background: white;
        padding: 22px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        border-left: 4px solid #2563eb;
    }

    .summary-card h3 {
        margin: 0 0 10px;
        font-size: 15px;
        color: #64748b;
    }

    .summary-card .number {
        font-size: 30px;
        font-weight: bold;
        color: #172554;
    }

    .registrations-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 18px;
    }

    .registrations-heading h2 {
        color: #172554;
    }

    .event-card {
        background: white;
        padding: 24px;
        margin-bottom: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    }

    .event-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 15px;
        flex-wrap: wrap;
    }

    .event-top h3 {
        margin: 0 0 8px;
        color: #172554;
        font-size: 21px;
    }

    .category {
        display: inline-block;
        background: #dbeafe;
        color: #1d4ed8;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 12px;
        margin-bottom: 10px;
    }

    .status {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }

    .registered {
        background: #dcfce7;
        color: #166534;
    }

    .pending {
        background: #fef3c7;
        color: #92400e;
    }

    .cancelled {
        background: #fee2e2;
        color: #991b1b;
    }

    .event-info {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
        margin: 20px 0;
        color: #475569;
        font-size: 14px;
    }

    .event-info p {
        margin: 0;
        line-height: 1.6;
    }

    .event-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        border-top: 1px solid #e5e7eb;
        padding-top: 18px;
    }

    .btn {
        display: inline-block;
        padding: 10px 16px;
        border: none;
        border-radius: 7px;
        text-decoration: none;
        font-size: 14px;
        cursor: pointer;
        font-weight: bold;
    }

    .btn-primary {
        background: #2563eb;
        color: white;
    }

    .btn-primary:hover {
        background: #1d4ed8;
    }

    .btn-danger {
        background: #fee2e2;
        color: #991b1b;
    }

    .btn-danger:hover {
        background: #fecaca;
    }

    .btn-disabled {
        background: #e5e7eb;
        color: #6b7280;
        cursor: not-allowed;
    }

    .notice {
        background: #eff6ff;
        border: 1px solid #bfdbfe;
        color: #1e40af;
        padding: 15px;
        border-radius: 8px;
        line-height: 1.6;
        font-size: 14px;
        margin-top: 25px;
    }

    .empty-message {
        display: none;
        background: white;
        padding: 35px;
        text-align: center;
        border-radius: 12px;
        color: #64748b;
    }

    footer {
        text-align: center;
        padding: 25px;
        color: #64748b;
        font-size: 13px;
    }

    @media (max-width: 650px) {
        .navbar {
            padding: 18px 5%;
        }

        .navbar nav {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .navbar a {
            margin-left: 0;
        }

        .summary {
            grid-template-columns: 1fr;
        }

        .event-info {
            grid-template-columns: 1fr;
        }

        .container {
            margin-top: 25px;
        }
    }
</style>


</head>

<body>

<header class="navbar">
    <div class="brand">CampusConnect</div>


<nav>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp">Dashboard</a>
    <a href="${pageContext.request.contextPath}/student/event-details.jsp">Events</a>
    <a href="${pageContext.request.contextPath}/student/my-registrations.jsp">My Registrations</a>
    <a href="${pageContext.request.contextPath}/student/login.jsp">Logout</a>
</nav>


</header>

<main class="container">


<section class="page-heading">
    <h1>My Registrations</h1>
    <p>View your event registrations and check their current status.</p>
</section>

<%
    int totalRegistrations = 0;
    int activeRegistrations = 0;
    int cancelledRegistrations = 0;

    String countSql =
        "SELECT COUNT(*) AS total, " +
        "SUM(CASE WHEN status = 'Registered' THEN 1 ELSE 0 END) AS active, " +
        "SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled " +
        "FROM registrations WHERE student_id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement ps = connection.prepareStatement(countSql)) {

        ps.setInt(1, loggedInStudentId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalRegistrations = rs.getInt("total");
                activeRegistrations = rs.getInt("active");
                cancelledRegistrations = rs.getInt("cancelled");
            }
        }
    } catch (Exception e) {
        application.log("Unable to count student registrations.", e);
        throw new jakarta.servlet.ServletException(e);
    }
%>

<section class="summary">
    <div class="summary-card">
        <h3>Total Registrations</h3>
        <div class="number"><%= totalRegistrations %></div>
    </div>

    <div class="summary-card">
        <h3>Active Registrations</h3>
        <div class="number"><%= activeRegistrations %></div>
    </div>

    <div class="summary-card">
        <h3>Cancelled Registrations</h3>
        <div class="number"><%= cancelledRegistrations %></div>
    </div>
</section>

<section>
    <div class="registrations-heading">
        <h2>Your Registered Events</h2>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/student/dashboard.jsp">
            Explore Events
        </a>
    </div>

    <%
    String registrationsSql =
        "SELECT r.registration_id, r.participation_type, r.team_name, " +
        "r.registration_date, r.status, r.department, r.study_year, " +
        "e.event_name, e.event_code, e.event_date, e.venue, e.description " +
        "FROM registrations r " +
        "JOIN events e ON r.event_id = e.event_id " +
        "WHERE r.student_id = ? " +
        "ORDER BY r.registration_date DESC";

    boolean hasRegistrations = false;

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement ps = connection.prepareStatement(registrationsSql)) {

        ps.setInt(1, loggedInStudentId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                hasRegistrations = true;

                String eventName = rs.getString("event_name");
                String eventCode = rs.getString("event_code");
                String eventDate = rs.getString("event_date");
                String venue = rs.getString("venue");
                String description = rs.getString("description");
                String participationType = rs.getString("participation_type");
                String teamName = rs.getString("team_name");
                String status = rs.getString("status");

                if (status == null) {
                    status = "Registered";
                }

                String statusClass = status.equalsIgnoreCase("Cancelled")
                    ? "cancelled" : "registered";
%>

<article class="event-card">
    <div class="event-top">
        <div>
            <span class="category">College Event</span>
            <h3><%= eventName == null ? "Event" : eventName %></h3>
            <p><%= description == null ? "" : description %></p>
        </div>

        <span class="status <%= statusClass %>">
            <%= status %>
        </span>
    </div>

    <div class="event-info">
        <p><strong>Event Date:</strong>
            <%= eventDate == null ? "To be announced" : eventDate %>
        </p>

        <p><strong>Venue:</strong>
            <%= venue == null ? "To be announced" : venue %>
        </p>

        <p><strong>Participation:</strong>
            <%= participationType == null ? "Individual" : participationType %>
        </p>

        <p><strong>Team Name:</strong>
            <%= teamName == null || teamName.isBlank()
                ? "Not applicable" : teamName %>
        </p>
    </div>

    <div class="event-actions">
        <a class="btn btn-primary"
           href="<%= request.getContextPath() %>/student/event-details.jsp?event=<%= eventCode %>">
            View Event
        </a>
    </div>
</article>

<%
            }
        }
    } catch (Exception e) {
        application.log("Unable to load student registrations.", e);
        throw new jakarta.servlet.ServletException(e);
    }
%>

<% if (!hasRegistrations) { %>
    <div class="empty-message" style="display:block;">
        <h3>No registrations yet</h3>
        <p>Your registered events will appear here after you register.</p>

        <a class="btn btn-primary"
           href="<%= request.getContextPath() %>/student/dashboard.jsp">
            Explore Events
        </a>
    </div>
<% } %>

    <div class="empty-message" id="emptyMessage">
        <h3>No active registrations</h3>
        <p>Explore available events and register for one to get started.</p>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/student/dashboard.jsp">
            Explore Events
        </a>
    </div>
</section>

</main>

<footer>
    &copy; 2026 CampusConnect | College Event Management System
</footer>

</body>
</html>
