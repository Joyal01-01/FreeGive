package com.freegive.controller;

import com.freegive.dao.ClaimDAO;
import com.freegive.dao.ItemDAO;
import com.freegive.model.Claim;
import com.freegive.model.Item;
import com.freegive.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Handles item claiming (receiver action).
 * POST: claims an available item, updates status.
 */
public class ClaimServlet extends HttpServlet {

    private ClaimDAO claimDAO = new ClaimDAO();
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String itemIdStr = request.getParameter("itemId");
        String ratingStr = request.getParameter("rating");
        String claimIdStr = request.getParameter("claimId");

        // Handle rating update
        if (ratingStr != null && claimIdStr != null) {
            try {
                int claimId = Integer.parseInt(claimIdStr);
                int rating = Integer.parseInt(ratingStr);
                if (rating >= 1 && rating <= 5) {
                    claimDAO.updateRating(claimId, rating);
                    session.setAttribute("successMessage", "Rating submitted successfully!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Failed to submit rating.");
            }
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Handle new claim
        if (itemIdStr == null) {
            session.setAttribute("errorMessage", "Invalid item.");
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        try {
            int itemId = Integer.parseInt(itemIdStr);
            Item item = itemDAO.findById(itemId);

            if (item == null) {
                session.setAttribute("errorMessage", "Item not found.");
                response.sendRedirect(request.getContextPath() + "/search");
                return;
            }

            if (!"available".equals(item.getStatus())) {
                session.setAttribute("errorMessage", "This item has already been claimed.");
                response.sendRedirect(request.getContextPath() + "/search");
                return;
            }

            // Check if user already claimed this item
            if (claimDAO.hasUserClaimed(itemId, user.getId())) {
                session.setAttribute("errorMessage", "You have already claimed this item.");
                response.sendRedirect(request.getContextPath() + "/search");
                return;
            }

            // Prevent donor from claiming their own item
            if (item.getUserId() == user.getId()) {
                session.setAttribute("errorMessage", "You cannot claim your own item.");
                response.sendRedirect(request.getContextPath() + "/search");
                return;
            }

            // Create claim and update item status
            Claim claim = new Claim(itemId, user.getId());
            boolean claimed = claimDAO.create(claim);
            if (claimed) {
                itemDAO.updateStatus(itemId, "claimed");
                session.setAttribute("successMessage", "Item claimed successfully! Contact the donor to arrange pickup.");
            } else {
                session.setAttribute("errorMessage", "Failed to claim item. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while claiming the item.");
        }

        response.sendRedirect(request.getContextPath() + "/search");
    }
}
