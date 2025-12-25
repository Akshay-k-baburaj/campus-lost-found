<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Campus Lost & Found</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            color: #333;
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
            max-width: 1200px;
            margin: 0 auto;
        }
        .navbar h1 {
            font-size: 1.8em;
        }
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
        .logout-btn {
            background: #333;
        }
        .logout-btn:hover {
            background: #555;
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
            color: #ff6b6b;
            margin-bottom: 10px;
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
            color: #ff6b6b;
            font-size: 2em;
            margin-bottom: 10px;
        }
        .stat-card p {
            color: #666;
        }
        .admin-actions {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .admin-actions h2 {
            color: #ff6b6b;
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            background: #ff6b6b;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        .btn:hover {
            background: #ee5a6f;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1>⚙️ Admin Dashboard</h1>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/admin/manage-items">Manage Items</a>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="welcome">
            <h2>Admin Control Panel</h2>
            <p>Manage and monitor all lost & found items on campus</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <h3><%= request.getAttribute("totalItems") %></h3>
                <p>Total Items</p>
            </div>
        </div>

        <div class="admin-actions">
            <h2>Quick Actions</h2>
            <a href="<%= request.getContextPath() %>/admin/manage-items" class="btn">Manage All Items</a>
            <a href="<%= request.getContextPath() %>/item?action=list" class="btn">View Public Listings</a>
        </div>
    </div>
</body>
</html>