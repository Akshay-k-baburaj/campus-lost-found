<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Items - Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
        }
        .navbar h1 { font-size: 1.8em; }
        .nav-links {
            display: flex;
            gap: 20px;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #ff6b6b;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        thead {
            background: #ff6b6b;
            color: white;
        }
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        tbody tr:hover {
            background: #f8f9fa;
        }
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
        }
        .lost-badge {
            background: #ff4757;
            color: white;
        }
        .found-badge {
            background: #2ed573;
            color: white;
        }
        .status-open {
            background: #ffa502;
            color: white;
        }
        .status-claimed {
            background: #ff6348;
            color: white;
        }
        .status-returned {
            background: #1e90ff;
            color: white;
        }
        .status-form {
            display: inline-block;
        }
        .status-form select {
            padding: 8px 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 0.9em;
            margin-right: 5px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
        }
        .btn-update {
            background: #667eea;
            color: white;
        }
        .btn-update:hover {
            background: #764ba2;
        }
        .btn-view {
            background: #48dbfb;
            color: white;
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 0.85em;
        }
        .btn-view:hover {
            background: #0abde3;
        }
        .no-items {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>⚙️ Manage Items</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="page-header">
            <h2>All Items Management</h2>
            <p>Update item status and monitor all reported items</p>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <%
            List<Item> items = (List<Item>) request.getAttribute("items");
            if (items != null && !items.isEmpty()) {
        %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Item Name</th>
                            <th>Type</th>
                            <th>Category</th>
                            <th>Location</th>
                            <th>Current Status</th>
                            <th>Update Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Item item : items) {
                        %>
                            <tr>
                                <td>#<%= item.getId() %></td>
                                <td><strong><%= item.getItemName() %></strong></td>
                                <td>
                                    <span class="badge <%= "LOST".equals(item.getItemType()) ? "lost-badge" : "found-badge" %>">
                                        <%= item.getItemType() %>
                                    </span>
                                </td>
                                <td><%= item.getCategory() %></td>
                                <td>📍 <%= item.getLocation() %></td>
                                <td>
                                    <span class="badge <%= "OPEN".equals(item.getStatus()) ? "status-open" : "CLAIMED".equals(item.getStatus()) ? "status-claimed" : "status-returned" %>">
                                        <%= item.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <form method="POST" action="<%= request.getContextPath() %>/admin/manage-items" class="status-form">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                        <select name="status" required>
                                            <option value="">-- Select --</option>
                                            <option value="OPEN" <%= "OPEN".equals(item.getStatus()) ? "selected" : "" %>>Open</option>
                                            <option value="CLAIMED" <%= "CLAIMED".equals(item.getStatus()) ? "selected" : "" %>>Claimed</option>
                                            <option value="RETURNED" <%= "RETURNED".equals(item.getStatus()) ? "selected" : "" %>>Returned</option>
                                        </select>
                                        <button type="submit" class="btn btn-update">Update</button>
                                    </form>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/item?action=view&id=<%= item.getId() %>" class="btn-view">View</a>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        <%
            } else {
        %>
            <div class="no-items">
                <h2>No Items Found</h2>
                <p>There are currently no items in the system.</p>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>