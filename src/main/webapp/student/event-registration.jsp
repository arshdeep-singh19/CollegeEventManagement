<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<%!
// Escape values before displaying them in HTML.
private String escapeHtml(String value) {
if (value == null) {
return "";
}


    return value
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}


%>

<%
// Require login before accessing event registration.
if (session.getAttribute("studentId") == null) {
response.sendRedirect(
request.getContextPath() + "/student/login.jsp"
);
return;
}


String loggedInStudentName =
    (String) session.getAttribute("studentName");

String loggedInStudentEmail =
    (String) session.getAttribute("studentEmail");

String eventCode = request.getParameter("event");

if (eventCode == null || eventCode.isBlank()) {
    eventCode = request.getParameter("id");
}

if (eventCode == null) {
    eventCode = "";
}

String safeStudentName = escapeHtml(loggedInStudentName);
String safeStudentEmail = escapeHtml(loggedInStudentEmail);
String safeEventCode = escapeHtml(eventCode);

String status = request.getParameter("status");


%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


<title>Event Registration | CampusConnect</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/style.css">

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: Arial, Helvetica, sans-serif;
        background: #f4f7fb;
        color: #1e293b;
        line-height: 1.6;
    }

    a {
        text-decoration: none;
    }

    button, input, select, textarea {
        font: inherit;
    }

    .registration-navbar {
        background: #fff;
        padding: 17px 7%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 15px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, .06);
    }

    .registration-logo {
        font-size: 25px;
        font-weight: 800;
        color: #2563eb;
    }

    .registration-logo span {
        color: #0f172a;
    }

    .back-dashboard {
        color: #2563eb;
        font-size: 14px;
        font-weight: bold;
    }

    .registration-container {
        max-width: 850px;
        margin: 35px auto;
        padding: 0 22px;
    }

    .registration-heading {
        text-align: center;
        margin-bottom: 25px;
    }

    .registration-heading h1 {
        font-size: 32px;
        margin-bottom: 8px;
        color: #0f172a;
    }

    .registration-heading p {
        font-size: 14px;
        color: #64748b;
    }

    .event-summary {
        padding: 22px;
        background: linear-gradient(120deg, #1d4ed8, #6366f1);
        color: #fff;
        border-radius: 14px;
        display: flex;
        align-items: center;
        gap: 18px;
        margin-bottom: 25px;
    }

    .event-summary-icon {
        width: 65px;
        height: 65px;
        background: rgba(255, 255, 255, .18);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 35px;
        flex-shrink: 0;
    }

    .event-summary h2 {
        font-size: 21px;
        margin-bottom: 5px;
    }

    .event-summary p {
        color: #e0e7ff;
        font-size: 13px;
    }

    .registration-card {
        background: #fff;
        border: 1px solid #e5eaf2;
        border-radius: 14px;
        padding: 30px;
    }

    .form-section-title {
        font-size: 19px;
        margin-bottom: 18px;
        color: #0f172a;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 20px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    .form-group.full-width {
        grid-column: 1 / -1;
    }

    .form-group label {
        font-size: 13px;
        font-weight: bold;
        margin-bottom: 7px;
        color: #334155;
    }

    .required {
        color: #dc2626;
    }

    .form-group input,
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 12px 13px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        outline: none;
        background: #fff;
        color: #1e293b;
    }

    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, .1);
    }

    .form-group input[readonly] {
        background: #f8fafc;
        color: #475569;
    }

    .form-group textarea {
        resize: vertical;
        min-height: 100px;
    }

    .form-group small {
        font-size: 11px;
        color: #64748b;
        margin-top: 5px;
    }

    .terms-group {
        display: flex;
        align-items: flex-start;
        gap: 10px;
        margin-top: 23px;
        font-size: 13px;
        color: #475569;
    }

    .terms-group input {
        margin-top: 5px;
        accent-color: #2563eb;
    }

    .form-buttons {
        display: flex;
        gap: 12px;
        margin-top: 27px;
    }

    .submit-button, .cancel-button {
        display: inline-block;
        text-align: center;
        padding: 13px 20px;
        border-radius: 8px;
        font-weight: bold;
        font-size: 14px;
        cursor: pointer;
    }

    .submit-button {
        flex: 1;
        border: none;
        color: #fff;
        background: #2563eb;
    }

    .submit-button:hover {
        background: #1d4ed8;
    }

    .cancel-button {
        border: 1px solid #cbd5e1;
        background: #fff;
        color: #334155;
    }

    .cancel-button:hover {
        background: #f8fafc;
    }

    .registration-alert {
        padding: 13px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
    }

    .registration-alert.success {
        background: #f0fdf4;
        border: 1px solid #bbf7d0;
        color: #166534;
    }

    .registration-alert.error {
        background: #fef2f2;
        border: 1px solid #fecaca;
        color: #991b1b;
    }

    .registration-footer {
        margin-top: 40px;
        background: #fff;
        border-top: 1px solid #e5eaf2;
        padding: 25px;
        text-align: center;
        color: #64748b;
        font-size: 13px;
    }

    .registration-footer strong {
        color: #2563eb;
    }

    @media (max-width: 600px) {
        .registration-navbar {
            padding: 15px 5%;
        }

        .registration-logo {
            font-size: 21px;
        }

        .back-dashboard {
            font-size: 12px;
        }

        .registration-container {
            margin-top: 25px;
            padding: 0 14px;
        }

        .registration-heading h1 {
            font-size: 26px;
        }

        .registration-card {
            padding: 20px;
        }

        .form-grid {
            grid-template-columns: 1fr;
            gap: 16px;
        }

        .form-group.full-width {
            grid-column: auto;
        }

        .event-summary {
            padding: 17px;
        }

        .event-summary-icon {
            width: 50px;
            height: 50px;
            font-size: 27px;
        }

        .event-summary h2 {
            font-size: 18px;
        }

        .form-buttons {
            flex-direction: column;
        }
    }
</style>


</head>

<body>

<header class="registration-navbar">
    <a class="registration-logo"
       href="${pageContext.request.contextPath}/index.jsp">
        Campus<span>Connect</span>
    </a>


<a class="back-dashboard"
   href="${pageContext.request.contextPath}/student/dashboard.jsp">
    &larr; Back to Dashboard
</a>


</header>

<main class="registration-container">


<div class="registration-heading">
    <h1>Event Registration</h1>
    <p>Complete the form below to register for your campus event.</p>
</div>

<section class="event-summary">
    <div class="event-summary-icon">&#127881;</div>

    <div>
        <h2>Campus Event Registration</h2>
        <p>Event dates and venue will be announced by the organizers.</p>
        <p>Your registration will be linked to your logged-in account.</p>
    </div>
</section>

<section class="registration-card">

    <% if ("success".equals(status)) { %>
        <div class="registration-alert success" role="status">
            Registration successful! You are registered for this event.
        </div>
    <% } else if ("duplicate".equals(status)) { %>
        <div class="registration-alert error" role="alert">
            You are already registered for this event.
        </div>
    <% } %>

    <form id="registrationForm"
          action="${pageContext.request.contextPath}/register-event"
          method="post">

        <input type="hidden"
               id="eventId"
               name="eventId"
               value="<%= safeEventCode %>">

        <h2 class="form-section-title">Student Information</h2>

        <div class="form-grid">

            <div class="form-group">
                <label for="studentName">
                    Full Name <span class="required">*</span>
                </label>

                <input
                    type="text"
                    id="studentName"
                    name="studentName"
                    value="<%= safeStudentName %>"
                    placeholder="Enter your full name"
                    maxlength="80"
                    autocomplete="name"
                    readonly
                    required>
            </div>

            <div class="form-group">
                <label for="studentEmail">
                    College Email <span class="required">*</span>
                </label>

                <input
                    type="email"
                    id="studentEmail"
                    name="studentEmail"
                    value="<%= safeStudentEmail %>"
                    placeholder="student@example.com"
                    maxlength="120"
                    autocomplete="email"
                    readonly
                    required>
            </div>

            <div class="form-group">
                <label for="department">
                    Department <span class="required">*</span>
                </label>

                <select id="department" name="department" required>
                    <option value="">Select Department</option>
                    <option value="MCA">MCA</option>
                    <option value="BCA">BCA</option>
                    <option value="BTech">B.Tech</option>
                    <option value="MBA">MBA</option>
                    <option value="BBA">BBA</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="studyYear">
                    Current Study Year <span class="required">*</span>
                </label>

                <select id="studyYear" name="studyYear" required>
                    <option value="">Select Year</option>
                    <option value="First Year">First Year</option>
                    <option value="Second Year">Second Year</option>
                    <option value="Third Year">Third Year</option>
                    <option value="Fourth Year">Fourth Year</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="participationType">
                    Participation Type <span class="required">*</span>
                </label>

                <select id="participationType"
                        name="participationType"
                        required>
                    <option value="">Select Participation</option>
                    <option value="Individual">Individual</option>
                    <option value="Team">Team</option>
                </select>
            </div>

            <div class="form-group full-width"
                 id="teamNameGroup"
                 hidden>

                <label for="teamName">Team Name</label>

                <input
                    type="text"
                    id="teamName"
                    name="teamName"
                    placeholder="Enter your team name"
                    maxlength="80">

                <small>Required only for team participation.</small>
            </div>

            <div class="form-group full-width">
                <label for="additionalInfo">
                    Additional Information (Optional)
                </label>

                <textarea
                    id="additionalInfo"
                    name="additionalInfo"
                    maxlength="500"
                    placeholder="Tell us about your interests or participation requirements."></textarea>
            </div>

        </div>

        <label class="terms-group">
            <input
                type="checkbox"
                id="agreeTerms"
                name="agreeTerms"
                required>

            <span>
                I confirm that the information provided is accurate
                and agree to follow the event participation guidelines.
                <span class="required">*</span>
            </span>
        </label>

        <div class="form-buttons">
            <button type="submit" class="submit-button">
                Submit Registration
            </button>

            <a href="${pageContext.request.contextPath}/student/dashboard.jsp"
               class="cancel-button">
                Cancel
            </a>
        </div>

    </form>
</section>


</main>

<footer class="registration-footer">
    <p>
        &copy; 2026 <strong>CampusConnect</strong>.
        College Event Management System.
    </p>
    <p>Connecting students through campus experiences.</p>
</footer>

<script>
    const registrationForm =
        document.getElementById("registrationForm");

    const eventId =
        document.getElementById("eventId");

    const participationType =
        document.getElementById("participationType");

    const teamNameGroup =
        document.getElementById("teamNameGroup");

    const teamName =
        document.getElementById("teamName");

    // Show the team-name field only for team participation.
    participationType.addEventListener("change", function () {
        const isTeam = participationType.value === "Team";

        teamNameGroup.hidden = !isTeam;
        teamName.required = isTeam;

        if (!isTeam) {
            teamName.value = "";
        }
    });

    // Validate the form before submitting it to RegistrationServlet.
    registrationForm.addEventListener("submit", function (event) {
        if (!eventId.value.trim()) {
            event.preventDefault();
            alert("The event could not be identified. Return to the dashboard and select an event again.");
            return;
        }

        if (!registrationForm.reportValidity()) {
            event.preventDefault();
            return;
        }

        if (participationType.value === "Team" &&
            !teamName.value.trim()) {
            event.preventDefault();
            alert("Please enter your team name.");
            teamName.focus();
        }
    });
</script>

</body>
</html>
