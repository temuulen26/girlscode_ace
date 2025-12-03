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

  // Login функц
  void loginUser() async {
    String username = loginUsernameController.text.trim();
    String password = loginPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username болон нууц үгээ оруулна уу")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var result = await ApiService.loginUser(username, password);
      if (result['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Алдаа гарлаа: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Register функц
  void registerUser() async {
    String username = regUsernameController.text.trim();
    String email = regEmailController.text.trim();
    String password = regPasswordController.text.trim();
    String confirmPassword = regConfirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Бүх талбарыг бөглөнө үү")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Нууц үг хоорондоо таарахгүй байна")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var result = await ApiService.registerUser(username, email, password);
      if (result['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Алдаа гарлаа: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

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
              children: [_loginTab(), _registerTab()],
            ),
          ),
        ],
      ),
    );
  }
}
