<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.collegeevent.util.DBConnection" %>

<%
    // Ensure the student is logged in.
    Object loggedInStudentId = session.getAttribute("studentId");

    if (loggedInStudentId == null) {
        response.sendRedirect(
            request.getContextPath() + "/student/login.jsp"
        );
        return;
    }

    String fullName = "";
    String email = "";
    String collegeStudentId = "";
    String course = "";
    String semester = "";
    String accountCreated = "";

    boolean studentFound = false;
    String profileError = null;

    String sql = "SELECT full_name, email, college_student_id, " +
                 "course, semester, created_at " +
                 "FROM students WHERE student_id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql)) {

        statement.setInt(
            1,
            Integer.parseInt(loggedInStudentId.toString())
        );

        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                fullName = rs.getString("full_name");
                email = rs.getString("email");
                collegeStudentId = rs.getString("college_student_id");
                course = rs.getString("course");
                semester = rs.getString("semester");

                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");

                if (createdAt != null) {
                    accountCreated = createdAt.toLocalDateTime()
                                              .toLocalDate()
                                              .toString();
                }

                studentFound = true;
            }
        }

    } catch (SQLException | NumberFormatException e) {
        application.log("Unable to load student profile.", e);
        profileError = "Unable to load your profile right now.";
    }
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CampusConnect</title>


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

    .profile-header {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
        color: white;
        border-radius: 14px;
        padding: 30px;
        display: flex;
        align-items: center;
        gap: 22px;
        margin-bottom: 25px;
    }

    .avatar {
        width: 90px;
        height: 90px;
        border-radius: 50%;
        background: white;
        color: #1d4ed8;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 34px;
        font-weight: bold;
        flex-shrink: 0;
    }

    .profile-header h2 {
        margin: 0 0 8px;
    }

    .profile-header p {
        margin: 6px 0;
        color: #dbeafe;
    }

    .profile-layout {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 22px;
    }

    .profile-card {
        background: white;
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    }

    .profile-card h3 {
        margin-top: 0;
        margin-bottom: 22px;
        color: #172554;
        border-bottom: 1px solid #e5e7eb;
        padding-bottom: 14px;
    }

    .info-item {
        margin-bottom: 20px;
    }

    .info-item label {
        display: block;
        font-size: 13px;
        color: #64748b;
        margin-bottom: 7px;
    }

    .info-item p {
        margin: 0;
        font-size: 15px;
        font-weight: 600;
        overflow-wrap: anywhere;
    }

    .form-group {
        margin-bottom: 17px;
    }

    .form-group label {
        display: block;
        margin-bottom: 7px;
        font-size: 14px;
        font-weight: bold;
        color: #374151;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 11px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 7px;
        font-size: 14px;
        background: white;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: 2px solid #93c5fd;
        border-color: #2563eb;
    }

    .btn {
        display: inline-block;
        padding: 11px 17px;
        border: none;
        border-radius: 7px;
        font-size: 14px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        text-align: center;
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

    .btn-secondary:hover {
        background: #d1d5db;
    }

    .button-group {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 22px;
    }

    .edit-form {
        display: none;
    }

    .message {
        display: none;
        margin-top: 18px;
        padding: 12px;
        background: #dcfce7;
        color: #166534;
        border-radius: 7px;
        font-size: 14px;
        line-height: 1.5;
    }

    .notice {
        background: #eff6ff;
        border: 1px solid #bfdbfe;
        color: #1e40af;
        padding: 15px;
        border-radius: 8px;
        margin-top: 22px;
        font-size: 14px;
        line-height: 1.6;
    }

    footer {
        text-align: center;
        padding: 25px;
        color: #64748b;
        font-size: 13px;
    }

    @media (max-width: 700px) {
        .profile-layout {
            grid-template-columns: 1fr;
        }

        .profile-header {
            padding: 22px;
            align-items: flex-start;
        }

        .avatar {
            width: 70px;
            height: 70px;
            font-size: 27px;
        }

        .container {
            margin-top: 25px;
        }
    }

    @media (max-width: 420px) {
        .profile-header {
            flex-direction: column;
        }

        .navbar {
            padding: 18px 5%;
        }
    }
</style>


</head>

<body>

<header class="navbar">
    <div class="brand">CampusConnect</div>


<nav>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp">Dashboard</a>
    <a href="${pageContext.request.contextPath}/student/my-registrations.jsp">My Registrations</a>
    <a href="${pageContext.request.contextPath}/student/profile.jsp">My Profile</a>
    <a href="${pageContext.request.contextPath}/student/login.jsp">Logout</a>
</nav>


</header>

<main class="container">


<section class="page-heading">
    <h1>My Profile</h1>
    <p>View your personal information and academic details.</p>
</section>

<!-- Profile header -->
<% if (profileError != null) { %>

    <div class="notice">
        <%= profileError %>
    </div>

<% } else if (!studentFound) { %>

    <div class="notice">
        Student profile not found. Please log in again.
    </div>

<% } else { %>

<section class="profile-header">
    <div class="avatar">
        <%= fullName != null && !fullName.trim().isEmpty()
                ? fullName.trim().substring(0, 1).toUpperCase()
                : "S" %>
    </div>

    <div>
        <h2><%= fullName %></h2>
        <p>Student ID: <%= collegeStudentId != null
                && !collegeStudentId.trim().isEmpty()
                ? collegeStudentId : "Not provided" %></p>
        <p>Course: <%= course != null && !course.trim().isEmpty()
                ? course : "Not provided" %></p>
    </div>
</section>

<% } %>
<div class="profile-layout">

    <!-- Personal information -->
<section class="profile-card">
    <h3>Personal Information</h3>

    <div class="info-item">
        <label>Full Name</label>
        <p><%= fullName %></p>
    </div>

    <div class="info-item">
        <label>Email Address</label>
        <p><%= email %></p>
    </div>

    <div class="info-item">
        <label>Account Created</label>
        <p><%= accountCreated.isEmpty()
                ? "Not available" : accountCreated %></p>
    </div>
</section>

    <!-- Academic information -->
<section class="profile-card">
    <h3>Academic Information</h3>

    <div class="info-item">
        <label>College Student ID</label>
        <p><%= collegeStudentId != null
                && !collegeStudentId.trim().isEmpty()
                ? collegeStudentId : "Not provided" %></p>
    </div>

    <div class="info-item">
        <label>Course</label>
        <p><%= course != null && !course.trim().isEmpty()
                ? course : "Not provided" %></p>
    </div>

    <div class="info-item">
        <label>Semester</label>
        <p><%= semester != null && !semester.trim().isEmpty()
                ? semester : "Not provided" %></p>
    </div>
</section>

</div>

</main>

<footer>
    &copy; 2026 CampusConnect | College Event Management System
</footer>

</body>
</html>
