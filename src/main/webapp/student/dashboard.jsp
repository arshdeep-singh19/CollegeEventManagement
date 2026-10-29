<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

    <%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
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

String studentName =
    (String) session.getAttribute("studentName");

String studentEmail =
    (String) session.getAttribute("studentEmail");

List<String[]> myRegistrations = new ArrayList<>();

String registrationSql =
    "SELECT e.event_name, e.event_date, e.venue, r.status " +
    "FROM registrations r " +
    "JOIN events e ON r.event_id = e.event_id " +
    "WHERE r.student_id = ? " +
    "ORDER BY r.registration_date DESC";

try (Connection connection = DBConnection.getConnection();
    PreparedStatement statement =
    connection.prepareStatement(registrationSql)) {

    statement.setInt(1, loggedInStudentId);

    try (ResultSet rs = statement.executeQuery()) {
        while (rs.next()) {
            String eventName = rs.getString("event_name");
            String eventDate = rs.getString("event_date");
            String venue = rs.getString("venue");
            String status = rs.getString("status");

            myRegistrations.add(new String[] {
                eventName,
                eventDate,
                venue,
                status
            });
        }
    }

} catch (SQLException e) {
    throw new ServletException(
        "Unable to load your event registrations.", e);
}

    List<String[]> events = new ArrayList<>();

    String eventsSql =
        "SELECT event_id, event_code, event_name, event_date, venue, description " +
        "FROM events ORDER BY event_id";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
             connection.prepareStatement(eventsSql);
         ResultSet rs = statement.executeQuery()) {

        while (rs.next()) {
            events.add(new String[] {
                rs.getString("event_id"),
                rs.getString("event_code"),
                rs.getString("event_name"),
                rs.getString("event_date"),
                rs.getString("venue"),
                rs.getString("description")
            });
        }

    } catch (SQLException e) {
        throw new ServletException("Unable to load events.", e);
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Dashboard | CampusConnect</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/style.css">

    <style>
        /* ===== GENERAL STYLES ===== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #1e293b;
            line-height: 1.6;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button,
        input {
            font: inherit;
        }

        button {
            cursor: pointer;
        }

        .dashboard-container {
            max-width: 1400px;
            margin: auto;
            padding: 24px 5%;
        }

        /* ===== NAVIGATION BAR ===== */

        .dashboard-navbar {
            background: #ffffff;
            padding: 16px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }

        .dashboard-logo {
            font-size: 25px;
            font-weight: 800;
            color: #2563eb;
        }

        .dashboard-logo span {
            color: #0f172a;
        }

        .dashboard-nav-links {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
        }

        .dashboard-nav-links a {
            color: #475569;
            font-size: 14px;
            font-weight: 600;
            transition: color 0.2s;
        }

        .dashboard-nav-links a:hover {
            color: #2563eb;
        }

        .nav-profile {
            background: #eff6ff;
            color: #1d4ed8 !important;
            padding: 9px 15px;
            border-radius: 8px;
        }

        .nav-logout {
            color: #dc2626 !important;
        }

        /* ===== WELCOME BANNER ===== */

        .welcome-banner {
            margin-top: 28px;
            padding: 35px;
            border-radius: 18px;
            background: linear-gradient(120deg, #1d4ed8, #6366f1);
            color: #ffffff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 24px;
            overflow: hidden;
        }

        .welcome-banner h1 {
            font-size: clamp(25px, 4vw, 36px);
            margin-bottom: 10px;
            line-height: 1.3;
        }

        .welcome-banner p {
            color: #e0e7ff;
            font-size: 15px;
        }

        .welcome-banner .banner-label {
            display: inline-block;
            margin-bottom: 12px;
            padding: 5px 12px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.16);
            font-size: 12px;
            font-weight: bold;
            letter-spacing: 0.5px;
        }

        .banner-emoji {
            font-size: 85px;
            flex-shrink: 0;
        }

        /* ===== SEARCH BAR ===== */

        .dashboard-search {
            margin-top: 28px;
            display: flex;
            gap: 12px;
        }

        .dashboard-search input {
            width: 100%;
            padding: 14px 17px;
            border: 1px solid #dbe3ef;
            border-radius: 10px;
            background: #ffffff;
            outline: none;
        }

        .dashboard-search input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .primary-button {
            border: none;
            border-radius: 9px;
            padding: 12px 20px;
            background: #2563eb;
            color: #ffffff;
            font-weight: bold;
            transition: background 0.2s;
        }

        .primary-button:hover {
            background: #1d4ed8;
        }

        /* ===== SECTION HEADINGS ===== */

        .dashboard-section {
            margin-top: 38px;
            scroll-margin-top: 25px;
        }

        .section-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .section-heading h2 {
            font-size: 23px;
            color: #0f172a;
        }

        .section-heading p {
            color: #64748b;
            font-size: 13px;
            margin-top: 3px;
        }

        .text-link {
            color: #2563eb;
            font-weight: bold;
            font-size: 14px;
        }

        /* ===== EVENT CATEGORIES ===== */

        .category-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
        }

        .category-card {
            padding: 23px 15px;
            background: #ffffff;
            border: 1px solid #e5eaf2;
            border-radius: 13px;
            text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .category-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.07);
        }

        .category-icon {
            display: block;
            font-size: 34px;
            margin-bottom: 9px;
        }

        .category-card h3 {
            font-size: 15px;
            margin-bottom: 4px;
        }

        .category-card p {
            font-size: 12px;
            color: #64748b;
        }

        /* ===== EVENTS GRID ===== */

        .events-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
        }

        .event-card {
            background: #ffffff;
            border: 1px solid #e5eaf2;
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .event-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
        }

        .event-cover {
            min-height: 145px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
        }

        .cover-tech {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        }

        .cover-music {
            background: linear-gradient(135deg, #f3e8ff, #e9d5ff);
        }

        .cover-sports {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
        }

        .cover-culture {
            background: linear-gradient(135deg, #ffedd5, #fed7aa);
        }

        .cover-workshop {
            background: linear-gradient(135deg, #fce7f3, #fbcfe8);
        }

        .cover-business {
            background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
        }

        .event-content {
            padding: 19px;
        }

        .event-category {
            display: inline-block;
            padding: 4px 9px;
            background: #eff6ff;
            color: #1d4ed8;
            border-radius: 5px;
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .event-content h3 {
            font-size: 18px;
            margin-bottom: 9px;
        }

        .event-description {
            color: #64748b;
            font-size: 13px;
            min-height: 42px;
        }

        .event-details {
            border-top: 1px solid #edf0f5;
            margin-top: 15px;
            padding-top: 13px;
            display: grid;
            gap: 7px;
            color: #475569;
            font-size: 12px;
        }

        .event-footer {
            margin-top: 17px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }

        .event-status {
            color: #15803d;
            font-size: 12px;
            font-weight: bold;
        }

        .register-button {
            padding: 9px 13px;
            font-size: 12px;
        }

        /* ===== REGISTRATIONS ===== */

        .registrations-panel {
            background: #ffffff;
            border: 1px solid #e5eaf2;
            border-radius: 14px;
            padding: 22px;
        }

        .demo-notice {
            margin-bottom: 17px;
            padding: 11px 14px;
            border-radius: 8px;
            background: #fffbeb;
            color: #92400e;
            font-size: 13px;
        }

        .registration-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding: 17px 0;
            border-bottom: 1px solid #edf0f5;
        }

        .registration-item:last-child {
            border-bottom: none;
        }

        .registration-info h3 {
            font-size: 15px;
            margin-bottom: 4px;
        }

        .registration-info p {
            color: #64748b;
            font-size: 12px;
        }

        .registration-status {
            display: inline-block;
            background: #dcfce7;
            color: #166534;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            white-space: nowrap;
        }

        /* ===== PROFILE SECTION ===== */

        .profile-panel {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 25px;
            background: #ffffff;
            border: 1px solid #e5eaf2;
            border-radius: 14px;
        }

        .profile-avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #dbeafe;
            color: #1d4ed8;
            font-size: 30px;
            flex-shrink: 0;
        }

        .profile-info h3 {
            font-size: 19px;
            margin-bottom: 4px;
        }

        .profile-info p {
            color: #64748b;
            font-size: 13px;
        }

        .profile-actions {
            margin-left: auto;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .secondary-button {
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: #334155;
            border-radius: 8px;
            font-size: 13px;
            font-weight: bold;
        }

        .secondary-button:hover {
            background: #f8fafc;
        }

        /* ===== LOGOUT SECTION ===== */

        .logout-panel {
            margin-top: 28px;
            padding: 22px;
            border: 1px solid #fee2e2;
            border-radius: 12px;
            background: #fffafa;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        .logout-panel h3 {
            font-size: 16px;
            color: #991b1b;
        }

        .logout-panel p {
            margin-top: 4px;
            font-size: 13px;
            color: #64748b;
        }

        .logout-button {
            display: inline-block;
            background: #dc2626;
            color: #ffffff;
            border-radius: 8px;
            padding: 10px 17px;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;
        }

        .logout-button:hover {
            background: #b91c1c;
        }

        /* ===== FOOTER ===== */

        .dashboard-footer {
            margin-top: 45px;
            padding: 24px 5%;
            background: #ffffff;
            border-top: 1px solid #e5eaf2;
            text-align: center;
            color: #64748b;
            font-size: 13px;
        }

        .dashboard-footer strong {
            color: #2563eb;
        }

        /* ===== RESPONSIVE DESIGN ===== */

        @media (max-width: 1000px) {
            .events-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .category-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 650px) {
            .dashboard-navbar {
                align-items: flex-start;
            }

            .dashboard-nav-links {
                gap: 12px;
            }

            .dashboard-nav-links a {
                font-size: 12px;
            }

            .dashboard-container {
                padding: 18px 4%;
            }

            .welcome-banner {
                padding: 25px 20px;
            }

            .banner-emoji {
                font-size: 48px;
            }

            .welcome-banner p {
                font-size: 13px;
            }

            .dashboard-search {
                flex-direction: column;
            }

            .events-grid {
                grid-template-columns: 1fr;
            }

            .category-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 12px;
            }

            .section-heading h2 {
                font-size: 20px;
            }

            .profile-panel {
                align-items: flex-start;
                flex-wrap: wrap;
            }

            .profile-actions {
                margin-left: 0;
                width: 100%;
            }

            .registration-item {
                align-items: flex-start;
            }

            .logout-panel {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

    <!-- ===== NAVIGATION BAR ===== -->

    <header class="dashboard-navbar">

        <a href="${pageContext.request.contextPath}/index.jsp"
           class="dashboard-logo">
            Campus<span>Connect</span>
        </a>

        <nav class="dashboard-nav-links">
            <a href="#dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/student/events.jsp">Explore Events</a>
            <a href="${pageContext.request.contextPath}/student/my-registrations.jsp">My Registrations</a>
            <a href="${pageContext.request.contextPath}/student/profile.jsp" class="nav-profile">My Profile</a>
            <a href="#logout" class="nav-logout">Logout</a>
        </nav>

    </header>


    <main class="dashboard-container">

        <!-- ===== WELCOME BANNER ===== -->

        <section class="welcome-banner" id="dashboard">

            <div>
                <span class="banner-label">STUDENT DASHBOARD</span>

                <h1>Welcome, <%= studentName %>! 👋</h1>

                <p>
                    Discover exciting campus events, connect with
                    fellow students, and make your college life memorable.
                </p>
            </div>

            <div class="banner-emoji" aria-hidden="true">
                🎓
            </div>

        </section>


        <!-- ===== SEARCH EVENTS ===== -->

        <form class="dashboard-search"
              action="#events"
              method="get">

            <input
                type="search"
                name="search"
                placeholder="Search events, workshops, sports..."
                aria-label="Search campus events">

            <button type="submit" class="primary-button">
                Search Events
            </button>

        </form>


        <!-- ===== EVENT CATEGORIES ===== -->

        <section class="dashboard-section">

            <div class="section-heading">
                <div>
                    <h2>Explore Categories</h2>
                    <p>Find events that match your interests.</p>
                </div>
            </div>

            <div class="category-grid">

                <a href="#events" class="category-card">
                    <span class="category-icon">💻</span>
                    <h3>Technology</h3>
                    <p>Coding and innovation</p>
                </a>

                <a href="#events" class="category-card">
                    <span class="category-icon">🎵</span>
                    <h3>Music & Arts</h3>
                    <p>Music and creativity</p>
                </a>

                <a href="#events" class="category-card">
                    <span class="category-icon">🏆</span>
                    <h3>Sports</h3>
                    <p>Games and tournaments</p>
                </a>

                <a href="#events" class="category-card">
                    <span class="category-icon">🎭</span>
                    <h3>Cultural</h3>
                    <p>Festivals and celebrations</p>
                </a>

            </div>

        </section>


        <!-- ===== FEATURED CAMPUS EVENTS ===== -->

        <section class="dashboard-section" id="events">

            <div class="section-heading">
                <div>
                    <h2>Upcoming Campus Events</h2>
                    <p>Explore opportunities happening around campus.</p>
                </div>

                <a href="#events" class="text-link">
                    View Events ↓
                </a>
            </div>


            <div class="events-grid">

    <% for (String[] event : events) { %>

        <article class="event-card">

            <div class="event-cover
                <%
                    String code = event[1] != null
                        ? event[1].toLowerCase() : "";

                    if (code.contains("codefest")) {
                        out.print("cover-tech");
                    } else if (code.contains("music")) {
                        out.print("cover-music");
                    } else if (code.contains("cricket")) {
                        out.print("cover-sports");
                    } else if (code.contains("cultural")) {
                        out.print("cover-culture");
                    } else if (code.contains("ai-workshop")) {
                        out.print("cover-workshop");
                    } else if (code.contains("startup")) {
                        out.print("cover-business");
                    } else {
                        out.print("cover-tech");
                    }
                %>
            ">

                <%
                    if (code.contains("codefest")) {
                        out.print("💻");
                    } else if (code.contains("music")) {
                        out.print("🎤");
                    } else if (code.contains("cricket")) {
                        out.print("🏏");
                    } else if (code.contains("cultural")) {
                        out.print("🎉");
                    } else if (code.contains("ai-workshop")) {
                        out.print("🚀");
                    } else if (code.contains("startup")) {
                        out.print("💼");
                    } else {
                        out.print("🎓");
                    }
                %>

            </div>

            <div class="event-content">

                <span class="event-category">
                    CAMPUS EVENT
                </span>

                <h3>
                    <%= event[2] != null
                        ? event[2] : "Untitled Event" %>
                </h3>

                <p class="event-description">
                    <%= event[5] != null
                        ? event[5] : "More details will be announced soon." %>
                </p>

                <div class="event-details">

                    <span>
                        📅
                        <%= event[3] != null
                            ? event[3] : "Date to be announced" %>
                    </span>

                    <span>
                        📍
                        <%= event[4] != null
                            ? event[4] : "Venue to be announced" %>
                    </span>

                </div>

                <div class="event-footer">

                    <span class="event-status">
                        ● Campus Event
                    </span>

                    <a
                        href="${pageContext.request.contextPath}/student/event-details.jsp?event=<%= java.net.URLEncoder.encode(event[1] != null ? event[1] : "", "UTF-8") %>"
                        class="primary-button register-button"
                        style="display: inline-block; text-decoration: none;">
                        View Details
                    </a>

                </div>

            </div>

        </article>

    <% } %>

    <% if (events.isEmpty()) { %>

        <p>No events are available right now. Please check again later.</p>

    <% } %>

</div>

        </section>


        <!-- ===== MY REGISTRATIONS ===== -->

        <section class="dashboard-section" id="registrations">

            <div class="section-heading">
                <div>
                    <h2>My Registrations</h2>
                    <p>Keep track of the events you have joined.</p>
                </div>
            </div>

            <div class="registrations-panel">


<% if (myRegistrations.isEmpty()) { %>

    <p>
        You haven't registered for any events yet.
        Explore upcoming events and register to see them here.
    </p>

<% } else { %>

    <% for (String[] registration : myRegistrations) { %>

        <div class="registration-item">

            <div class="registration-info">

                <h3><%= registration[0] != null
                    ? registration[0] : "Unnamed Event" %></h3>

                <p>
                    Date:
                    <%= registration[1] != null
                        ? registration[1] : "To be announced" %>
                    &middot;
                    Venue:
                    <%= registration[2] != null
                        ? registration[2] : "To be announced" %>
                </p>

            </div>

            <span class="registration-status">
                <%= registration[3] != null
                    ? registration[3] : "Pending" %>
            </span>

        </div>

    <% } %>

<% } %>


</div>


        </section>


        <!-- ===== STUDENT PROFILE ===== -->

        <section class="dashboard-section" id="profile">

            <div class="section-heading">
                <div>
                    <h2>My Profile</h2>
                    <p>View your student account information.</p>
                </div>
            </div>

            <div class="profile-panel">

                <div class="profile-avatar">
                    👤
                </div>

                <div class="profile-info">

                    <h3><%= studentName %></h3>

                    <p>Email: <%= studentEmail %></p>

                    <p>Role: Student</p>

                    <p>Account: Active</p>

                </div>

                <div class="profile-actions">

                    <button
                        type="button"
                        class="secondary-button"
                        onclick="showDemoMessage('Edit Profile')">
                        Edit Profile
                    </button>

                    <button
                        type="button"
                        class="secondary-button"
                        onclick="showDemoMessage('Change Password')">
                        Change Password
                    </button>

                </div>

            </div>

        </section>


        <!-- ===== LOGOUT INTERFACE ===== -->

        <section class="logout-panel" id="logout">

            <div>
                <h3>Ready to leave CampusConnect?</h3>

                <p>
                    Use the logout option to return to the student login page.
                </p>
            </div>

            <a
                href="${pageContext.request.contextPath}/student/login.jsp"
                class="logout-button">
                Logout
            </a>

        </section>

    </main>


    <!-- ===== FOOTER ===== -->

    <footer class="dashboard-footer">

        <p>
            © 2026 <strong>CampusConnect</strong>.
            College Event Management System.
        </p>

        <p>Connecting students through campus experiences.</p>

    </footer>


    <!-- ===== DEMO INTERACTIONS ===== -->

    <script>
        function showDemoMessage(featureName) {
            alert(
                featureName +
                " is a frontend demo feature. " +
                "Backend functionality will be added in a later step."
            );
        }
    </script>

</body>
</html>

