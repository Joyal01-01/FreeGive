package com.freegive.controller;

import com.freegive.dao.UserDAO;
import com.freegive.model.User;
import com.freegive.util.PasswordUtil;
import com.freegive.util.Validator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Handles user registration.
 * GET: displays registration form.
 * POST: creates new user with 'pending' status.
 */
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String zipcode = request.getParameter("zipcode");
        String role = request.getParameter("role"); // donor or receiver

        // Build user object
        User user = new User();
        user.setUsername(username != null ? username.trim() : "");
        user.setEmail(email != null ? email.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");
        user.setZipcode(zipcode != null ? zipcode.trim() : "");
        user.setPlainPassword(password);

        // Validate role selection
        if (!"donor".equals(role) && !"receiver".equals(role)) {
            role = "pending";
        }
        user.setRole(role);
        user.setApproved(false);

        // Validate model
        List<String> errors = user.validate();

        // Check password confirmation
        if (password == null || !password.equals(confirmPassword)) {
            errors.add("Passwords do not match.");
        }

        try {
            // Check uniqueness
            if (!Validator.isEmpty(username) && !userDAO.isUsernameUnique(username.trim())) {
                errors.add("Username is already taken.");
            }
            if (!Validator.isEmpty(email) && !userDAO.isEmailUnique(email.trim())) {
                errors.add("Email is already registered.");
            }
            if (!Validator.isEmpty(phone) && !userDAO.isPhoneUnique(phone.trim())) {
                errors.add("Phone number is already registered.");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Hash password and save
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            boolean created = userDAO.create(user);

            if (created) {
                request.getSession().setAttribute("successMessage",
                    "Registration successful! Your account is pending admin approval. Please check back soon.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                errors.add("Registration failed. Please try again.");
                request.setAttribute("errors", errors);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            errors.add("An error occurred during registration. Please try again.");
            request.setAttribute("errors", errors);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
