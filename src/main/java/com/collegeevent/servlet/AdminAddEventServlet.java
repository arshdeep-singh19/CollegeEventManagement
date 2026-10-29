package com.collegeevent.servlet;

import com.collegeevent.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/admin-add-event")
public class AdminAddEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Require an authenticated admin
        if (request.getSession(false) == null
                || request.getSession(false).getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String eventCode = request.getParameter("event_code");
        String eventName = request.getParameter("event_name");
        String eventDate = request.getParameter("event_date");
        String venue = request.getParameter("venue");
        String description = request.getParameter("description");

        String page = request.getContextPath() + "/admin/add-event.jsp";

        if (isBlank(eventCode) || isBlank(eventName)
                || isBlank(eventDate) || isBlank(venue)
                || isBlank(description)) {
            response.sendRedirect(page + "?error=invalid");
            return;
        }

        LocalDate parsedDate;

        try {
            parsedDate = LocalDate.parse(eventDate);
        } catch (Exception e) {
            response.sendRedirect(page + "?error=invalid");
            return;
        }

        String sql = "INSERT INTO events "
                   + "(event_code, event_name, event_date, venue, description) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, eventCode.trim());
            ps.setString(2, eventName.trim());
            ps.setDate(3, java.sql.Date.valueOf(parsedDate));
            ps.setString(4, venue.trim());
            ps.setString(5, description.trim());

            ps.executeUpdate();

            response.sendRedirect(page + "?result=success");

        } catch (SQLException e) {
            // MySQL duplicate key error
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect(page + "?error=duplicate");
            } else {
                throw new ServletException("Unable to save event.", e);
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

