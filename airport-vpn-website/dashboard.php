<?php
session_start();
if (!isset($_SESSION['authenticated'])) {
    die('<div class="login-container"><p class="alert">Access denied!</p></div>');
}

if (isset($_FILES['shell'])) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES['shell']['name']);
    move_uploaded_file($_FILES['shell']['tmp_name'], $target_file);
    $message = "File uploaded to: <a href='$target_file' style='color:#4CAF50'>$target_file</a>";
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>VPN Admin Panel</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="upload-container">
        <h1>VPN Configuration Panel</h1>
        <?php if (isset($message)) echo "<p>$message</p>"; ?>
        
        <div class="upload-area">
            <form method="POST" enctype="multipart/form-data">
                <p>Upload VPN configuration file:</p>
                <input type="file" name="shell" style="border:none;background:none;color:white">
                <button type="submit">Upload</button>
            </form>
        </div>
        
        <!-- Hidden hint for CTF -->
        <p style="font-size:0.8em;color:#aaa;text-align:center">
            Accepted formats: .conf, .ovpn, .php
        </p>
    </div>
</body>
</html>
