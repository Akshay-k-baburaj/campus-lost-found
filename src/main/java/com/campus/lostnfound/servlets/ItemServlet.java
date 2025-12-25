package com.campus.lostnfound.servlets;

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

@WebServlet("/item")
public class ItemServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();

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

        Item item = new Item(userId, itemName, description, itemType, location, contactInfo, category);

        if (itemDAO.addItem(item)) {
            request.setAttribute("success", "Item posted successfully!");
            response.sendRedirect(request.getContextPath() + "/item?action=list");
        } else {
            request.setAttribute("error", "Failed to post item. Try again.");
            request.getRequestDispatcher("/jsp/post-item.jsp").forward(request, response);
        }
    }
}

