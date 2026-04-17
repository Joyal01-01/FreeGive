package com.freegive.controller;

import com.freegive.dao.ItemDAO;
import com.freegive.model.Item;
import com.freegive.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.util.List;
import java.util.UUID;

/**
 * Handles editing existing items (donor action).
 * GET: displays edit form with current item data.
 * POST: updates the item.
 */
public class EditItemServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int itemId = Integer.parseInt(idStr);
            Item item = itemDAO.findById(itemId);

            if (item == null) {
                session.setAttribute("errorMessage", "Item not found.");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            // Check ownership (unless admin)
            if (item.getUserId() != user.getId() && !"admin".equals(user.getRole())) {
                session.setAttribute("errorMessage", "You can only edit your own items.");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            request.setAttribute("item", item);
            request.getRequestDispatcher("/WEB-INF/views/edit-item.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading item.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String tags = request.getParameter("tags");
        String zipcode = request.getParameter("zipcode");
        String expiryStr = request.getParameter("expiry");

        try {
            int itemId = Integer.parseInt(idStr);
            Item existingItem = itemDAO.findById(itemId);

            if (existingItem == null || (existingItem.getUserId() != user.getId() && !"admin".equals(user.getRole()))) {
                session.setAttribute("errorMessage", "Item not found or access denied.");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            // Update fields
            existingItem.setName(name != null ? name.trim() : existingItem.getName());
            existingItem.setDescription(description != null ? description.trim() : existingItem.getDescription());
            existingItem.setTags(tags != null ? tags.trim() : existingItem.getTags());
            existingItem.setZipcode(zipcode != null ? zipcode.trim() : existingItem.getZipcode());

            if (expiryStr != null && !expiryStr.trim().isEmpty()) {
                try {
                    existingItem.setExpiry(Date.valueOf(expiryStr.trim()));
                } catch (IllegalArgumentException e) {
                    // keep existing expiry
                }
            }

            // Handle photo upload
            try {
                Part filePart = request.getPart("photo");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
                    String uploadDir = getServletContext().getRealPath("/uploads");
                    File dir = new File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();

                    Path filePath = Paths.get(uploadDir, fileName);
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                    }
                    existingItem.setPhotoPath("uploads/" + fileName);
                }
            } catch (Exception e) {
                // Photo update is optional
            }

            // Validate
            List<String> errors = existingItem.validate();
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("item", existingItem);
                request.getRequestDispatcher("/WEB-INF/views/edit-item.jsp").forward(request, response);
                return;
            }

            boolean updated = itemDAO.update(existingItem);
            if (updated) {
                session.setAttribute("successMessage", "Item updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update item.");
            }
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                int dotIndex = fileName.lastIndexOf('.');
                if (dotIndex > 0) {
                    return fileName.substring(dotIndex);
                }
            }
        }
        return ".jpg";
    }
}
