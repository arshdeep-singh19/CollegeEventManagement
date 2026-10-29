
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
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/register-event")
public class RegistrationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
            System.out.println("RegistrationServlet: POST request received.");
        request.setCharacterEncoding("UTF-8");

        // Require the student to be logged in before registering.
jakarta.servlet.http.HttpSession session = request.getSession(false);

if (session == null || session.getAttribute("studentId") == null) {
response.sendRedirect(
request.getContextPath() + "/student/login.jsp"
);
return;
}

int loggedInStudentId = (Integer) session.getAttribute("studentId");


        String studentName = request.getParameter("studentName");
        String email = request.getParameter("studentEmail");
        String department = request.getParameter("department");
        String studyYear = request.getParameter("studyYear");
        String eventCode = request.getParameter("eventId");
        String participation = request.getParameter("participationType");
        String teamName = request.getParameter("teamName");
        String additionalInfo = request.getParameter("additionalInfo");

        
    if (department == null || studyYear == null
            || eventCode == null || participation == null
            || department.isBlank()
            || studyYear.isBlank()
            || eventCode.isBlank()
            || participation.isBlank()) {

        response.sendError(
            HttpServletResponse.SC_BAD_REQUEST,
            "Required registration fields are missing or blank."
        );
        return;
    }


        studentName = studentName.trim();
        email = email.trim();
        eventCode = eventCode.trim();

        
    if ((!participation.equals("Individual")
            && !participation.equals("Team"))
            || (participation.equals("Team")
            && (teamName == null || teamName.trim().isEmpty()))) {

        response.sendError(
            HttpServletResponse.SC_BAD_REQUEST,
            "Please check the participation type and team name."
        );
        return;
    }


        if (teamName != null && teamName.length() > 80
                || additionalInfo != null && additionalInfo.length() > 500) {
            response.sendError(400, "One or more fields are too long.");
            return;
        }

        try (Connection connection = DBConnection.getConnection()) {
            System.out.println("Database connection successful.");

            connection.setAutoCommit(false);

            try {
                int eventId;

                // Find the selected event using its URL event code.
                String eventSql =
                    "SELECT event_id FROM events WHERE event_code = ?";

                try (PreparedStatement ps =
                         connection.prepareStatement(eventSql)) {

                    ps.setString(1, eventCode);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            connection.rollback();
                            response.sendError(404, "Event not found.");
                            return;
                        }
                        eventId = rs.getInt("event_id");
                    }
                }

                
            // Use the authenticated student's database ID from the session.
            int studentId = loggedInStudentId;

            // Verify that the student exists and retrieve their current details.
            String verifyStudent =
                "SELECT student_id FROM students WHERE student_id = ?";

            try (PreparedStatement ps =
                    connection.prepareStatement(verifyStudent)) {

                ps.setInt(1, studentId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        connection.rollback();
                        response.sendRedirect(
                            request.getContextPath()
                            + "/student/login.jsp?status=invalid"
                        );
                        return;
                    }
                }
            }


                // Save the registration.
                String insertRegistration =
                    "INSERT INTO registrations "
                    + "(student_id, event_id, participation_type, "
                    + "team_name, department, study_year, additional_info) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement ps =
                         connection.prepareStatement(insertRegistration)) {

                    ps.setInt(1, studentId);
                    ps.setInt(2, eventId);
                    ps.setString(3, participation);
                    ps.setString(4,
                        participation.equals("Team") ? teamName.trim() : null);
                    ps.setString(5, department);
                    ps.setString(6, studyYear);
                    ps.setString(7, additionalInfo);
                    ps.executeUpdate();
                }

                connection.commit();

            response.sendRedirect(
                request.getContextPath()
                + "/student/registration-result.jsp?status=success&event="
                + java.net.URLEncoder.encode(
                eventCode, java.nio.charset.StandardCharsets.UTF_8));
                return;

            } catch (SQLException e) {
                connection.rollback();

                // MySQL duplicate-key error, such as an existing registration.
                if (e.getErrorCode() == 1062) {
                    response.sendRedirect(
                    request.getContextPath()
                    + "/student/registration-result.jsp?status=duplicate&event="
                    + java.net.URLEncoder.encode(
                eventCode, java.nio.charset.StandardCharsets.UTF_8));
                return;
                } else {
                    throw e;
                }
            } finally {
                connection.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to save the event registration.", e);
        }
    }
}