<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Items - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --lost: #ff4757;
            --found: #2ed573;
            --bg: #f0f2f5;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); color: #2d3748; }

        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white; padding: 1rem 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 100;
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; }
        .nav-links { display: flex; gap: 15px; }
        .nav-link { color: white; text-decoration: none; padding: 8px 15px; border-radius: 20px; transition: 0.3s; font-size: 0.9rem; }
        .nav-link:hover { background: rgba(255,255,255,0.2); }

        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }

        /* Search Section */
        .search-card {
            background: white; padding: 25px; border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 30px;
        }
        .search-form { display: flex; gap: 12px; }
        .search-input {
            flex: 1; padding: 12px 20px; border: 2px solid #e2e8f0;
            border-radius: 10px; font-size: 1rem; outline: none; transition: 0.3s;
        }
        .search-input:focus { border-color: var(--primary); }
        .search-btn {
            padding: 0 30px; background: var(--primary); color: white;
            border: none; border-radius: 10px; font-weight: bold; cursor: pointer; transition: 0.3s;
        }
        .search-btn:hover { background: var(--secondary); }

        /* Grid Section */
        .items-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 25px; }

        .item-card {
            background: white; border-radius: 15px; overflow: hidden;
            transition: 0.3s; box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            display: flex; flex-direction: column;
        }
        .item-card:hover { transform: translateY(-8px); }

        .img-wrapper { position: relative; height: 200px; background: #f8fafc; }
        .item-img { width: 100%; height: 100%; object-fit: cover; }
        .placeholder-img { height: 100%; display: flex; align-items: center; justify-content: center; font-size: 3rem; color: #cbd5e0; }

        .type-badge {
            position: absolute; top: 12px; left: 12px; padding: 4px 12px;
            border-radius: 20px; color: white; font-size: 0.75rem; font-weight: bold;
        }

        .item-body { padding: 20px; flex-grow: 1; }
        .item-title { font-size: 1.2rem; font-weight: 700; margin-bottom: 8px; }
        .item-info { font-size: 0.9rem; color: #718096; margin-bottom: 5px; }
        .item-loc { color: var(--primary); font-weight: 600; margin-top: 10px; display: block; }

        .btn-details {
            display: block; width: 100%; text-align: center; padding: 12px;
            background: #f8fafc; color: var(--primary); text-decoration: none;
            font-weight: 700; border-top: 1px solid #edf2f7; transition: 0.3s;
        }
        .btn-details:hover { background: var(--primary); color: white; }

        .no-results { text-align: center; padding: 50px; background: white; border-radius: 16px; color: #718096; }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1 style="font-size: 1.4rem;">📦 Campus Lost & Found</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home" class="nav-link">Home</a>
                <a href="<%= request.getContextPath() %>/item?action=new" class="nav-link">Post Item</a>
                <a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="search-card">
            <form method="GET" action="<%= request.getContextPath() %>/item" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="search-input" placeholder="Search for items (e.g. keys, wallet, phone)..."
                       value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>

        <%
            List<Item> items = (List<Item>) request.getAttribute("items");
            if (items != null && !items.isEmpty()) {
        %>
            <div class="items-grid">
                <% for (Item item : items) { %>
                    <div class="item-card">
                        <div class="img-wrapper">
                            <span class="type-badge" style="background: <%= "LOST".equals(item.getItemType()) ? "var(--lost)" : "var(--found)" %>">
                                <%= item.getItemType() %>
                            </span>
                            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" class="item-img">
                            <% } else { %>
                                <div class="placeholder-img">📦</div>
                            <% } %>
                        </div>
                        <div class="item-body">
                            <h3 class="item-title"><%= item.getItemName() %></h3>
                            <p class="item-info"><strong>Category:</strong> <%= item.getCategory() %></p>
                            <p class="item-info"><strong>Status:</strong> <%= item.getStatus() %></p>
                            <span class="item-loc">📍 <%= item.getLocation() %></span>
                        </div>
                        <a href="<%= request.getContextPath() %>/item?action=view&id=<%= item.getId() %>" class="btn-details">View Details</a>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-results">
                <h2>No items found</h2>
                <p>Try a different keyword or check back later!</p>
            </div>
        <% } %>
    </div>
</body>
</html>