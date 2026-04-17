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
import java.util.List;

/**
 * Dashboard servlet - routes to role-specific dashboard views.
 */
public class DashboardServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String role = user.getRole();

            switch (role) {
                case "admin":
                    request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
                    break;

                case "donor":
                    // Load donor's items
                    List<Item> donorItems = itemDAO.findByUserId(user.getId());
                    request.setAttribute("items", donorItems);

                    // Load claims for donor's items
                    for (Item item : donorItems) {
                        Claim claim = claimDAO.findByItemId(item.getId());
                        if (claim != null) {
                            request.setAttribute("claim_" + item.getId(), claim);
                        }
                    }

                    request.getRequestDispatcher("/WEB-INF/views/donor-dashboard.jsp").forward(request, response);
                    break;

                case "receiver":
                    // Load receiver's claims
                    List<Claim> myClaims = claimDAO.findByUserId(user.getId());
                    request.setAttribute("claims", myClaims);
                    request.getRequestDispatcher("/WEB-INF/views/receiver-dashboard.jsp").forward(request, response);
                    break;

                case "pending":
                default:
                    // Pending user sees waiting message
                    request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred loading your dashboard.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
