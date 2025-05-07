<?php
$servername = "localhost";  // Zmienna do połączenia z bazą danych
$username = "root";         // Nazwa użytkownika bazy danych
$password = "";             // Hasło bazy danych (jeśli puste, pozostaw)
$dbname = "miesiarze_db";          // Nazwa bazy danych

// Połączenie z bazą danych
$conn = new mysqli($servername, $username, $password, $dbname);

// Sprawdzenie połączenia
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

header('Content-Type: application/json');

// Sprawdzamy, czy przyszło zdjęcie i opis
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['image']) && isset($_POST['description'])) {
    $file = $_FILES['image'];

    // Sprawdzamy, czy plik jest obrazkiem
    $check = getimagesize($file['tmp_name']);
        if ($check !== false) {
        // Odczytujemy plik jako dane binarne
        $imageData = file_get_contents($file['tmp_name']);
        $imageData = mysqli_real_escape_string($conn, $imageData); // Zabezpieczamy dane przed SQL Injection

        // Pobieramy opis
        $description = mysqli_real_escape_string($conn, $_POST['description']);

        // Wstawiamy do tabeli pictures
        $sql = "INSERT INTO pictures (picture, description) VALUES ('$imageData', '$description')";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(['status' => 'success', 'message' => 'Zdjęcie zostało zapisane w bazie danych']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Błąd bazy danych: ' . $conn->error]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Dozwolone są tylko pliki graficzne (JPEG, PNG, GIF).']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Brak zdjęcia lub opisu w żądaniu.']);
}

$conn->close();
?>
