<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --primary-dark: #5a67d8;
            --secondary: #764ba2;
            --accent-lost: #ed8936;
            --accent-found: #48bb78;
            --bg-color: #f0f2f5;
            --card-bg: #ffffff;
            --text-main: #2d3748;
            --text-light: #718096;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
        }

        /* Modern Header */
        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 1rem 2rem;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.15);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-text {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .nav-link {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.15);
            color: white;
            transform: translateY(-1px);
        }

        .btn-logout {
            background: rgba(0,0,0,0.2);
            border: 1px solid rgba(255,255,255,0.1);
        }

        .btn-logout:hover {
            background: rgba(0,0,0,0.4);
        }

        /* Main Layout */
        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Welcome Section */
        .welcome-banner {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            margin-bottom: 30px;
            border-left: 5px solid var(--primary);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .welcome-text h2 {
            color: var(--text-main);
            font-size: 1.8rem;
            margin-bottom: 5px;
        }

        .welcome-text p {
            color: var(--text-light);
            font-size: 1.05rem;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--text-light);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Quick Actions Grid - The Major UI Upgrade */
        .section-title {
            font-size: 1.4rem;
            color: var(--text-main);
            margin-bottom: 20px;
            font-weight: 700;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
        }

        .action-card {
            background: white;
            border-radius: 16px;
            padding: 30px 20px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(0,0,0,0.03);
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }

        .action-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.08);
            border-color: rgba(102, 126, 234, 0.2);
        }

        .action-icon {
            font-size: 2.5rem;
            margin-bottom: 5px;
        }

        .action-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-main);
        }

        .action-desc {
            font-size: 0.9rem;
            color: var(--text-light);
            line-height: 1.4;
        }

        /* Specific Card Styles */
        .card-lost:hover .action-title { color: var(--accent-lost); }
        .card-found:hover .action-title { color: var(--accent-found); }
        .card-browse:hover .action-title { color: var(--primary); }
        .card-mine:hover .action-title { color: var(--secondary); }

    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <div class="logo-text">
                <span>📦</span> Campus Lost & Found
            </div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home?action=all-items" class="nav-link">Browse</a>
                <a href="<%= request.getContextPath() %>/home?action=my-items" class="nav-link">My Items</a>
                <a href="<%= request.getContextPath() %>/logout" class="nav-link btn-logout">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="welcome-banner">
            <div class="welcome-text">
                <h2>Hello, <%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "Student" %>! 👋</h2>
                <p>What would you like to do today?</p>
            </div>
            </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= request.getAttribute("userItemsCount") != null ? request.getAttribute("userItemsCount") : 0 %></div>
                <div class="stat-label">Your Active Posts</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= request.getAttribute("totalOpenItems") != null ? request.getAttribute("totalOpenItems") : 0 %></div>
                <div class="stat-label">Total Lost Items</div>
            </div>
        </div>

        <h3 class="section-title">Quick Actions</h3>
        <div class="actions-grid">
            <a href="<%= request.getContextPath() %>/item?action=new" class="action-card card-lost">
                <div class="action-icon">📝</div>
                <div class="action-title">I Lost Something</div>
                <div class="action-desc">Post a detailed description to help others find your item.</div>
            </a>

            <a href="<%= request.getContextPath() %>/item?action=new" class="action-card card-found">
                <div class="action-icon">✅</div>
                <div class="action-title">I Found Something</div>
                <div class="action-desc">Report an item you found to help return it to its owner.</div>
            </a>

            <a href="<%= request.getContextPath() %>/home?action=all-items" class="action-card card-browse">
                <div class="action-icon">🔍</div>
                <div class="action-title">Browse All Items</div>
                <div class="action-desc">Search through the list of recently lost and found objects.</div>
            </a>

            <a href="<%= request.getContextPath() %>/home?action=my-items" class="action-card card-mine">
                <div class="action-icon">📋</div>
                <div class="action-title">Manage My Items</div>
                <div class="action-desc">View, update, or delete the items you have posted previously.</div>
            </a>
        </div>
    </div>
</body>
</html>