package com.freegive.controller;

import com.freegive.dao.ItemDAO;
import com.freegive.model.Item;
import com.freegive.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Handles deleting items (donor action).
 * POST: deletes an item owned by the logged-in donor.
 */
public class DeleteItemServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String idStr = request.getParameter("id");

        if (idStr == null) {
            session.setAttribute("errorMessage", "Invalid item ID.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int itemId = Integer.parseInt(idStr);
            boolean deleted;

            if ("admin".equals(user.getRole())) {
                deleted = itemDAO.delete(itemId);
            } else {
                deleted = itemDAO.deleteByUserIdAndItemId(itemId, user.getId());
            }

            if (deleted) {
                session.setAttribute("successMessage", "Item deleted successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to delete item. It may not exist or you don't have permission.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while deleting the item.");
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
