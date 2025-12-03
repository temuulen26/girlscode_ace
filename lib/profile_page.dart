import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_service.dart'; // API functions энд

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  // Жишээ: хэрэглэгчийн мэдээллийг авчрах функц
  Future<void> fetchUserData() async {
    try {
      final response = await ApiService.loginUser("testuser", "testpassword");
      if (response['status'] == 'success') {
        // JSON response-д хэрэглэгчийн мэдээллийг оруулна
        setState(() {
          userData = {
            'username': 'testuser', // response-аас авч болно
            'email': 'testuser@example.com', // response-аас авч болно
          };
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Хуудас load болох үед мэдээлэл авчирна
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            _menuItem(
              context: context,
              icon: Icons.person,
              title: "Миний мэдээлэл",
              onTap: () {
                // Мэдээлэл харах modal
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: userData == null
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Миний мэдээлэл",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text("Username: ${userData!['username']}"),
                                const SizedBox(height: 8),
                                Text("Email: ${userData!['email']}"),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Хаах"),
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                );
              },
            ),
            // Бусад menu item-ууд...
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFFA58BFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: const [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.purple),
          ),
          SizedBox(height: 16),
          Text(
            "Миний мэдээлэл",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
