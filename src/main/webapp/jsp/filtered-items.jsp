<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") %> - Campus Lost & Found</title>
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
        .filter-header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .filter-header h2 {
            color: #667eea;
            margin-bottom: 10px;
        }
        .filter-info {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-badge {
            background: #667eea;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .clear-filter {
            padding: 8px 15px;
            background: #ff6b6b;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 0.9em;
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
            <h1>📦 <%= request.getAttribute("pageTitle") %></h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%= request.getContextPath() %>/home?action=all-items">All Items</a>
                <a href="<%= request.getContextPath() %>/item?action=new">+ Post Item</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="filter-header">
            <h2>Filtered Results</h2>
            <div class="filter-info">
                <% if (request.getAttribute("selectedCategory") != null) { %>
                    <span class="filter-badge">Category: <%= request.getAttribute("selectedCategory") %></span>
                <% } %>
                <% if (request.getAttribute("selectedType") != null) { %>
                    <span class="filter-badge">Type: <%= request.getAttribute("selectedType") %></span>
                <% } %>
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="clear-filter">Clear Filters</a>
            </div>
        </div>

        <%
            List<Item> filteredItems = (List<Item>) request.getAttribute("filteredItems");
            if (filteredItems != null && !filteredItems.isEmpty()) {
        %>
            <div class="items-grid">
                <%
                    for (Item item : filteredItems) {
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
                            <p><%= item.getDescription() != null ? item.getDescription() : "No description" %></p>
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
                <h2>No items found with these filters</h2>
                <p>Try adjusting your search criteria or browse all items.</p>
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="btn">View All Items</a>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>