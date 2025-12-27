<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Items - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --lost: #ff4757;
            --found: #2ed573;
            --bg: #f8f9fa;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); color: #333; }

        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white; padding: 1rem 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 100;
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; }
        .nav-links { display: flex; gap: 15px; }
        .nav-links a { color: white; text-decoration: none; padding: 8px 15px; border-radius: 20px; transition: 0.3s; font-size: 0.9rem; }
        .nav-links a:hover { background: rgba(255,255,255,0.2); }

        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }

        .page-header { margin-bottom: 30px; }
        .page-header h2 { color: var(--secondary); font-size: 2rem; }

        .items-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 25px; }

        .item-card {
            background: white; border-radius: 15px; overflow: hidden;
            transition: 0.3s; box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            display: flex; flex-direction: column;
        }
        .item-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }

        .image-container { position: relative; height: 200px; }
        .item-img { width: 100%; height: 100%; object-fit: cover; }
        .type-badge {
            position: absolute; top: 15px; right: 15px;
            padding: 5px 12px; border-radius: 20px; color: white;
            font-size: 0.75rem; font-weight: bold; text-transform: uppercase;
        }

        .item-body { padding: 20px; flex-grow: 1; }
        .item-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 10px; color: #2d3748; }
        .item-meta { font-size: 0.9rem; color: #718096; margin-bottom: 5px; display: flex; align-items: center; gap: 5px; }

        .status-pill {
            display: inline-block; padding: 4px 10px; border-radius: 6px;
            font-size: 0.8rem; font-weight: 600; margin-top: 10px;
        }
        .status-open { background: #ebf8ff; color: #3182ce; }
        .status-claimed { background: #fffaf0; color: #dd6b20; }
        .status-returned { background: #f0fff4; color: #38a169; }

        .btn-view {
            display: block; width: 100%; text-align: center;
            padding: 12px; background: #edf2f7; color: #4a5568;
            text-decoration: none; font-weight: 600; transition: 0.3s;
        }
        .btn-view:hover { background: var(--primary); color: white; }

        .no-items { text-align: center; padding: 60px; background: white; border-radius: 20px; }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>📦 My Items</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%= request.getContextPath() %>/item?action=new">Post New</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="page-header">
            <h2>Your Dashboard</h2>
            <p>Manage items you have reported</p>
        </div>

        <%
            List<Item> userItems = (List<Item>) request.getAttribute("userItems");
            if (userItems != null && !userItems.isEmpty()) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
        %>
            <div class="items-grid">
                <% for (Item item : userItems) { %>
                    <div class="item-card">
                        <div class="image-container">
                            <span class="type-badge" style="background: <%= "LOST".equals(item.getItemType()) ? "#ff4757" : "#2ed573" %>">
                                <%= item.getItemType() %>
                            </span>
                            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" class="item-img">
                            <% } else { %>
                                <div style="width:100%; height:100%; background:#edf2f7; display:flex; align-items:center; justify-content:center; font-size:3rem;">📦</div>
                            <% } %>
                        </div>
                        <div class="item-body">
                            <h3 class="item-title"><%= item.getItemName() %></h3>
                            <p class="item-meta">📍 <%= item.getLocation() %></p>
                            <p class="item-meta">📅 <%= item.getPostedDate().format(formatter) %></p>
                            <span class="status-pill status-<%= item.getStatus().toLowerCase() %>">
                                <%= item.getStatus() %>
                            </span>
                        </div>
                        <a href="<%= request.getContextPath() %>/item?action=view&id=<%= item.getId() %>" class="btn-view">Manage Details</a>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-items">
                <h2>No items found</h2>
                <a href="<%= request.getContextPath() %>/item?action=new" class="btn-view" style="max-width:200px; margin:20px auto; border-radius:8px;">Post Item</a>
            </div>
        <% } %>
    </div>
</body>
</html>