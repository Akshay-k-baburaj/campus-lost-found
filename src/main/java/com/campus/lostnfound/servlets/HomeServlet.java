package com.campus.lostnfound.servlets;

import com.campus.lostnfound.dao.CategoryDAO;
import com.campus.lostnfound.dao.ItemDAO;
import com.campus.lostnfound.models.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "dashboard";
        }

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "my-items":
                showMyItems(request, response);
                break;
            case "all-items":
                showAllItems(request, response);
                break;
            case "filter-category":
                filterByCategory(request, response);
                break;
            case "filter-type":
                filterByType(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    /**
     * Show main dashboard with statistics
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        String fullName = (String) session.getAttribute("fullName");

        // Get user's items
        List<Item> userItems = itemDAO.getItemsByUserId(userId);

        // Get all open items
        List<Item> allOpenItems = itemDAO.getAllItems();

        // Get categories
        List<Map<String, Object>> categories = categoryDAO.getAllCategories();

        // Get statistics
        Map<String, Integer> stats = itemDAO.getItemStatistics();

        // Set attributes
        request.setAttribute("fullName", fullName);
        request.setAttribute("userItems", userItems);
        request.setAttribute("allOpenItems", allOpenItems);
        request.setAttribute("categories", categories);
        request.setAttribute("stats", stats);
        request.setAttribute("userItemsCount", userItems.size());
        request.setAttribute("totalOpenItems", allOpenItems.size());

        request.getRequestDispatcher("/jsp/home.jsp").forward(request, response);
    }

    /**
     * Show only items posted by current user
     */
    private void showMyItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        List<Item> userItems = itemDAO.getItemsByUserId(userId);
        List<Map<String, Object>> categories = categoryDAO.getAllCategories();

        request.setAttribute("userItems", userItems);
        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", "My Items");
        request.setAttribute("showMyItems", true);

        request.getRequestDispatcher("/jsp/my-items.jsp").forward(request, response);
    }

    /**
     * Show all open items for browsing
     */
    private void showAllItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Item> allItems = itemDAO.getAllItems();
        List<Map<String, Object>> categories = categoryDAO.getAllCategories();

        // Count LOST and FOUND items
        int lostCount = 0;
        int foundCount = 0;

        for (Item item : allItems) {
            if ("LOST".equals(item.getItemType())) {
                lostCount++;
            } else if ("FOUND".equals(item.getItemType())) {
                foundCount++;
            }
        }

        request.setAttribute("allItems", allItems);
        request.setAttribute("categories", categories);
        request.setAttribute("lostCount", lostCount);
        request.setAttribute("foundCount", foundCount);
        request.setAttribute("pageTitle", "All Items");

        request.getRequestDispatcher("/jsp/all-items.jsp").forward(request, response);
    }

    /**
     * Filter items by category
     */
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");

        if (category == null || category.isEmpty()) {
            showAllItems(request, response);
            return;
        }

        List<Item> filteredItems = itemDAO.getItemsByCategory(category);
        List<Map<String, Object>> categories = categoryDAO.getAllCategories();

        request.setAttribute("filteredItems", filteredItems);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("pageTitle", "Items - " + category);
        request.setAttribute("filterApplied", true);

        request.getRequestDispatcher("/jsp/filtered-items.jsp").forward(request, response);
    }

    /**
     * Filter items by type (LOST or FOUND)
     */
    private void filterByType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemType = request.getParameter("type");

        if (itemType == null || itemType.isEmpty()) {
            showAllItems(request, response);
            return;
        }

        if (!itemType.equals("LOST") && !itemType.equals("FOUND")) {
            showAllItems(request, response);
            return;
        }

        List<Item> filteredItems = itemDAO.getItemsByType(itemType);
        List<Map<String, Object>> categories = categoryDAO.getAllCategories();

        request.setAttribute("filteredItems", filteredItems);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedType", itemType);
        request.setAttribute("pageTitle", itemType + " Items");
        request.setAttribute("filterApplied", true);

        request.getRequestDispatcher("/jsp/filtered-items.jsp").forward(request, response);
    }
}
