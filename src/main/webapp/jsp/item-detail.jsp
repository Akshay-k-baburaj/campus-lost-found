<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.campus.lostnfound.models.Item" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Details - Campus Lost & Found</title>
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
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .item-detail {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .item-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
        }
        .item-header h2 {
            margin-bottom: 15px;
        }
        .badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .badge {
            display: inline-block;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .lost-badge {
            background: #ff4757;
            color: white;
        }
        .found-badge {
            background: #2ed573;
            color: white;
        }
        .status-badge {
            background: rgba(255, 255, 255, 0.3);
        }
        .item-body {
            padding: 30px;
        }
        .detail-section {
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 1px solid #eee;
        }
        .detail-section:last-child {
            border-bottom: none;
        }
        .detail-section h3 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        .detail-section p {
            color: #666;
            line-height: 1.6;
            font-size: 1em;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 10px;
        }
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }
        .info-item label {
            display: block;
            color: #667eea;
            font-weight: bold;
            margin-bottom: 5px;
            font-size: 0.9em;
        }
        .info-item span {
            color: #333;
            font-size: 1em;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: bold;
        }
        .btn:hover {
            background: #764ba2;
        }
        .contact-section {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .contact-section h3 {
            color: #1976d2;
            margin-bottom: 10px;
        }
        .claim-button {
            padding: 15px 40px;
            background: #2ed573;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.2em;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(46, 213, 115, 0.3);
            width: 100%;
            max-width: 400px;
        }
        .claim-button:hover {
            background: #26de81;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(46, 213, 115, 0.4);
        }
        .return-button {
            padding: 15px 40px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(102, 126, 234, 0.3);
            width: 100%;
            max-width: 400px;
        }
        .return-button:hover {
            background: #764ba2;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(102, 126, 234, 0.4);
        }
        .action-section {
            margin-top: 20px;
            text-align: center;
        }
        .action-info {
            color: #666;
            margin-top: 10px;
            font-size: 0.9em;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            border: 1px solid #f5c6cb;
        }
        .alert-warning {
            background: #fff3cd;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .alert-warning p {
            color: #856404;
            font-weight: bold;
        }
        .alert-info {
            background: #d1ecf1;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .alert-info h3 {
            color: #0c5460;
            margin-bottom: 10px;
        }
        .alert-info p {
            color: #0c5460;
        }
        .alert-returned {
            background: #d4edda;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .alert-returned h3 {
            color: #155724;
            margin-bottom: 10px;
        }
        .alert-returned p {
            color: #155724;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>📦 Item Details</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%= request.getContextPath() %>/home?action=all-items">Browse Items</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <%
            Item item = (Item) request.getAttribute("item");
            if (item != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy 'at' HH:mm");

                // Get current user info
                HttpSession userSession = request.getSession(false);
                Integer currentUserId = userSession != null ? (Integer) userSession.getAttribute("userId") : null;
                boolean isOwner = currentUserId != null && currentUserId == item.getUserId();
        %>
            <div class="item-detail">
                <div class="item-header">
                    <h2><%= item.getItemName() %></h2>
                    <div class="badges">
                        <span class="badge <%= "LOST".equals(item.getItemType()) ? "lost-badge" : "found-badge" %>">
                            <%= item.getItemType() %>
                        </span>
                        <span class="badge status-badge">
                            Status: <%= item.getStatus() %>
                        </span>
                    </div>
                </div>

                <div class="item-body">
                    <div class="detail-section">
                        <h3>Description</h3>
                        <p><%= item.getDescription() != null && !item.getDescription().isEmpty() ? item.getDescription() : "No description provided" %></p>
                    </div>

                    <div class="detail-section">
                        <h3>Item Information</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <label>Category</label>
                                <span><%= item.getCategory() %></span>
                            </div>
                            <div class="info-item">
                                <label>Location</label>
                                <span>📍 <%= item.getLocation() %></span>
                            </div>
                            <div class="info-item">
                                <label>Status</label>
                                <span><%= item.getStatus() %></span>
                            </div>
                            <div class="info-item">
                                <label>Posted On</label>
                                <span><%= item.getPostedDate() != null ? item.getPostedDate().format(formatter) : "N/A" %></span>
                            </div>
                        </div>
                    </div>

                    <!-- STATUS: OPEN -->
                    <% if ("OPEN".equals(item.getStatus())) { %>
                        <div class="contact-section">
                            <h3>📞 Contact Information</h3>
                            <p>If this is your item or you have information about it:</p>
                            <p style="font-size: 1.2em; font-weight: bold; margin-top: 10px; color: #1976d2;">
                                <%= item.getContactInfo() %>
                            </p>
                        </div>

                        <% if (currentUserId != null && !isOwner) { %>
                            <!-- CLAIM BUTTON for other users -->
                            <div class="action-section">
                                <form method="POST" action="<%= request.getContextPath() %>/claim"
                                      onsubmit="return confirm('Claim this item? The owner will be notified via email with your contact information.');">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <button type="submit" class="claim-button">
                                        ✅ I Found This Item!
                                    </button>
                                </form>
                                <p class="action-info">
                                    Owner will receive an email notification with your contact info
                                </p>
                            </div>
                        <% } %>

                        <% if (isOwner) { %>
                            <!-- MESSAGE for owner -->
                            <div class="alert-warning">
                                <p>📌 This is your item. Waiting for someone to claim it...</p>
                                <p style="margin-top: 10px; font-weight: normal;">You'll receive an email when someone claims this item.</p>
                            </div>
                        <% } %>

                    <!-- STATUS: CLAIMED -->
                    <% } else if ("CLAIMED".equals(item.getStatus())) { %>
                        <div class="alert-info">
                            <h3>⏳ Item Claimed</h3>
                            <p>This item has been claimed. The owner and claimer are coordinating the return.</p>
                        </div>

                        <% if (isOwner) { %>
                            <!-- MARK AS RETURNED button for owner -->
                            <div class="action-section">
                                <p style="margin-bottom: 15px; color: #667eea; font-weight: bold;">
                                    Did you receive your item back?
                                </p>
                                <form method="POST" action="<%= request.getContextPath() %>/mark-returned"
                                      onsubmit="return confirm('Confirm that you received your item? This will close the listing.');">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <button type="submit" class="return-button">
                                        🎉 I Got My Item Back!
                                    </button>
                                </form>
                                <p class="action-info">
                                    Click this once you've successfully received your item
                                </p>
                            </div>
                        <% } else { %>
                            <div class="alert-warning">
                                <p>This item is being returned to its owner.</p>
                            </div>
                        <% } %>

                    <!-- STATUS: RETURNED -->
                    <% } else if ("RETURNED".equals(item.getStatus())) { %>
                        <div class="alert-returned">
                            <h3>✅ Item Successfully Returned</h3>
                            <p>This item has been successfully returned to its owner! 🎉</p>
                            <p style="margin-top: 10px; font-weight: normal;">
                                Thank you for using Campus Lost & Found!
                            </p>
                        </div>
                    <% } %>

                    <!-- SUCCESS/ERROR MESSAGES -->
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert-success">
                            <%= request.getAttribute("success") %>
                        </div>
                    <% } %>

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert-error">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                </div>
            </div>
        <%
            }
        %>

        <div class="back-link">
            <a href="<%= request.getContextPath() %>/home?action=all-items" class="btn">← Back to Items</a>
        </div>
    </div>
</body>
</html>