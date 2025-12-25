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

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if ("/dashboard".equals(pathInfo)) {
            showDashboard(request, response);
        } else if ("/manage-items".equals(pathInfo)) {
            manageItems(request, response);
        } else {
            showDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            updateItemStatus(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Item> allItems = itemDAO.getAllItems();
        request.setAttribute("items", allItems);
        request.setAttribute("totalItems", allItems.size());
        request.getRequestDispatcher("/jsp/admin-dashboard.jsp").forward(request, response);
    }

    private void manageItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Item> allItems = itemDAO.getAllItems();
        request.setAttribute("items", allItems);
        request.getRequestDispatcher("/jsp/admin-manage-items.jsp").forward(request, response);
    }

    private void updateItemStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemId = request.getParameter("itemId");
        String newStatus = request.getParameter("status");

        if (itemId == null || itemId.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-items");
            return;
        }

        try {
            int id = Integer.parseInt(itemId);

            if (itemDAO.updateItemStatus(id, newStatus)) {
                request.setAttribute("success", "Item status updated successfully");
            } else {
                request.setAttribute("error", "Failed to update status");
            }

            manageItems(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-items");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            return false;
        }

        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }
}

