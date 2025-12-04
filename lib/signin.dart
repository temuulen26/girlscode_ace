import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers
  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController regUsernameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController regConfirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    regUsernameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regConfirmPasswordController.dispose();
    super.dispose();
  }

  // --------------------------
  // LOGIN FUNCTION (optimized)
  // --------------------------
  Future<void> loginUser() async {
    final username = loginUsernameController.text.trim();
    final password = loginPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnack("Username болон нууц үгээ оруулна уу");
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.loginUser(username, password);

      if (result["status"] == "success") {
        // Navigation must run AFTER frame build
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        });
      } else {
        _showSnack(result["message"] ?? "Алдаа гарлаа");
      }
    } catch (e) {
      _showSnack("Алдаа гарлаа: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --------------------------
  // REGISTER FUNCTION
  // --------------------------
  Future<void> registerUser() async {
    final username = regUsernameController.text.trim();
    final email = regEmailController.text.trim();
    final password = regPasswordController.text.trim();
    final confirmPassword = regConfirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack("Бүх талбарыг бөглөнө үү");
      return;
    }

    if (password != confirmPassword) {
      _showSnack("Нууц үг хоорондоо таарахгүй байна");
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.registerUser(username, email, password);

      if (result["status"] == "success") {
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        });
      } else {
        _showSnack(result["message"] ?? "Алдаа гарлаа");
      }
    } catch (e) {
      _showSnack("Алдаа гарлаа: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --------------------------
  // Snackbar function (safe)
  // --------------------------
  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  // --------------------------
  // LOGIN TAB UI
  // --------------------------
  Widget _loginTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: loginUsernameController,
            decoration: InputDecoration(
              hintText: "Username",
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: loginPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Нууц үг",
              prefixIcon: const Icon(Icons.lock),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: isLoading ? null : loginUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA58BFF),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Нэвтрэх", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // --------------------------
  // REGISTER TAB UI
  // --------------------------
  Widget _registerTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: regUsernameController,
              decoration: InputDecoration(
                hintText: "Username",
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: regEmailController,
              decoration: InputDecoration(
                hintText: "Email/Утасны дугаар",
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: regPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Нууц үг",
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: regConfirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Давтан нууц үг",
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: isLoading ? null : registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA58BFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Бүртгүүлэх", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            "ACE App",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Нэвтрэх"),
              Tab(text: "Бүртгүүлэх"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _loginTab(),
                _registerTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
