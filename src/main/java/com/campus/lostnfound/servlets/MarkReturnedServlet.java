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

@WebServlet("/mark-returned")
public class MarkReturnedServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String itemIdStr = request.getParameter("itemId");

        if (itemIdStr == null || itemIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home?action=my-items");
            return;
        }

        try {
            int itemId = Integer.parseInt(itemIdStr);
            Item item = itemDAO.getItemById(itemId);

            if (item == null) {
                response.sendRedirect(request.getContextPath() + "/home?action=my-items");
                return;
            }

            // Only owner can mark as returned
            if (item.getUserId() != userId) {
                request.setAttribute("error", "You can only mark your own items as returned!");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
                return;
            }

            // Update status to RETURNED
            if (itemDAO.updateItemStatus(itemId, "RETURNED")) {
                request.setAttribute("success",
                        "🎉 Item marked as returned! Thanks for using Campus Lost & Found!");

                // Refresh item data
                item = itemDAO.getItemById(itemId);
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to update status. Please try again.");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home?action=my-items");
        }
    }
}

