<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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

    List<String[]> events = new ArrayList<>();
    String dbError = null;

    String sql = "SELECT event_id, event_code, event_name, " +
                 "event_date, venue, description " +
                 "FROM events ORDER BY event_date ASC";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql);
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
        application.log("Unable to load events from database.", e);
        dbError = "Events could not be loaded. Please try again later.";
    }
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore Events | CampusConnect</title>


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

    .navbar a:hover,
    .navbar a.active {
        color: #93c5fd;
    }

    .container {
        max-width: 1200px;
        margin: 35px auto;
        padding: 0 20px;
    }

    .hero {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
        color: white;
        padding: 40px;
        border-radius: 16px;
        margin-bottom: 30px;
    }

    .hero h1 {
        font-size: 34px;
        margin: 0 0 12px;
    }

    .hero p {
        line-height: 1.7;
        color: #dbeafe;
        max-width: 650px;
    }

    .search-area {
        display: flex;
        gap: 10px;
        max-width: 650px;
        margin-top: 25px;
    }

    .search-area input {
        flex: 1;
        min-width: 0;
        padding: 14px;
        border: none;
        border-radius: 8px;
        font-size: 15px;
    }

    .search-area button {
        padding: 14px 20px;
        background: #fbbf24;
        color: #172554;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
    }

    .section-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 20px;
    }

    .section-heading h2 {
        color: #172554;
        margin: 0;
    }

    .result-count {
        color: #64748b;
        font-size: 14px;
    }

    .categories {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 28px;
    }

    .category-btn {
        background: white;
        color: #334155;
        border: 1px solid #cbd5e1;
        padding: 10px 17px;
        border-radius: 25px;
        cursor: pointer;
        font-size: 14px;
    }

    .category-btn:hover,
    .category-btn.active {
        background: #2563eb;
        border-color: #2563eb;
        color: white;
    }

    .events-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 22px;
    }

    .event-card {
        background: white;
        border-radius: 13px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .event-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 9px 22px rgba(0, 0, 0, 0.09);
    }

    .event-banner {
        height: 145px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 55px;
    }

    .technology {
        background: #dbeafe;
    }

    .sports {
        background: #dcfce7;
    }

    .cultural {
        background: #fce7f3;
    }

    .music {
        background: #ede9fe;
    }

    .event-content {
        padding: 22px;
    }

    .event-category {
        display: inline-block;
        background: #eff6ff;
        color: #1d4ed8;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 12px;
        margin-bottom: 12px;
    }

    .event-content h3 {
        color: #172554;
        font-size: 20px;
        margin: 0 0 10px;
    }

    .event-description {
        color: #64748b;
        font-size: 14px;
        line-height: 1.6;
        min-height: 67px;
    }

    .event-meta {
        border-top: 1px solid #e5e7eb;
        padding-top: 15px;
        margin-top: 15px;
    }

    .event-meta p {
        margin: 8px 0;
        font-size: 13px;
        color: #475569;
        line-height: 1.5;
    }

    .event-actions {
        margin-top: 18px;
    }

    .btn {
        display: inline-block;
        width: 100%;
        text-align: center;
        padding: 12px;
        border-radius: 7px;
        text-decoration: none;
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

    .no-results {
        display: none;
        background: white;
        text-align: center;
        padding: 45px 20px;
        border-radius: 12px;
        color: #64748b;
        line-height: 1.7;
    }

    .no-results h3 {
        color: #172554;
    }

    .notice {
        margin-top: 30px;
        padding: 15px;
        border-radius: 8px;
        background: #eff6ff;
        border: 1px solid #bfdbfe;
        color: #1e40af;
        font-size: 14px;
        line-height: 1.6;
    }

    footer {
        text-align: center;
        padding: 25px;
        color: #64748b;
        font-size: 13px;
    }

    @media (max-width: 950px) {
        .events-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }

    @media (max-width: 600px) {
        .events-grid {
            grid-template-columns: 1fr;
        }

        .hero {
            padding: 25px;
        }

        .hero h1 {
            font-size: 27px;
        }

        .search-area {
            flex-direction: column;
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
    <a href="${pageContext.request.contextPath}/student/events.jsp" class="active">Events</a>
    <a href="${pageContext.request.contextPath}/student/my-registrations.jsp">My Registrations</a>
    <a href="${pageContext.request.contextPath}/student/profile.jsp">My Profile</a>
    <a href="${pageContext.request.contextPath}/student/login.jsp">Logout</a>
</nav>


</header>

<main class="container">


<!-- Hero and Search -->
<section class="hero">
    <h1>Discover Campus Events</h1>

    <p>
        Explore college activities, discover new interests, develop your skills,
        and participate in exciting campus experiences.
    </p>

    <form class="search-area" id="searchForm">
        <input
            type="search"
            id="searchInput"
            placeholder="Search events by name, venue, or keyword..."
            aria-label="Search events">

        <button type="submit">Search</button>
    </form>
</section>

<!-- Category filters -->
<section>
    <div class="section-heading">
        <h2>Explore All Events</h2>
        <span class="result-count" id="resultCount">6 events found</span>
    </div>

    <div class="categories" aria-label="Filter events by category">
        <button type="button" class="category-btn active" data-category="all">
            All Events
        </button>

        <button type="button" class="category-btn" data-category="technology">
            Technology
        </button>

        <button type="button" class="category-btn" data-category="sports">
            Sports
        </button>

        <button type="button" class="category-btn" data-category="cultural">
            Cultural
        </button>

        <button type="button" class="category-btn" data-category="music">
            Music &amp; Arts
        </button>
    </div>
</section>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!-- Event cards -->
<section class="events-grid" id="eventsGrid">

    <% if (dbError != null) { %>
        <p class="notice"><%= escapeHtml(dbError) %></p>

    <% } else if (events.isEmpty()) { %>
        <p class="notice">No events are available right now. Please check again later.</p>

    <% } else { %>

        <% for (String[] event : events) {
            String eventId = event[0];
            String eventCode = event[1];
            String eventName = event[2];
            String eventDate = event[3];
            String venue = event[4];
            String description = event[5];

            String searchable = (
                (eventName == null ? "" : eventName) + " " +
                (eventCode == null ? "" : eventCode) + " " +
                (description == null ? "" : description)
            ).toLowerCase();

            String category;
            String categoryLabel;
            String bannerClass;
            String icon;

            if (searchable.contains("cricket")
                    || searchable.contains("football")
                    || searchable.contains("sports")
                    || searchable.contains("tournament")) {
                category = "sports";
                categoryLabel = "Sports";
                bannerClass = "sports";
                icon = "🏏";
            } else if (searchable.contains("music")
                    || searchable.contains("dance")
                    || searchable.contains("art")) {
                category = "music";
                categoryLabel = "Music & Arts";
                bannerClass = "music";
                icon = "🎵";
            } else if (searchable.contains("cultural")
                    || searchable.contains("culture")
                    || searchable.contains("fest")) {
                category = "cultural";
                categoryLabel = "Cultural";
                bannerClass = "cultural";
                icon = "🎭";
            } else if (searchable.contains("technology")
                    || searchable.contains("tech")
                    || searchable.contains("code")
                    || searchable.contains("programming")
                    || searchable.contains("software")
                    || searchable.contains("ai ")
                    || searchable.contains("machine learning")
                    || searchable.contains("startup")
                    || searchable.contains("computer")) {
                category = "technology";
                categoryLabel = "Technology";
                bannerClass = "technology";
                icon = "💻";
            } else {
                category = "other";
                categoryLabel = "Campus Event";
                bannerClass = "cultural";
                icon = "🎓";
            }

            String displayDate = eventDate;
            try {
                if (eventDate != null && !eventDate.isEmpty()) {
                    java.text.SimpleDateFormat inputFormat =
                        new java.text.SimpleDateFormat("yyyy-MM-dd");
                    java.text.SimpleDateFormat outputFormat =
                        new java.text.SimpleDateFormat("dd MMMM yyyy");

                    displayDate = outputFormat.format(inputFormat.parse(eventDate));
                }
            } catch (java.text.ParseException ignored) {
                // Display the original date if formatting fails.
            }
        %>

        <article class="event-card" data-category="<%= category %>">
            <div class="event-banner <%= bannerClass %>" aria-hidden="true">
                <%= icon %>
            </div>

            <div class="event-content">
                <span class="event-category">
                    <%= categoryLabel %>
                </span>

                <h3><%= escapeHtml(eventName) %></h3>

                <p class="event-description">
                    <%= escapeHtml(description) %>
                </p>

                <div class="event-meta">
                    <p>
                        📅 <strong><%= escapeHtml(displayDate) %></strong>
                    </p>

                    <p>
                        📍 <%= escapeHtml(venue) %>
                    </p>
                </div>

                <div class="event-actions">
                    <a class="btn btn-primary"
                       href="${pageContext.request.contextPath}/student/event-details.jsp?id=<%= java.net.URLEncoder.encode(eventId, "UTF-8") %>">
                        View Details
                    </a>
                </div>
            </div>
        </article>

        <% } %>

    <% } %>

</section>

<!-- No matching events -->
<section class="no-results" id="noResults">
    <h3>No events found</h3>
    <p>Try another search term or select a different category.</p>

    <button type="button" class="btn btn-primary" id="resetFilters">
        Show All Events
    </button>
</section>

<div class="notice">
    <strong>Live event data:</strong>
    Events are loaded from the CampusConnect database.
    Event times are not displayed because the current events table
    does not contain an event-time column.
</div>


</main>

<footer>
    &copy; 2026 CampusConnect | College Event Management System
</footer>

<script>
    const searchInput = document.getElementById("searchInput");
    const searchForm = document.getElementById("searchForm");
    const eventCards = Array.from(document.querySelectorAll(".event-card"));
    const categoryButtons = document.querySelectorAll(".category-btn");
    const resultCount = document.getElementById("resultCount");
    const noResults = document.getElementById("noResults");
    const eventsGrid = document.getElementById("eventsGrid");

    let selectedCategory = "all";

    function filterEvents() {
        const searchTerm = searchInput.value.trim().toLowerCase();
        let visibleCount = 0;

        eventCards.forEach(function(card) {
            const category = card.dataset.category;
            const searchableText = card.textContent.toLowerCase();

            const matchesCategory =
                selectedCategory === "all" || category === selectedCategory;

            const matchesSearch = searchableText.includes(searchTerm);

            const shouldShow = matchesCategory && matchesSearch;

            card.style.display = shouldShow ? "" : "none";

            if (shouldShow) {
                visibleCount++;
            }
        });

        resultCount.textContent =
            visibleCount + (visibleCount === 1 ? " event found" : " events found");

        eventsGrid.style.display = visibleCount > 0 ? "grid" : "none";
        noResults.style.display = visibleCount === 0 ? "block" : "none";
    }

    searchForm.addEventListener("submit", function(event) {
        event.preventDefault();
        filterEvents();
    });

    searchInput.addEventListener("input", filterEvents);

    categoryButtons.forEach(function(button) {
        button.addEventListener("click", function() {
            selectedCategory = button.dataset.category;

            categoryButtons.forEach(function(item) {
                item.classList.remove("active");
            });

            button.classList.add("active");
            filterEvents();
        });
    });

    document.getElementById("resetFilters").addEventListener("click", function() {
        searchInput.value = "";
        selectedCategory = "all";

        categoryButtons.forEach(function(button) {
            button.classList.toggle("active", button.dataset.category === "all");
        });

        filterEvents();
    });

    filterEvents();
</script>

</body>
</html>
