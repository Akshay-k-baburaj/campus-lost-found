<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Items - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --lost: #ff4757;
            --found: #2ed573;
            --bg: #f8f9fa;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', system-ui, sans-serif; background: var(--bg); color: #2d3748; line-height: 1.6; }

        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white; padding: 1rem 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 100;
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; }
        .nav-links { display: flex; gap: 10px; }
        .nav-link { color: white; text-decoration: none; padding: 8px 15px; border-radius: 20px; transition: 0.3s; font-size: 0.9rem; font-weight: 500; }
        .nav-link:hover { background: rgba(255,255,255,0.2); }

        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }

        /* Stats Section */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card {
            background: white; padding: 20px; border-radius: 15px; text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-bottom: 4px solid var(--primary);
        }
        .stat-card h3 { font-size: 2rem; color: var(--primary); margin-bottom: 5px; }
        .stat-card p { font-size: 0.9rem; color: #718096; font-weight: 600; text-transform: uppercase; }

        /* Filter Section */
        .filter-card { background: white; padding: 30px; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); margin-bottom: 40px; }
        .filter-group { margin-bottom: 20px; }
        .filter-group:last-child { margin-bottom: 0; }
        .filter-group label { display: block; margin-bottom: 12px; font-weight: 700; color: #4a5568; font-size: 0.9rem; }

        .filter-btns { display: flex; gap: 10px; flex-wrap: wrap; }
        .f-btn {
            padding: 8px 18px; border-radius: 12px; border: 2px solid #e2e8f0;
            background: white; color: #4a5568; text-decoration: none;
            font-size: 0.85rem; font-weight: 600; transition: 0.3s;
        }
        .f-btn:hover { border-color: var(--primary); color: var(--primary); background: #f0f4ff; }
        .f-btn.active { background: var(--primary); border-color: var(--primary); color: white; }

        /* Item Grid */
        .items-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 30px; }
        .item-card {
            background: white; border-radius: 18px; overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex; flex-direction: column; box-shadow: 0 4px 6px rgba(0,0,0,0.04);
        }
        .item-card:hover { transform: translateY(-10px); box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); }

        .img-container { position: relative; height: 220px; background: #edf2f7; }
        .item-img { width: 100%; height: 100%; object-fit: cover; }
        .type-tag {
            position: absolute; top: 15px; left: 15px; padding: 5px 14px;
            border-radius: 30px; color: white; font-size: 0.7rem; font-weight: 800; text-transform: uppercase;
        }

        .card-content { padding: 24px; flex-grow: 1; }
        .item-name { font-size: 1.25rem; font-weight: 700; margin-bottom: 8px; color: #1a202c; }
        .item-meta { font-size: 0.9rem; color: #718096; margin-bottom: 12px; display: flex; align-items: center; gap: 6px; }
        .description { font-size: 0.95rem; color: #4a5568; margin-bottom: 20px; }

        .btn-view {
            display: block; width: 100%; text-align: center; padding: 14px;
            background: #f7fafc; color: var(--primary); text-decoration: none;
            font-weight: 700; border-top: 1px solid #edf2f7; transition: 0.3s;
        }
        .btn-view:hover { background: var(--primary); color: white; }

        .empty-state { text-align: center; padding: 80px; background: white; border-radius: 20px; }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1 style="font-size: 1.5rem;">📦 Campus Explorer</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home" class="nav-link">Home</a>
                <a href="<%= request.getContextPath() %>/home?action=my-items" class="nav-link">My Postings</a>
                <a href="<%= request.getContextPath() %>/item?action=new" class="nav-link" style="background: rgba(255,255,255,0.2);">+ Post Item</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="stats-grid">
            <div class="stat-card" style="border-color: var(--lost);">
                <h3><%= request.getAttribute("lostCount") != null ? request.getAttribute("lostCount") : 0 %></h3>
                <p>Lost Items</p>
            </div>
            <div class="stat-card" style="border-color: var(--found);">
                <h3><%= request.getAttribute("foundCount") != null ? request.getAttribute("foundCount") : 0 %></h3>
                <p>Found Items</p>
            </div>
            <div class="stat-card">
                <h3><%= ((List)request.getAttribute("allItems")).size() %></h3>
                <p>Total Active</p>
            </div>
        </div>

        <div class="filter-card">
            <div class="filter-group">
                <label>Narrow by Status</label>
                <div class="filter-btns">
                    <a href="<%= request.getContextPath() %>/home?action=all-items" class="f-btn">All Reports</a>
                    <a href="<%= request.getContextPath() %>/home?action=filter-type&type=LOST" class="f-btn">Lost Only</a>
                    <a href="<%= request.getContextPath() %>/home?action=filter-type&type=FOUND" class="f-btn">Found Only</a>
                </div>
            </div>

            <div class="filter-group">
                <label>Browse Categories</label>
                <div class="filter-btns">
                    <%
                        List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categories");
                        if (categories != null) {
                            for (Map<String, Object> category : categories) {
                    %>
                        <a href="<%= request.getContextPath() %>/home?action=filter-category&category=<%= category.get("name") %>" class="f-btn">
                            <%= category.get("name") %>
                        </a>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
        </div>

        <%
            List<Item> allItems = (List<Item>) request.getAttribute("allItems");
            if (allItems != null && !allItems.isEmpty()) {
        %>
            <div class="items-grid">
                <% for (Item item : allItems) { %>
                    <div class="item-card">
                        <div class="img-container">
                            <span class="type-tag" style="background: <%= "LOST".equals(item.getItemType()) ? "var(--lost)" : "var(--found)" %>">
                                <%= item.getItemType() %>
                            </span>
                            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" class="item-img" alt="Item Image">
                            <% } else { %>
                                <div style="height:100%; display:flex; align-items:center; justify-content:center; font-size:3.5rem; color:#cbd5e0;">📦</div>
                            <% } %>
                        </div>
                        <div class="card-content">
                            <h3 class="item-name"><%= item.getItemName() %></h3>
                            <div class="item-meta">📍 <strong><%= item.getLocation() %></strong></div>
                            <p class="description">
                                <%= item.getDescription() != null && item.getDescription().length() > 85 ? item.getDescription().substring(0, 85) + "..." : (item.getDescription() != null ? item.getDescription() : "No details provided.") %>
                            </p>
                            <div class="item-meta" style="font-size: 0.8rem; margin-top: auto;">
                                📁 <%= item.getCategory() %> • 📞 <%= item.getContactInfo() %>
                            </div>
                        </div>
                        <a href="<%= request.getContextPath() %>/item?action=view&id=<%= item.getId() %>" class="btn-view">Details & Contact</a>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div style="font-size: 4rem; margin-bottom: 20px;">🔎</div>
                <h2>No items reported yet</h2>
                <p>Check back later or help the community by posting a report.</p>
                <a href="<%= request.getContextPath() %>/item?action=new" class="btn-view" style="max-width:200px; margin: 30px auto; border: 1px solid var(--primary); border-radius: 12px;">Start a Posting</a>
            </div>
        <% } %>
    </div>
</body>
</html>