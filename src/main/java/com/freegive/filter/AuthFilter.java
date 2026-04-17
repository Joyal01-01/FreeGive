package com.freegive.filter;

import com.freegive.model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Authentication and authorization filter.
 * Checks if user is logged in and has the correct role for the requested resource.
 */
public class AuthFilter implements Filter {

    // Public paths that don't require authentication
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
        "/login", "/register", "/index.jsp", "/about", "/contact",
        "/css/", "/js/", "/uploads/"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow public resources
        if (isPublicPath(path) || path.equals("/") || path.isEmpty()) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            httpRequest.getSession().setAttribute("errorMessage", "Please log in to access this page.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Check if user is approved (except for pending users viewing their status)
        if (!user.isApproved() && !path.equals("/dashboard") && !path.equals("/logout")) {
            httpRequest.getSession().setAttribute("errorMessage", "Your account is pending approval by an admin.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
            return;
        }

        // Role-based access control
        if (path.startsWith("/admin")) {
            if (!"admin".equals(user.getRole())) {
                httpRequest.getSession().setAttribute("errorMessage", "Access denied. Admin privileges required.");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
                return;
            }
        } else if (path.startsWith("/donor/")) {
            if (!"donor".equals(user.getRole()) && !"admin".equals(user.getRole())) {
                httpRequest.getSession().setAttribute("errorMessage", "Access denied. Donor privileges required.");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
                return;
            }
        } else if (path.startsWith("/receiver/")) {
            if (!"receiver".equals(user.getRole()) && !"admin".equals(user.getRole())) {
                httpRequest.getSession().setAttribute("errorMessage", "Access denied. Receiver privileges required.");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }

    /**
     * Check if the path is in the public paths list.
     */
    private boolean isPublicPath(String path) {
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }
}
