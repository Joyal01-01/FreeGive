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
import java.util.List;

/**
 * Handles item search functionality.
 * GET: displays search form and results.
 */
public class SearchServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String tag = request.getParameter("tag");
        String zipcode = request.getParameter("zipcode");
        String nearMe = request.getParameter("nearMe");

        try {
            List<Item> results;

            // If "near me" is checked, use the logged-in user's zipcode
            if ("on".equals(nearMe) || "true".equals(nearMe)) {
                HttpSession session = request.getSession(false);
                User user = (session != null) ? (User) session.getAttribute("user") : null;
                if (user != null) {
                    zipcode = user.getZipcode();
                }
            }

            boolean hasSearchParams = (keyword != null && !keyword.trim().isEmpty()) ||
                                       (tag != null && !tag.trim().isEmpty()) ||
                                       (zipcode != null && !zipcode.trim().isEmpty());

            if (hasSearchParams) {
                results = itemDAO.search(keyword, tag, zipcode);
                request.setAttribute("searched", true);
            } else {
                results = itemDAO.findAvailable();
                request.setAttribute("searched", false);
            }

            request.setAttribute("results", results);
            request.setAttribute("keyword", keyword);
            request.setAttribute("tag", tag);
            request.setAttribute("zipcode", zipcode);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while searching.");
        }

        request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET with parameters
        String keyword = request.getParameter("keyword");
        String tag = request.getParameter("tag");
        String zipcode = request.getParameter("zipcode");
        String nearMe = request.getParameter("nearMe");

        StringBuilder url = new StringBuilder(request.getContextPath() + "/search?");
        if (keyword != null) url.append("keyword=").append(keyword).append("&");
        if (tag != null) url.append("tag=").append(tag).append("&");
        if (zipcode != null) url.append("zipcode=").append(zipcode).append("&");
        if (nearMe != null) url.append("nearMe=").append(nearMe);

        response.sendRedirect(url.toString());
    }
}
