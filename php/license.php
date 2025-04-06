<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

if (isset($_GET['firstName']) && isset($_GET['lastName']) && isset($_GET['cardNumber'])) {
    $firstName = $_GET['firstName'];
    $lastName = $_GET['lastName'];
    $cardNumber = $_GET['cardNumber'];
} else {
    echo "Brak danych użytkownika!";
    exit();
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Użytkownika</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: "Raleway", sans-serif;
            font-optical-sizing: auto;
            font-style: normal;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            display: flex;
            height: 100vh;
            color: #333;
        }

        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            height: 20%;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: start;
            margin-bottom: 20px;
        }

        .header h1 {
            font-size: 20px;
            color: #1462a2;
            margin-left: 10px;
        }

        .header img {
            width: 50px;
            height: auto;
        }

        .info {
            margin-bottom: 15px;
            font-size: 18px;
        }

        .info span {
            font-weight: bold;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }

        .card-number {
            font-size: 16px;
            color: #2196F3;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <img src="assets/pzw-logo.png" alt="PZW Logo">
        <h1>Karta wędkarska nr <?php echo htmlspecialchars($cardNumber); ?></h1>
    </div>
    <div class="info">
        <p><span>Imię:</span> <?php echo htmlspecialchars($firstName); ?></p>
        <p><span>Nazwisko:</span> <?php echo htmlspecialchars($lastName); ?></p>
    </div>
</div>

</body>
</html>
