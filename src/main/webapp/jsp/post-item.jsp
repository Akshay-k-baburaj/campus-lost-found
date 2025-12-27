<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Item - Campus Lost & Found</title>
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: #f4f7f6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Reusing the modern header style */
        header {
            background: var(--bg-gradient);
            color: white;
            padding: 1rem 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; width: 100%; }
        .nav-link { color: white; text-decoration: none; font-weight: 500; font-size: 0.9rem; opacity: 0.9; }
        .nav-link:hover { opacity: 1; }

        .container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .form-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            max-width: 650px;
            width: 100%;
        }

        h1 {
            color: #2d3748;
            margin-bottom: 30px;
            font-size: 1.8rem;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .form-group { margin-bottom: 22px; }

        label {
            display: block;
            margin-bottom: 8px;
            color: #4a5568;
            font-weight: 600;
            font-size: 0.95rem;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            font-family: inherit;
            background: #f8fafc;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        input[type="file"] {
            padding: 8px;
            background: white;
            border: 2px dashed #cbd5e0;
        }

        textarea { resize: vertical; min-height: 110px; }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--bg-gradient);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(102, 126, 234, 0.3);
        }

        .error-msg {
            background: #fff5f5;
            color: #c53030;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c53030;
            font-size: 0.9rem;
        }

        .help-text { font-size: 0.8rem; color: #718096; margin-top: 6px; }

        .back-link { text-align: center; margin-top: 25px; }
        .back-link a { color: var(--primary); text-decoration: none; font-weight: 600; font-size: 0.95rem; }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h2 style="font-size: 1.2rem;">📦 Post New Listing</h2>
            <a href="<%= request.getContextPath() %>/home" class="nav-link">Cancel & Return</a>
        </div>
    </header>

    <div class="container">
        <div class="form-card">
            <h1>📝 Report an Item</h1>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-msg"><%= request.getAttribute("error") %></div>
            <% } %>

            <form method="POST" action="<%= request.getContextPath() %>/item" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="itemType">Type of Report</label>
                    <select id="itemType" name="itemType" required>
                        <option value="" disabled selected>-- Are you looking or reporting? --</option>
                        <option value="LOST">I Lost Something</option>
                        <option value="FOUND">I Found Something</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="itemName">Item Name</label>
                    <input type="text" id="itemName" name="itemName" placeholder="e.g., iPhone 13, Blue Water Bottle" required>
                </div>

                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category" required>
                        <option value="" disabled selected>-- Select Category --</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Documents">Documents</option>
                        <option value="Keys">Keys</option>
                        <option value="Clothing">Clothing</option>
                        <option value="Accessories">Accessories</option>
                        <option value="Books">Books</option>
                        <option value="Sports Equipment">Sports Equipment</option>
                        <option value="Others">Others</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="itemImage">Upload Photo</label>
                    <input type="file" id="itemImage" name="itemImage" accept="image/*">
                    <div class="help-text">Adding a photo helps identify the item faster. (Max 10MB)</div>
                </div>

                <div class="form-group">
                    <label for="description">Detailed Description</label>
                    <textarea id="description" name="description" placeholder="Include distinguishing features like color, brand, or stickers..."></textarea>
                </div>

                <div class="form-group">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location" placeholder="e.g., Main Library 2nd Floor" required>
                </div>

                <div class="form-group">
                    <label for="contactInfo">Contact Number</label>
                    <input type="tel" id="contactInfo" name="contactInfo" pattern="[0-9]{10}" placeholder="e.g., 9876543210" required>
                </div>

                <button type="submit" class="btn-submit">Publish Listing</button>
            </form>

            <div class="back-link">
                <a href="<%= request.getContextPath() %>/home">← Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>