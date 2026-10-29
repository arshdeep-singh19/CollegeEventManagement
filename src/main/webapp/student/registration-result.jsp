
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String status = request.getParameter("status");
    String event = request.getParameter("event");

    boolean success = "success".equals(status);
    boolean duplicate = "duplicate".equals(status);

    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Result | CampusConnect</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 24px;
            font-family: Arial, sans-serif;
            background: #f3f6fc;
            color: #1f2937;
        }

        .result-card {
            width: 100%;
            max-width: 480px;
            padding: 38px 28px;
            text-align: center;
            background: white;
            border-radius: 20px;
            box-shadow: 0 12px 40px rgba(31, 41, 55, 0.10);
        }

        .result-icon {
            width: 76px;
            height: 76px;
            display: grid;
            place-items: center;
            margin: 0 auto 22px;
            border-radius: 50%;
            font-size: 38px;
            background: #dcfce7;
            color: #15803d;
        }

        .warning .result-icon {
            background: #fef3c7;
            color: #92400e;
        }

        h1 {
            margin: 0 0 12px;
            font-size: 27px;
        }

        p {
            margin: 0 0 26px;
            line-height: 1.7;
            color: #64748b;
        }

        .action {
            display: inline-block;
            margin: 5px;
            padding: 13px 20px;
            border-radius: 9px;
            text-decoration: none;
            font-weight: 600;
        }

        .primary {
            color: white;
            background: #2563eb;
        }

        .secondary {
            color: #334155;
            background: #eaf0f8;
        }

        .action:hover {
            filter: brightness(0.95);
        }
    </style>
</head>
<body>

<main class="result-card <%= duplicate ? "warning" : "" %>">

    <% if (success) { %>

        <div class="result-icon" aria-hidden="true">&#10003;</div>
        <h1>Registration Successful!</h1>
        <p>
            You're registered for the event.
            Your CampusConnect registration has been saved successfully.
        </p>

        <a class="action primary"
           href="<%= context %>/student/dashboard.jsp">
            Go to Dashboard
        </a>

        <a class="action secondary"
           href="<%= context %>/index.jsp">
            Back to Home
        </a>

    <% } else if (duplicate) { %>

        <div class="result-icon" aria-hidden="true">&#9888;</div>
        <h1>Already Registered</h1>
        <p>
            It looks like you have already registered for this event.
            You don't need to submit the same registration again.
        </p>

        <a class="action primary"
           href="<%= context %>/index.jsp">
            Back to Home
        </a>

    <% } else { %>

        <div class="result-icon" aria-hidden="true">!</div>
        <h1>Unable to Confirm Registration</h1>
        <p>
            We couldn't confirm the result. Please return to the event
            page and check your registration status.
        </p>

        <a class="action primary"
           href="<%= context %>/index.jsp">
            Back to Home
        </a>

    <% } %>

</main>

</body>
</html>