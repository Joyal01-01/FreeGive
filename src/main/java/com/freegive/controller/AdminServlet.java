package com.freegive.controller;

import com.freegive.dao.ClaimDAO;
import com.freegive.dao.ItemDAO;
import com.freegive.dao.UserDAO;
import com.freegive.model.Item;
import com.freegive.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Handles admin operations: user management, item management, reports.
 * GET: displays admin panels.
 * POST: processes admin actions (approve/block/delete).
 */
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String tab = request.getParameter("tab");
        if (tab == null) tab = "users";

        try {
            // Load data for admin dashboard
            List<User> users = userDAO.findAll();
            List<Item> items = itemDAO.findAll();

            request.setAttribute("users", users);
            request.setAttribute("items", items);
            request.setAttribute("activeTab", tab);

            // Reports data
            if ("reports".equals(tab)) {
                int totalUsers = users.size();
                int pendingCount = userDAO.countByRole("pending");
                int donorCount = userDAO.countByRole("donor");
                int receiverCount = userDAO.countByRole("receiver");
                int totalItems = itemDAO.countAll();
                int availableItems = itemDAO.countByStatus("available");
                int claimedItems = itemDAO.countByStatus("claimed");
                int totalClaims = claimDAO.getClaimsCount();
                List<Map<String, Object>> topCategories = claimDAO.getTopCategories();

                request.setAttribute("totalUsers", totalUsers);
                request.setAttribute("pendingCount", pendingCount);
                request.setAttribute("donorCount", donorCount);
                request.setAttribute("receiverCount", receiverCount);
                request.setAttribute("totalItems", totalItems);
                request.setAttribute("availableItems", availableItems);
                request.setAttribute("claimedItems", claimedItems);
                request.setAttribute("totalClaims", totalClaims);
                request.setAttribute("topCategories", topCategories);
            }

            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred loading admin data.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "") {
                case "approve":
                    handleApproveUser(request, session);
                    break;
                case "block":
                    handleBlockUser(request, session);
                    break;
                case "changeRole":
                    handleChangeRole(request, session);
                    break;
                case "deleteUser":
                    handleDeleteUser(request, session);
                    break;
                case "deleteItem":
                    handleDeleteItem(request, session);
                    break;
                default:
                    session.setAttribute("errorMessage", "Unknown action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }

        // Redirect back to admin with the same tab
        String tab = request.getParameter("tab");
        response.sendRedirect(request.getContextPath() + "/admin?tab=" + (tab != null ? tab : "users"));
    }

    private void handleApproveUser(HttpServletRequest request, HttpSession session) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean success = userDAO.updateApproved(userId, true);
        if (success) {
            session.setAttribute("successMessage", "User approved successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to approve user.");
        }
    }

    private void handleBlockUser(HttpServletRequest request, HttpSession session) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean success = userDAO.updateApproved(userId, false);
        if (success) {
            session.setAttribute("successMessage", "User blocked successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to block user.");
        }
    }

    private void handleChangeRole(HttpServletRequest request, HttpSession session) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newRole = request.getParameter("newRole");
        if (newRole != null && !newRole.isEmpty()) {
            boolean success = userDAO.updateRole(userId, newRole);
            if (success) {
                session.setAttribute("successMessage", "User role updated to: " + newRole);
            } else {
                session.setAttribute("errorMessage", "Failed to update user role.");
            }
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpSession session) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean success = userDAO.delete(userId);
        if (success) {
            session.setAttribute("successMessage", "User deleted successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to delete user.");
        }
    }

    private void handleDeleteItem(HttpServletRequest request, HttpSession session) throws Exception {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        boolean success = itemDAO.delete(itemId);
        if (success) {
            session.setAttribute("successMessage", "Item deleted successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to delete item.");
        }
    }
}
