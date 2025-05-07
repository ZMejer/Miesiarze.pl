<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "miesiarze_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Błąd połączenia z bazą danych']));
}

header('Content-Type: application/json');

$sql = "SELECT id, description, picture FROM pictures ORDER BY id DESC";
$result = $conn->query($sql);

$pictures = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $pictures[] = [
            'id' => $row['id'],
            'description' => $row['description'],
            'image_base64' => base64_encode($row['picture']),
        ];
    }
    echo json_encode(['status' => 'success', 'pictures' => $pictures]);
} else {
    echo json_encode(['status' => 'success', 'pictures' => []]);
}

$conn->close();
?>
