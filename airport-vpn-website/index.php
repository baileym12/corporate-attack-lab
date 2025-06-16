<?php
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = new SQLite3('creds.db');
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    $result = $db->querySingle("SELECT password FROM users WHERE username = '$username'", true);
    
    if ($result && $password === $result['password']) {
        $_SESSION['authenticated'] = true;
        header('Location: dashboard.php');
        exit();
    } else {
        $error = "Invalid credentials!";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Airport VPN Portal</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="login-container">
        <h1>Airport VPN Login</h1>
        <?php if (isset($error)) echo "<p class='alert'>$error</p>"; ?>
        <form method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
