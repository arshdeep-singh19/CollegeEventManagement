<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    String result = request.getParameter("result");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Event | CampusConnect</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 30px 15px;
            font-family: Arial, sans-serif;
            background: #f3f5f9;
            color: #202b3c;
        }

        .container {
            max-width: 650px;
            margin: auto;
            padding: 30px;
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 18px rgba(20, 35, 60, 0.08);
        }

        h1 { margin-top: 0; }

        label {
            display: block;
            margin: 18px 0 7px;
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd2df;
            border-radius: 7px;
            font-size: 15px;
            font-family: inherit;
        }

        textarea { min-height: 110px; resize: vertical; }

        button, .back {
            display: inline-block;
            margin-top: 22px;
            padding: 12px 18px;
            border: none;
            border-radius: 7px;
            background: #315bd6;
            color: white;
            font-size: 15px;
            text-decoration: none;
            cursor: pointer;
        }

        .back { background: #667085; margin-left: 8px; }

        .message {
            padding: 12px;
            border-radius: 7px;
            margin: 15px 0;
        }

        .success { background: #e7f8ee; color: #17663a; }
        .error { background: #fff0ef; color: #b42318; }
    </style>
</head>
<body>
    <main class="container">
        <h1>Add College Event</h1>
        <p>Enter the details of the new event.</p>

        <% if ("success".equals(result)) { %>
            <div class="message success">Event added successfully!</div>
        <% } %>

        <% if ("duplicate".equals(error)) { %>
            <div class="message error">
                This event code already exists. Please use another code.
            </div>
        <% } else if ("invalid".equals(error)) { %>
            <div class="message error">
                Please check the details and try again.
            </div>
        <% } else if ("database".equals(error)) { %>
            <div class="message error">
                The event could not be saved. Please check the database.
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin-add-event"
              method="post">

            <label for="eventCode">Event Code</label>
            <input type="text" id="eventCode" name="event_code"
                   maxlength="30" required>

            <label for="eventName">Event Name</label>
            <input type="text" id="eventName" name="event_name"
                   maxlength="150" required>

            <label for="eventDate">Event Date</label>
            <input type="date" id="eventDate" name="event_date" required>

            <label for="venue">Venue</label>
            <input type="text" id="venue" name="venue"
                   maxlength="200" required>

            <label for="description">Description</label>
            <textarea id="description" name="description"
                      maxlength="2000" required></textarea>

            <button type="submit">Save Event</button>

            <a class="back"
               href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                Back to Dashboard
            </a>
        </form>
    </main>
</body>
</html>

