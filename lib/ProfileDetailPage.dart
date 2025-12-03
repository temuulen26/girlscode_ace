import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_service.dart';

class ProfileDetailPage extends StatefulWidget {
  final String username;

  const ProfileDetailPage({super.key, required this.username});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await ApiService.getProfile(widget.username);
      print("ProfileDetail Response: $response");

      if (response['status'] == 'success') {
        setState(() {
          userData = response['profile'];
          isLoading = false;
        });
      } else {
        print("Profile API error: ${response['message']}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Fetch Profile Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFA58BFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Миний мэдээлэл",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _infoRow("Username", userData?['username'] ?? "N/A"),
                  const SizedBox(height: 12),
                  _infoRow("Email", userData?['email'] ?? "N/A"),
                  const SizedBox(height: 12),
                  _infoRow("Phone", userData?['phone'] ?? "N/A"),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Гарах"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
