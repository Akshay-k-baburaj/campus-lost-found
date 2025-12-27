package com.campus.lostnfound.servlets;

import com.campus.lostnfound.dao.ItemDAO;
import com.campus.lostnfound.models.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet("/item")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ItemServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();

    // Upload directory
    private static final String UPLOAD_DIR = "uploads/items";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                listItems(request, response);
                break;
            case "search":
                searchItems(request, response);
                break;
            case "view":
                viewItem(request, response);
                break;
            case "new":
                showNewItemForm(request, response);
                break;
            default:
                listItems(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addItem(request, response);
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Item> items = itemDAO.getAllItems();
        request.setAttribute("items", items);
        request.getRequestDispatcher("/jsp/view-items.jsp").forward(request, response);
    }

    private void searchItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.isEmpty()) {
            keyword = "";
        }

        List<Item> items;
        if (keyword.isEmpty()) {
            items = itemDAO.getAllItems();
        } else {
            items = itemDAO.searchItems(keyword);
        }

        request.setAttribute("items", items);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/jsp/view-items.jsp").forward(request, response);
    }

    private void viewItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemId = request.getParameter("id");

        if (itemId == null || itemId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
            return;
        }

        try {
            int id = Integer.parseInt(itemId);
            Item item = itemDAO.getItemById(id);

            if (item != null) {
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/item?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
        }
    }

    private void showNewItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/jsp/post-item.jsp").forward(request, response);
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        String itemType = request.getParameter("itemType");
        String location = request.getParameter("location");
        String contactInfo = request.getParameter("contactInfo");
        String category = request.getParameter("category");

        // Validation
        if (itemName == null || itemName.isEmpty() || itemType == null || itemType.isEmpty()) {
            request.setAttribute("error", "Item name and type are required");
            request.getRequestDispatcher("/jsp/post-item.jsp").forward(request, response);
            return;
        }

        // Handle image upload
        String imagePath = null;
        try {
            Part filePart = request.getPart("itemImage");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Validate file extension
                String fileExtension = "";
                int lastDotIndex = fileName.lastIndexOf(".");
                if (lastDotIndex > 0) {
                    fileExtension = fileName.substring(lastDotIndex).toLowerCase();
                }

                if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)")) {
                    request.setAttribute("error", "Only JPG, PNG, and GIF images are allowed");
                    request.getRequestDispatcher("/jsp/post-item.jsp").forward(request, response);
                    return;
                }

                // Generate unique filename
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                // Get upload directory path
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Save file
                Path filePath = Paths.get(uploadPath, uniqueFileName);
                Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                // Store relative path for database
                imagePath = UPLOAD_DIR + "/" + uniqueFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Continue without image if upload fails
        }

        // Create item with image path
        Item item = new Item(userId, itemName, description, itemType, location, contactInfo, category, imagePath);

        if (itemDAO.addItem(item)) {
            response.sendRedirect(request.getContextPath() + "/home?action=my-items");
        } else {
            request.setAttribute("error", "Failed to post item. Try again.");
            request.getRequestDispatcher("/jsp/post-item.jsp").forward(request, response);
        }
    }
}