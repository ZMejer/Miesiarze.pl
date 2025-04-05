<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

if (isset($_GET['firstName']) && isset($_GET['lastName'])) {
    $firstName = $_GET['firstName'];
    $lastName = $_GET['lastName'];
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
</head>
<body>
    <p>Imię: <?php echo htmlspecialchars($firstName); ?></p>
    <p>Nazwisko: <?php echo htmlspecialchars($lastName); ?></p>
</body>
</html>
