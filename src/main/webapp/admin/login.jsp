<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") != null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }

    String error = request.getParameter("error");
    String message = "";

    if ("empty".equals(error)) {
        message = "Please enter both username and password.";
    } else if ("invalid".equals(error)) {
        message = "Invalid admin username or password.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | CampusConnect</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #101827, #263b65);
            color: #172033;
            padding: 20px;
        }

        .login-card {
            width: 100%;
            max-width: 410px;
            padding: 35px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 15px 45px rgba(0, 0, 0, 0.25);
        }

        h1 { margin: 0 0 8px; font-size: 27px; }
        .subtitle { color: #687386; margin-bottom: 28px; }

        label {
            display: block;
            margin: 17px 0 8px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd2df;
            border-radius: 8px;
            font-size: 15px;
        }

        input:focus {
            outline: 2px solid #7799ed;
            border-color: #4269d4;
        }

        button {
            width: 100%;
            margin-top: 24px;
            padding: 13px;
            background: #315bd6;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover { background: #2448b5; }

        .error {
            color: #b42318;
            background: #fff0ef;
            padding: 10px;
            border-radius: 7px;
            font-size: 14px;
        }

        .back {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #315bd6;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <main class="login-card">
        <h1>Admin Login</h1>
        <p class="subtitle">CampusConnect Administration</p>

        <% if (!message.isEmpty()) { %>
            <p class="error"><%= message %></p>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin-login"
              method="post">
            <label for="username">Username</label>
            <input type="text" id="username" name="username"
                   autocomplete="username" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   autocomplete="current-password" required>

            <button type="submit">Sign In</button>
        </form>

        <a class="back" href="<%= request.getContextPath() %>/">
            Back to Home
        </a>
    </main>
</body>
</html>
