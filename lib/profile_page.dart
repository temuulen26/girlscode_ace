import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_service.dart';
import 'chat_page.dart';
import 'ProfileDetailPage.dart'; // ProfileDetailPage импорт

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final loginResponse = await ApiService.loginUser(
        "testuser",
        "testpassword",
      );

      print("Login Response: $loginResponse");

      if (loginResponse['status'] == 'success') {
        String username = loginResponse['username'];

        final profileResponse = await ApiService.getProfile(username);
        print("Profile Response: $profileResponse");

        if (profileResponse['status'] == 'success') {
          setState(() {
            userData = profileResponse['profile'];
            isLoading = false;
          });
        } else {
          print("Profile API error: ${profileResponse['message']}");
          setState(() => isLoading = false);
        }
      } else {
        print("Login failed: ${loginResponse['message']}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Fetch User Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _header(),
                  const SizedBox(height: 20),
                  _menuItem(
                    context: context,
                    icon: Icons.person,
                    title: "Миний мэдээлэл",
                    onTap: () {
                      if (userData != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetailPage(
                              username: userData!['username'],
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Мэдээлэл хараахан ачаалагдаагүй байна",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.support_agent,
                    title: "ACE AI туслах",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      );
                    },
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.description,
                    title: "Үйлчилгээний нөхцөл",
                    onTap: _showTerms,
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.logout,
                    title: "Гарах",
                    onTap: _logoutDialog,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  void _showTerms() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Үйлчилгээний нөхцөл",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "ACE аппийг ашигласнаар та дараах нөхцлийг хүлээн зөвшөөрч байна:\n\n"
                "1. Үйлчилгээний зорилго: Карьер, зан төлөв, мэргэжлийн зөвлөмж.\n"
                "2. Хэрэглэгчийн үүрэг: Үнэн зөв мэдээлэл өгөх, нууц үгээ хадгалах.\n"
                "3. Мэдээллийн нууцлал: Хувийн мэдээллийг зөвхөн үйлчилгээний зориулалтаар ашиглах.\n"
                "4. Хариуцлага: AI зөвлөгөө зөвхөн зөвлөмж; үр дагаварт хэрэглэгч өөрөө хариуцна.\n"
                "5. Хууль эрх зүйн шаардлага: Монгол Улсын хуульд нийцүүлэх.\n"
                "6. Үйлчилгээний өөрчлөлт: Урьдчилан мэдэгдэхгүйгээр өөрчлөх боломжтой.\n\n"
                "Дэлгэрэнгүй нөхцлийг бүрэн уншиж, зөвшөөрснөөр аппийг ашиглах боломжтой.",
                style: TextStyle(fontSize: 16),
              ),
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
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Гарах"),
        content: const Text("Та гарахдаа итгэлтэй байна уу?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Буцах"),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Тийм", style: TextStyle(color: Colors.red)),
          ),
        ],
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
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
