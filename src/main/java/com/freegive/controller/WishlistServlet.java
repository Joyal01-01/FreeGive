package com.freegive.controller;

import com.freegive.dao.ItemDAO;
import com.freegive.model.Item;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles session-based wishlist (receiver feature).
 * GET: displays wishlist.
 * POST: adds/removes items from wishlist.
 */
public class WishlistServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlist");

        if (wishlistIds == null) {
            wishlistIds = new ArrayList<>();
        }

        // Load full item objects for display
        List<Item> wishlistItems = new ArrayList<>();
        for (Integer itemId : wishlistIds) {
            try {
                Item item = itemDAO.findById(itemId);
                if (item != null) {
                    wishlistItems.add(item);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("wishlistItems", wishlistItems);
        request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlist");

        if (wishlistIds == null) {
            wishlistIds = new ArrayList<>();
            session.setAttribute("wishlist", wishlistIds);
        }

        String action = request.getParameter("action");
        String itemIdStr = request.getParameter("itemId");

        if (itemIdStr != null) {
            try {
                int itemId = Integer.parseInt(itemIdStr);

                if ("add".equals(action)) {
                    if (!wishlistIds.contains(itemId)) {
                        wishlistIds.add(itemId);
                        session.setAttribute("successMessage", "Item added to wishlist!");
                    } else {
                        session.setAttribute("errorMessage", "Item is already in your wishlist.");
                    }
                } else if ("remove".equals(action)) {
                    wishlistIds.remove(Integer.valueOf(itemId));
                    session.setAttribute("successMessage", "Item removed from wishlist.");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid item ID.");
            }
        }

        // Redirect back to referring page or wishlist
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/search")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/receiver/wishlist");
        }
    }
}
