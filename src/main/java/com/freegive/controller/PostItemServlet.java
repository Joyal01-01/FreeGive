package com.freegive.controller;

import com.freegive.dao.ItemDAO;
import com.freegive.model.Item;
import com.freegive.model.User;
import com.freegive.util.Validator;

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
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * Handles posting new items (donor action).
 * GET: displays post item form.
 * POST: creates new item with optional photo upload.
 */
public class PostItemServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set default expiry to 7 days from now
        LocalDate defaultExpiry = LocalDate.now().plusDays(7);
        request.setAttribute("defaultExpiry", defaultExpiry.toString());

        request.getRequestDispatcher("/WEB-INF/views/post-item.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String tags = request.getParameter("tags");
        String zipcode = request.getParameter("zipcode");
        String expiryStr = request.getParameter("expiry");

        // Build item
        Item item = new Item();
        item.setUserId(user.getId());
        item.setName(name != null ? name.trim() : "");
        item.setDescription(description != null ? description.trim() : "");
        item.setTags(tags != null ? tags.trim() : "");
        item.setZipcode(zipcode != null ? zipcode.trim() : user.getZipcode());
        item.setStatus("available");

        // Parse expiry
        if (expiryStr != null && !expiryStr.trim().isEmpty()) {
            try {
                item.setExpiry(Date.valueOf(expiryStr.trim()));
            } catch (IllegalArgumentException e) {
                item.setExpiry(Date.valueOf(LocalDate.now().plusDays(7)));
            }
        } else {
            item.setExpiry(Date.valueOf(LocalDate.now().plusDays(7)));
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
                item.setPhotoPath("uploads/" + fileName);
            }
        } catch (Exception e) {
            // Photo upload is optional, continue without it
            e.printStackTrace();
        }

        // Validate
        List<String> errors = item.validate();

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("item", item);
            request.setAttribute("defaultExpiry", expiryStr);
            request.getRequestDispatcher("/WEB-INF/views/post-item.jsp").forward(request, response);
            return;
        }

        try {
            boolean created = itemDAO.create(item);
            if (created) {
                session.setAttribute("successMessage", "Item posted successfully!");
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Failed to post item. Please try again.");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/WEB-INF/views/post-item.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.setAttribute("item", item);
            request.getRequestDispatcher("/WEB-INF/views/post-item.jsp").forward(request, response);
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
