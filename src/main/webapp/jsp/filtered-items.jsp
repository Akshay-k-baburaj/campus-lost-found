<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") %> - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --lost: #ff4757;
            --found: #2ed573;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; color: #2d3748; }

        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white; padding: 1rem 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 100;
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; }
        .nav-link { color: white; text-decoration: none; font-size: 0.9rem; padding: 8px 15px; border-radius: 20px; transition: 0.3s; }
        .nav-link:hover { background: rgba(255,255,255,0.2); }

        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }

        .filter-banner {
            background: white; padding: 25px; border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 35px;
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 20px; border-left: 5px solid var(--primary);
        }
        .filter-title h2 { color: #1a202c; font-size: 1.5rem; }

        .active-filters { display: flex; gap: 10px; align-items: center; }
        .filter-tag {
            background: #ebf4ff; color: #2b6cb0; padding: 6px 14px;
            border-radius: 20px; font-size: 0.85rem; font-weight: 700;
        }
        .btn-clear {
            color: #e53e3e; text-decoration: none; font-size: 0.85rem;
            font-weight: 600; padding: 6px 12px; border: 1px solid #fed7d7; border-radius: 8px;
        }
        .btn-clear:hover { background: #fff5f5; }

        /* Grid Styling matching view-items.jsp */
        .items-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 25px; }

        .item-card {
            background: white; border-radius: 15px; overflow: hidden;
            transition: 0.3s; box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; height: 100%;
        }
        .item-card:hover { transform: translateY(-8px); }

        .card-header { position: relative; height: 180px; background: #edf2f7; }
        .type-badge {
            position: absolute; top: 12px; left: 12px; padding: 4px 12px;
            border-radius: 20px; color: white; font-size: 0.7rem; font-weight: bold; z-index: 2;
        }

        .card-body { padding: 20px; flex-grow: 1; }
        .item-name { font-size: 1.2rem; font-weight: 700; margin-bottom: 10px; color: #1a202c; }
        .item-detail { font-size: 0.9rem; color: #718096; margin-bottom: 6px; }
        .item-loc { color: var(--primary); font-weight: 600; margin-top: 12px; display: block; }

        .btn-view {
            display: block; width: 100%; text-align: center; padding: 12px;
            background: #f8fafc; color: var(--primary); text-decoration: none;
            font-weight: 700; border-top: 1px solid #edf2f7; transition: 0.3s;
        }
        .btn-view:hover { background: var(--primary); color: white; }

        .no-results {
            text-align: center; padding: 80px 20px; background: white;
            border-radius: 20px; color: #718096;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1 style="font-size: 1.3rem;">🔍 Filtered Results</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home" class="nav-link">Home</a>
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="nav-link">All Items</a>
                <a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="filter-banner">
            <div class="filter-title">
                <h2>Showing filtered items</h2>
            </div>
            <div class="active-filters">
                <% if (request.getAttribute("selectedCategory") != null) { %>
                    <span class="filter-tag">📂 <%= request.getAttribute("selectedCategory") %></span>
                <% } %>
                <% if (request.getAttribute("selectedType") != null) { %>
                    <span class="filter-tag">🏷️ <%= request.getAttribute("selectedType") %></span>
                <% } %>
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="btn-clear">Clear All</a>
            </div>
        </div>

        <%
            List<Item> filteredItems = (List<Item>) request.getAttribute("filteredItems");
            if (filteredItems != null && !filteredItems.isEmpty()) {
        %>
            <div class="items-grid">
                <% for (Item item : filteredItems) { %>
                    <div class="item-card">
                        <div class="card-header">
                            <span class="type-badge" style="background: <%= "LOST".equals(item.getItemType()) ? "var(--lost)" : "var(--found)" %>">
                                <%= item.getItemType() %>
                            </span>
                            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" style="width:100%; height:100%; object-fit:cover;">
                            <% } else { %>
                                <div style="height:100%; display:flex; align-items:center; justify-content:center; font-size:3rem;">📦</div>
                            <% } %>
                        </div>
                        <div class="card-body">
                            <h3 class="item-name"><%= item.getItemName() %></h3>
                            <p class="item-detail"><strong>Category:</strong> <%= item.getCategory() %></p>
                            <p class="item-detail"><strong>Status:</strong> <%= item.getStatus() %></p>
                            <span class="item-loc">📍 <%= item.getLocation() %></span>
                        </div>
                        <a href="<%= request.getContextPath() %>/item?action=view&id=<%= item.getId() %>" class="btn-view">View Full Details</a>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-results">
                <div style="font-size: 4rem; margin-bottom: 20px;">🏜️</div>
                <h2>No matches found</h2>
                <p>Try clearing your filters or checking the general listings.</p>
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="btn-view" style="max-width:250px; margin: 25px auto; border: 1px solid var(--primary); border-radius: 10px;">Browse All Items</a>
            </div>
        <% } %>
    </div>
</body>
</html>