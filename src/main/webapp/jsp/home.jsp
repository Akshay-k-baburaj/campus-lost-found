<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Campus Lost & Found</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            color: #333;
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
        .navbar h1 {
            font-size: 1.8em;
        }
        .nav-links {
            display: flex;
            gap: 20px;
            align-items: center;
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
        .logout-btn {
            background: #333;
        }
        .logout-btn:hover {
            background: #555;
        }
        .btn-success {
            background: #2ed573;
        }
        .btn-success:hover {
            background: #26de81;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .welcome {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .welcome h2 {
            color: #667eea;
            margin-bottom: 10px;
        }
        .welcome p {
            color: #666;
            font-size: 1.1em;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .stat-card h3 {
            color: #667eea;
            font-size: 2em;
            margin-bottom: 10px;
        }
        .stat-card p {
            color: #666;
        }
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: block;
            text-align: center;
            font-weight: bold;
            transition: transform 0.2s;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-primary:hover {
            background: #764ba2;
        }
        .btn-success {
            background: #2ed573;
            color: white;
        }
        .btn-success:hover {
            background: #26de81;
        }
        .action-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .action-section h2 {
            color: #667eea;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>📦 Campus Lost & Found</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home?action=my-items">My Items</a>
                <a href="<%= request.getContextPath() %>/home?action=all-items">Browse Items</a>
                <a href="<%= request.getContextPath() %>/item?action=new" class="btn-success">+ Post Item</a>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="welcome">
            <h2>Welcome, <%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "User" %>! 👋</h2>
            <p>Manage your lost and found items easily.</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <h3><%= request.getAttribute("userItemsCount") != null ? request.getAttribute("userItemsCount") : 0 %></h3>
                <p>Your Items Posted</p>
            </div>
            <div class="stat-card">
                <h3><%= request.getAttribute("totalOpenItems") != null ? request.getAttribute("totalOpenItems") : 0 %></h3>
                <p>Total Open Items</p>
            </div>
        </div>

        <div class="action-section">
            <h2>Quick Actions</h2>
            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/item?action=new" class="btn btn-success">📝 Post Lost Item</a>
                <a href="<%= request.getContextPath() %>/item?action=new" class="btn btn-success">✅ Post Found Item</a>
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="btn btn-primary">🔍 Browse All Items</a>
                <a href="<%= request.getContextPath() %>/home?action=my-items" class="btn btn-primary">📋 View My Items</a>
            </div>
        </div>
    </div>
</body>
</html>