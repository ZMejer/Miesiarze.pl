import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  File? _imageFile;
  final picker = ImagePicker();


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
            height: 510, // Określona wysokość dla TabBar i TabBarView razem
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
                      Padding(
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
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dodaj zdjęcie',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: (){
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
                                decoration: InputDecoration(
                                labelText: 'Opis zdjęcia',
                                border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                ),
                                const SizedBox(height: 16),

                            ElevatedButton(
                              onPressed: () {
                                // TODO: logika wysyłania zdjęcia i opisu
                              },
                              child: Text('Wyślij'),
                            ),
                          ],
                        ),
                      ),
                      _selectedImage != null ? Image.file(_selectedImage!) : const Text("XD")
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
