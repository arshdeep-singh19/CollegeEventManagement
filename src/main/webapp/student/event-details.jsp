<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.collegeevent.util.DBConnection" %>

<%!
private String escapeHtml(String value) {
    if (value == null) {
        return "";
    }

    return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
}
%>

<%
String eventId = request.getParameter("id");
String eventCode = request.getParameter("event");

if ((eventId == null || eventId.trim().isEmpty()) &&
    (eventCode == null || eventCode.trim().isEmpty())) {

    response.sendError(400, "Please select a valid event.");
    return;
}

String eventName = "";
String date = "";
String venue = "";
String description = "";
String category = "Campus Event";
String time = "To be announced";
String highlights = "Event information will be announced soon.";
String guidelines = "Please follow the instructions provided by the event organizers.";
String organizer = "CampusConnect Event Team";
String icon = "&#127891;";

String sql;

if (eventId != null && !eventId.trim().isEmpty()) {
    sql = "SELECT event_id, event_code, event_name, event_date, venue, description " +
          "FROM events WHERE event_id = ?";
} else {
    sql = "SELECT event_id, event_code, event_name, event_date, venue, description " +
          "FROM events WHERE event_code = ?";
}

try (Connection connection = DBConnection.getConnection();
     PreparedStatement statement = connection.prepareStatement(sql)) {

    if (eventId != null && !eventId.trim().isEmpty()) {
    try {
        statement.setInt(1, Integer.parseInt(eventId.trim()));
    } catch (NumberFormatException e) {
        response.sendError(400, "Invalid event ID.");
        return;
    }
} else {
    if (eventCode == null || eventCode.trim().isEmpty()) {
        response.sendError(400, "Please select a valid event.");
        return;
    }

    statement.setString(1, eventCode.trim());
}

    try (ResultSet rs = statement.executeQuery()) {
        if (rs.next()) {
            eventCode = rs.getString("event_code");
            eventName = rs.getString("event_name");

            java.sql.Date eventDate = rs.getDate("event_date");
            date = eventDate != null
                    ? eventDate.toString()
                    : "To be announced";

            venue = rs.getString("venue");
            description = rs.getString("description");

            if (venue == null || venue.trim().isEmpty()) {
                venue = "To be announced";
            }

            if (description == null || description.trim().isEmpty()) {
                description = "More event details will be announced soon.";
            }

            String code = eventCode.toLowerCase();

            if (code.contains("music")) {
                category = "Music & Arts";
                icon = "&#127925;";
            } else if (code.contains("cricket")) {
                category = "Sports";
                icon = "&#127951;";
            } else if (code.contains("cultural")) {
                category = "Cultural";
                icon = "&#127917;";
            } else if (code.contains("ai-workshop")) {
                category = "Technology";
                icon = "&#129302;";
            } else if (code.contains("startup")) {
                category = "Business & Innovation";
                icon = "&#128640;";
            } else if (code.contains("codefest")) {
                category = "Technology";
                icon = "&#128187;";
            }

            highlights = description;
        } else {
            response.sendError(404, "Event not found.");
            return;
        }
    }

} catch (SQLException e) {
    throw new jakarta.servlet.ServletException(
        "Unable to load event details.", e);
}

String safeId = escapeHtml(eventCode);
String safeName = escapeHtml(eventName);
String safeCategory = escapeHtml(category);
String safeDate = escapeHtml(date);
String safeTime = escapeHtml(time);
String safeVenue = escapeHtml(venue);
String safeDescription = escapeHtml(description);
String safeHighlights = escapeHtml(highlights);
String safeGuidelines = escapeHtml(guidelines);
String safeOrganizer = escapeHtml(organizer);
%>



<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= safeName %> | CampusConnect</title>


<link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f4f7fb;
        color: #1f2937;
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

    .navbar nav {
        display: flex;
        flex-wrap: wrap;
        gap: 18px;
    }

    .navbar a {
        color: white;
        text-decoration: none;
        font-size: 14px;
    }

    .navbar a:hover {
        color: #93c5fd;
    }

    .container {
        max-width: 1050px;
        margin: 35px auto;
        padding: 0 20px;
    }

    .event-hero {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
        color: white;
        border-radius: 15px;
        padding: 35px;
        display: flex;
        align-items: center;
        gap: 25px;
        margin-bottom: 25px;
    }

    .event-icon {
        width: 115px;
        height: 115px;
        background: rgba(255, 255, 255, 0.15);
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 65px;
        flex-shrink: 0;
    }

    .event-hero h1 {
        font-size: 32px;
        margin: 10px 0;
    }

    .category-badge {
        display: inline-block;
        background: #dbeafe;
        color: #1d4ed8;
        padding: 7px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: bold;
    }

    .event-hero p {
        color: #dbeafe;
        line-height: 1.7;
        margin-bottom: 0;
    }

    .content-grid {
        display: grid;
        grid-template-columns: 1.6fr 1fr;
        gap: 22px;
    }

    .card {
        background: white;
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 22px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    }

    .card h2 {
        color: #172554;
        font-size: 21px;
        margin-top: 0;
        margin-bottom: 17px;
    }

    .card p {
        color: #64748b;
        font-size: 14px;
        line-height: 1.8;
    }

    .event-info {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 18px;
    }

    .info-item {
        background: #f8fafc;
        padding: 15px;
        border-radius: 8px;
    }

    .info-item span {
        display: block;
        color: #64748b;
        font-size: 12px;
        margin-bottom: 7px;
    }

    .info-item strong {
        color: #172554;
        font-size: 14px;
        line-height: 1.5;
    }

    .list-item {
        padding: 10px 0;
        border-bottom: 1px solid #e5e7eb;
        color: #475569;
        font-size: 14px;
        line-height: 1.6;
    }

    .list-item:last-child {
        border-bottom: none;
    }

    .organizer {
        background: #eff6ff;
        border: 1px solid #bfdbfe;
        border-radius: 9px;
        padding: 16px;
        color: #1e40af;
        font-size: 14px;
        line-height: 1.7;
    }

    .btn {
        display: inline-block;
        padding: 12px 18px;
        border-radius: 7px;
        text-decoration: none;
        text-align: center;
        font-size: 14px;
        font-weight: bold;
    }

    .btn-primary {
        background: #2563eb;
        color: white;
    }

    .btn-primary:hover {
        background: #1d4ed8;
    }

    .btn-secondary {
        background: #e5e7eb;
        color: #374151;
    }

    .button-group {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 20px;
    }

    .notice {
        margin-top: 5px;
        padding: 15px;
        background: #eff6ff;
        border: 1px solid #bfdbfe;
        border-radius: 8px;
        color: #1e40af;
        font-size: 14px;
        line-height: 1.7;
    }

    footer {
        text-align: center;
        padding: 25px;
        color: #64748b;
        font-size: 13px;
    }

    @media (max-width: 750px) {
        .content-grid {
            grid-template-columns: 1fr;
        }

        .event-hero {
            align-items: flex-start;
            flex-direction: column;
            padding: 25px;
        }

        .event-hero h1 {
            font-size: 27px;
        }

        .event-icon {
            width: 85px;
            height: 85px;
            font-size: 48px;
        }
    }

    @media (max-width: 500px) {
        .event-info {
            grid-template-columns: 1fr;
        }

        .navbar {
            padding: 18px 5%;
        }

        .container {
            margin-top: 22px;
        }
    }
</style>


</head>

<body>

<header class="navbar">
    <div class="brand">CampusConnect</div>


<nav>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp">Dashboard</a>
    <a href="${pageContext.request.contextPath}/student/events.jsp">Events</a>
    <a href="${pageContext.request.contextPath}/student/my-registrations.jsp">My Registrations</a>
    <a href="${pageContext.request.contextPath}/student/profile.jsp">My Profile</a>
    <a href="${pageContext.request.contextPath}/student/login.jsp">Logout</a>
</nav>


</header>

<main class="container">


<section class="event-hero">
    <div class="event-icon"><%= icon %></div>

    <div>
        <span class="category-badge"><%= safeCategory %></span>
        <h1><%= safeName %></h1>
        <p><%= safeDescription %></p>
    </div>
</section>

<div class="content-grid">

    <div>
        <section class="card">
            <h2>Event Overview</h2>

            <p><%= safeDescription %></p>

            <h2 style="margin-top: 25px;">Event Highlights</h2>

            <%
                String[] highlightItems = highlights.split("; ");
                for (String item : highlightItems) {
            %>
                <div class="list-item">
                    &#10003; <%= escapeHtml(item) %>
                </div>
            <%
                }
            %>
        </section>

        <section class="card">
            <h2>Participation Guidelines</h2>
            <p><%= safeGuidelines %></p>

            <h2 style="margin-top: 22px;">Organized By</h2>

            <div class="organizer">
                <strong><%= safeOrganizer %></strong><br>
                CampusConnect College Event Management System
            </div>
        </section>
    </div>

    <aside>
        <section class="card">
            <h2>Event Information</h2>

            <div class="event-info">
                <div class="info-item">
                    <span>EVENT DATE</span>
                    <strong><%= safeDate %></strong>
                </div>

                <div class="info-item">
                    <span>TIME</span>
                    <strong><%= safeTime %></strong>
                </div>

                <div class="info-item" style="grid-column: 1 / -1;">
                    <span>VENUE</span>
                    <strong><%= safeVenue %></strong>
                </div>

                <div class="info-item" style="grid-column: 1 / -1;">
                    <span>CATEGORY</span>
                    <strong><%= safeCategory %></strong>
                </div>
            </div>

            <div class="button-group">
                <a class="btn btn-primary"
                   style="width: 100%;"
                   href="${pageContext.request.contextPath}/student/event-registration.jsp?id=<%= safeId %>">
                    Register for This Event
                </a>

                <a class="btn btn-secondary"
                   style="width: 100%;"
                   href="${pageContext.request.contextPath}/student/events.jsp">
                    Back to All Events
                </a>
            </div>
        </section>
    </aside>

</div>

<div class="notice">
    <strong> Notice:</strong> Event information is loaded from the 
    CampusConnect database. Event dates and venues will be 
    displayed when announced.
</div>


</main>

<footer>
    &copy; 2026 CampusConnect | College Event Management System
</footer>

</body>
</html>
