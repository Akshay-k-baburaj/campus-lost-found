<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Details - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --lost: #ff4757;
            --found: #2ed573;
            --warning: #f6ad55;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; color: #2d3748; padding-bottom: 50px; }

        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white; padding: 1rem 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; }
        .nav-link { color: white; text-decoration: none; font-size: 0.9rem; }

        .container { max-width: 1000px; margin: 40px auto; padding: 0 20px; }

        .detail-card {
            background: white; border-radius: 20px; overflow: hidden;
            display: grid; grid-template-columns: 1fr 1fr;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }
        @media (max-width: 768px) { .detail-card { grid-template-columns: 1fr; } }

        .image-side { background: #f8fafc; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .image-side img { width: 100%; max-height: 500px; object-fit: contain; border-radius: 12px; }
        .no-image { font-size: 5rem; color: #cbd5e0; }

        .content-side { padding: 40px; display: flex; flex-direction: column; }
        .badge-row { display: flex; gap: 10px; margin-bottom: 15px; }
        .badge { padding: 4px 12px; border-radius: 20px; color: white; font-size: 0.75rem; font-weight: bold; }

        h2 { font-size: 2.2rem; margin-bottom: 15px; color: #1a202c; }
        .description { color: #4a5568; line-height: 1.6; margin-bottom: 25px; font-size: 1.05rem; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 30px; }
        .info-item { background: #f8fafc; padding: 12px; border-radius: 10px; border: 1px solid #edf2f7; }
        .info-item label { display: block; font-size: 0.7rem; font-weight: bold; color: #a0aec0; text-transform: uppercase; }
        .info-item span { font-weight: 600; color: #2d3748; }

        .action-box { border-radius: 15px; padding: 25px; text-align: center; margin-bottom: 15px; }
        .box-open { background: #ebf8ff; border: 2px dashed #90cdf4; }
        .box-claimed { background: #fffaf0; border: 2px dashed var(--warning); }

        .btn-main {
            display: inline-block; width: 100%; padding: 15px; border-radius: 10px;
            font-weight: bold; font-size: 1.1rem; cursor: pointer; border: none;
            transition: 0.3s; margin-top: 15px; text-decoration: none; color: white;
        }
        .btn-claim { background: var(--found); }
        .btn-return { background: var(--warning); }
        .btn-main:hover { opacity: 0.9; transform: translateY(-2px); }

        .alert { padding: 15px; border-radius: 10px; margin-top: 20px; font-weight: 600; text-align: center; }
        .alert-success { background: #f0fff4; color: #2f855a; border: 1px solid #c6f6d5; }
        .alert-error { background: #fff5f5; color: #c53030; border: 1px solid #feb2b2; }
        .btn-back { display: block; text-align: center; margin-top: 25px; color: var(--primary); font-weight: 600; text-decoration: none; }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>📦 Item Details</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home" class="nav-link">← Dashboard</a>
            </div>
        </div>
    </header>

    <div class="container">
        <%
            Item item = (Item) request.getAttribute("item");
            if (item != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
                Integer currentUserId = (Integer) session.getAttribute("userId");
                boolean isOwner = currentUserId != null && currentUserId == item.getUserId();
                String status = item.getStatus();
        %>
            <div class="detail-card">
                <div class="image-side">
                    <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" alt="Item Image">
                    <% } else { %>
                        <div class="no-image">📦</div>
                    <% } %>
                </div>

                <div class="content-side">
                    <%-- Success/Error Messages from Servlet --%>
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
                    <% } %>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <div class="badge-row">
                        <span class="badge" style="background: <%= "LOST".equals(item.getItemType()) ? "var(--lost)" : "var(--found)" %>">
                            <%= item.getItemType() %>
                        </span>
                        <span class="badge" style="background: #cbd5e0; color: #4a5568;">Status: <%= status %></span>
                    </div>

                    <h2><%= item.getItemName() %></h2>
                    <p class="description"><%= item.getDescription() != null ? item.getDescription() : "No description provided." %></p>

                    <div class="info-grid">
                        <div class="info-item"><label>Category</label><span><%= item.getCategory() %></span></div>
                        <div class="info-item"><label>Location</label><span>📍 <%= item.getLocation() %></span></div>
                        <div class="info-item"><label>Posted On</label><span><%= item.getPostedDate().format(formatter) %></span></div>
                        <div class="info-item"><label>Contact</label><span><%= item.getContactInfo() %></span></div>
                    </div>

                    <%-- Dynamic Action Box based on Status --%>
                    <% if ("OPEN".equals(status)) { %>
                        <div class="action-box box-open">
                            <% if (isOwner) { %>
                                <h3 style="color: var(--primary);">Your Listing</h3>
                                <p>Waiting for someone to find or claim this item.</p>
                            <% } else { %>
                                <h3 style="color: var(--primary);">Found this?</h3>
                                <form method="POST" action="<%= request.getContextPath() %>/claim">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <button type="submit" class="btn-main btn-claim">I Have This Item!</button>
                                </form>
                            <% } %>
                        </div>
                    <% } else if ("CLAIMED".equals(status)) { %>
                        <div class="action-box box-claimed">
                            <% if (isOwner) { %>
                                <h3 style="color: #c05621;">Claimed!</h3>
                                <p>Someone has reached out. Did you get your item back?</p>
                                <form method="POST" action="<%= request.getContextPath() %>/mark-returned">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <button type="submit" class="btn-main btn-return">Yes, Mark as Returned</button>
                                </form>
                            <% } else { %>
                                <h3 style="color: #c05621;">Currently Claimed</h3>
                                <p>Another student has already reported finding this item.</p>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="alert alert-success">
                            ✨ This item has been successfully <%= status.toLowerCase() %>.
                        </div>
                    <% } %>

                    <a href="<%= request.getContextPath() %>/home?action=all-items" class="btn-back">← Back to Browse</a>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-error">Item not found.</div>
        <% } %>
    </div>
</body>
</html>