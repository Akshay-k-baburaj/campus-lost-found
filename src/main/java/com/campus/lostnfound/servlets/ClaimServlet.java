package com.campus.lostnfound.servlets;

import com.campus.lostnfound.dao.ItemDAO;
import com.campus.lostnfound.dao.UserDAO;
import com.campus.lostnfound.models.Item;
import com.campus.lostnfound.models.User;
import com.campus.lostnfound.utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/claim")
public class ClaimServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int claimerId = (Integer) session.getAttribute("userId");
        String claimerName = (String) session.getAttribute("fullName");
        String itemIdStr = request.getParameter("itemId");

        if (itemIdStr == null || itemIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home?action=all-items");
            return;
        }

        try {
            int itemId = Integer.parseInt(itemIdStr);
            Item item = itemDAO.getItemById(itemId);

            if (item == null) {
                response.sendRedirect(request.getContextPath() + "/home?action=all-items");
                return;
            }

            // Prevent self-claiming
            if (item.getUserId() == claimerId) {
                request.setAttribute("error", "You cannot claim your own item!");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
                return;
            }

            // Prevent claiming non-open items
            if (!"OPEN".equals(item.getStatus())) {
                request.setAttribute("error", "This item has already been claimed!");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
                return;
            }

            // Update item status to CLAIMED
            if (itemDAO.claimItem(itemId, claimerId)) {

                // Get owner details
                User owner = userDAO.getUserById(item.getUserId());
                User claimer = userDAO.getUserById(claimerId);

                // Send email notifications
                if (owner != null && claimer != null) {
                    // Notify owner
                    EmailUtil.sendClaimNotification(
                            owner.getEmail(),
                            owner.getFullName(),
                            item.getItemName(),
                            claimer.getFullName(),
                            claimer.getPhone()
                    );

                    // Confirm to claimer
                    EmailUtil.sendClaimConfirmation(
                            claimer.getEmail(),
                            claimer.getFullName(),
                            item.getItemName(),
                            owner.getPhone()
                    );
                }

                request.setAttribute("success",
                        "✅ Item claimed! The owner has been notified via email. " +
                                "They will contact you at: " + claimer.getPhone());

                // Refresh item data
                item = itemDAO.getItemById(itemId);
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to claim item. Please try again.");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/jsp/item-detail.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home?action=all-items");
        }
    }
}
