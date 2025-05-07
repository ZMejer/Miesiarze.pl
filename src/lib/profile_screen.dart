import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  File? _imageFile;
  final picker = ImagePicker();
  final _descriptionController = TextEditingController();
  bool _showFishForm = false; // Stan kontrolujący widoczność formularza

  Future<void> _pickImage() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : await Permission.photos.request();

    if (storageStatus == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else if (storageStatus == PermissionStatus.denied) {
      print("denied");
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPictures() async {
    final uri = Uri.parse('http://10.0.2.2:90/get_pictures.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['pictures']);
      }
    }
    return [];
  }

  Future<void> _uploadImage(String description) async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Najpierw wybierz zdjęcie')),
      );
      return;
    }

    final uri = Uri.parse('http://10.0.2.2:90/upload_picture.php');
    final request = http.MultipartRequest('POST', uri);

    // Dodaj pole tekstowe z opisem
    request.fields['description'] = description;

    // Dodaj plik
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Nazwa pola po stronie PHP (np. $_FILES['image'])
        _imageFile!.path,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zdjęcie przesłane pomyślnie')),
        );
        setState(() {
          _imageFile = null; // Czyścimy po przesłaniu
          _showFishForm = false; // Ukrywamy formularz po wysłaniu
        });
      } else {
        print('Błąd przesyłania: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Błąd przesyłania zdjęcia')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wystąpił błąd podczas przesłania')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  File ? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Zaloguj się, aby wyświetlić profil.')),
      );
    }

    const Color avatarBorderColor = Color(0xFFF7F2FA);
    const Color profileBackgroundColor = Color(0xFF1A263E);
    const Color themeColor = Color(0xFF1A263E);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Główna sekcja z informacjami o użytkowniku
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      color: profileBackgroundColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  height: 140,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${user['name']} ${user['surname']}',
                            style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarBorderColor,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        'https://www.w3schools.com/w3images/avatar2.png',
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Określamy wysokość dla TabBar + TabBarView razem
          Container(
            height: 550, // Określona wysokość dla TabBar i TabBarView razem
            child: Column(
              children: [
                // TabBar
                Container(
                  height: 50, // Wysokość TabBar
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          // Use the default focused overlay color
                          return states.contains(MaterialState.focused) ? null : Colors.transparent;
                        }
                    ),
                    dividerColor: Colors.transparent,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Dane osobowe'),
                      Tab(text: 'Galeria ryb'),
                    ],
                    indicatorColor: themeColor,
                    labelColor: themeColor,
                    unselectedLabelStyle: TextStyle(
                      color: themeColor.withOpacity(0.6),
                    ),
                  ),
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Pierwsza zakładka - dane osobowe
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Imię: ${user['name']}'),
                            Text('Nazwisko: ${user['surname']}'),
                            Text('Email: ${user['email']}'),
                            Text('Płeć: ${user['gender'] == 0 ? 'Kobieta' : 'Mężczyzna'}'),
                            Text('Data urodzenia: ${user['birthdate']}'),
                            Text('Telefon: ${user['phone_number']}'),
                            Text('Numer karty: ${user['card_number']}'),
                            Text('Student: ${user['is_student'] == 1 ? 'Tak' : 'Nie'}'),
                          ],
                        ),
                      ),

                      // Druga zakładka - galeria ryb
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Przycisk "Dodaj rybę"
                            if (!_showFishForm) ...[
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showFishForm = true; // Zmieniamy stan na widoczny formularz
                                  });
                                },
                                child: Text('Dodaj rybę'),
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: _fetchPictures(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Text('Wystąpił błąd podczas ładowania zdjęć');
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text('Brak zdjęć w galerii');
                                  } else {
                                    final pictures = snapshot.data!;
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 1.0,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      itemCount: pictures.length,
                                      itemBuilder: (context, index) {
                                        final pic = pictures[index];
                                        final imageBytes = base64Decode(pic['image_base64']);
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                  appBar: AppBar(title: const Text('Podgląd zdjęcia')),
                                                  body: SingleChildScrollView(  // Umożliwienie przewijania
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Image.memory(imageBytes),
                                                          const SizedBox(height: 16),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                            child: Text(
                                                              pic['description'],
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.memory(
                                                    imageBytes,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                pic['description'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              )

                            ],

                            // Formularz dodawania zdjęcia
                            if (_showFishForm) ...[
                              Text(
                                'Dodaj zdjęcie',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _pickImage();
                                },
                                icon: Icon(Icons.upload_file),
                                label: Text('Wgraj zdjęcie'),
                              ),
                              const SizedBox(height: 16),
                              if (_imageFile != null)
                                Column(
                                  children: [
                                    Image.file(
                                      _imageFile!,
                                      height: 200,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              TextField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Opis zdjęcia',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  final description = _descriptionController.text.trim();
                                  _uploadImage(description);
                                },
                                child: Text('Wyślij'),
                              ),
                              const SizedBox(height: 16),
                              // Przycisk "Anuluj"
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showFishForm = false; // Ukrywamy formularz po anulowaniu
                                  });
                                },
                                child: Text('Anuluj'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
