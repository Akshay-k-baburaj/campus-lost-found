<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Items - Campus Lost & Found</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
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
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .filter-section h2 {
            color: #667eea;
            margin-bottom: 15px;
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }
        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s;
        }
        .filter-btn:hover {
            background: #667eea;
            color: white;
        }
        .filter-btn.active {
            background: #667eea;
            color: white;
        }
        .stats-row {
            display: flex;
            gap: 20px;
            margin-top: 15px;
        }
        .stat-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            flex: 1;
        }
        .stat-box h3 {
            color: #667eea;
            font-size: 1.8em;
            margin-bottom: 5px;
        }
        .stat-box p {
            color: #666;
        }
        .items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .item-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s;
        }
        .item-card:hover {
            transform: translateY(-5px);
        }
        .item-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
        }
        .item-header h3 {
            margin-bottom: 5px;
        }
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8em;
            margin-right: 5px;
        }
        .lost-badge {
            background: #ff4757;
            color: white;
        }
        .found-badge {
            background: #2ed573;
            color: white;
        }
        .item-body {
            padding: 15px;
        }
        .item-body p {
            margin: 8px 0;
            color: #666;
            font-size: 0.95em;
        }
        .item-location {
            color: #667eea;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            border: none;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn:hover {
            background: #764ba2;
        }
        .no-items {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 10px;
            color: #666;
        }
        .no-items h2 {
            color: #667eea;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>📦 All Items</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%= request.getContextPath() %>/home?action=my-items">My Items</a>
                <a href="<%= request.getContextPath() %>/item?action=new">+ Post Item</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="filter-section">
            <h2>Browse & Filter Items</h2>

            <div class="stats-row">
                <div class="stat-box">
                    <h3><%= request.getAttribute("lostCount") != null ? request.getAttribute("lostCount") : 0 %></h3>
                    <p>Lost Items</p>
                </div>
                <div class="stat-box">
                    <h3><%= request.getAttribute("foundCount") != null ? request.getAttribute("foundCount") : 0 %></h3>
                    <p>Found Items</p>
                </div>
            </div>

            <h3 style="margin-top: 20px; margin-bottom: 10px; color: #667eea;">Filter by Type:</h3>
            <div class="filter-buttons">
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="filter-btn">All Items</a>
                <a href="<%= request.getContextPath() %>/home?action=filter-type&type=LOST" class="filter-btn">Lost Items</a>
                <a href="<%= request.getContextPath() %>/home?action=filter-type&type=FOUND" class="filter-btn">Found Items</a>
            </div>

            <h3 style="margin-top: 15px; margin-bottom: 10px; color: #667eea;">Filter by Category:</h3>
            <div class="filter-buttons">
                <%
                    List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categories");
                    if (categories != null) {
                        for (Map<String, Object> category : categories) {
                %>
                    <a href="<%= request.getContextPath() %>/home?action=filter-category&category=<%= category.get("name") %>" class="filter-btn">
                        <%= category.get("name") %>
                    </a>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <%
            List<Item> allItems = (List<Item>) request.getAttribute("allItems");
            if (allItems != null && !allItems.isEmpty()) {
        %>
            <div class="items-grid">
                <%
                    for (Item item : allItems) {
                %>
                    <div class="item-card">
                        <div class="item-header">
                            <h3><%= item.getItemName() %></h3>
                            <span class="badge <%= "LOST".equals(item.getItemType()) ? "lost-badge" : "found-badge" %>">
                                <%= item.getItemType() %>
                            </span>
                        </div>
                        <div class="item-body">
                            <p><strong>Category:</strong> <%= item.getCategory() %></p>
                            <p class="item-location">📍 <%= item.getLocation() %></p>
                            <p><strong>Status:</strong> <%= item.getStatus() %></p>
                            <p><%= item.getDescription() != null && item.getDescription().length() > 100 ? item.getDescription().substring(0, 100) + "..." : item.getDescription() %></p>
                            <p><strong>Contact:</strong> <%= item.getContactInfo() %></p>
                            <a href="<%= request.getContextPath() %>/item?action=view&id=<%= item.getId() %>" class="btn">View Details</a>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        <%
            } else {
        %>
            <div class="no-items">
                <h2>📭 No Items Found</h2>
                <p>There are currently no items posted. Be the first to post!</p>
                <a href="<%= request.getContextPath() %>/item?action=new" class="btn">Post an Item</a>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>