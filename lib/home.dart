import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'mbtitest.dart';
import 'news_detail.dart'; // MBTI тестийг импортлов

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  int _currentIndex = 0;

  final List<Map<String, String>> news = [
    {
      "title": "Мэргэжлийн чиг баримжаа",
      "desc":
          "Өнөөдөр олон залуус ирээдүйн ажил мэргэжлээ сонгохдоо эргэлзээтэй байдаг. "
          "AI, технологи, бизнес, урлаг зэрэг салбаруудын мэдээллийг судалж, "
          "өөрийн сонирхол, чадвартай нийцүүлэн сонголт хийх нь хамгийн үр дүнтэй арга юм. "
          "Тестүүдээр өөрийн сонирхол, зан төлөвийг тодорхойлж, зөв чиглэлд мэргэшиж болно.",
      "image": "assets/career_news.jpg",
    },
    {
      "title": "Мэдээ 2",
      "desc": "Энэ бол мэдээний дэлгэрэнгүй агуулга 2...",
      "image": "assets/news2.png",
    },
    {
      "title": "Мэдээ 3",
      "desc": "Энэ бол мэдээний дэлгэрэнгүй агуулга 3...",
      "image": "assets/news2.png",
    },
  ];

  final List<Map<String, String>> tests = [
    {
      "title": "MBTI Тест",
      "desc": "Таны зан төлөвийг тодорхойлно.",
      "image": "assets/mbti_test.png",
    },
  ];

  final List<Widget> _pages = const [
    SizedBox.shrink(), // Home page handled separately
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'ACEChat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    if (_currentIndex == 0) {
      return _homePage();
    } else {
      return _pages[_currentIndex];
    }
  }

  Widget _homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(),
          const SizedBox(height: 15),
          _section("Мэдээ", news, isTest: false),
          const SizedBox(height: 20),
          _section("Тест", tests, isTest: true),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFFA58BFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(radius: 28, backgroundColor: Colors.white),
              SizedBox(width: 12),
              Text(
                "ACE-д тавтай морил!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: "Search...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    List<Map<String, String>> items, {
    bool isTest = false,
  }) {
    final filtered = items
        .where(
          (e) =>
              (e["title"]?.toLowerCase() ?? "").contains(searchText) ||
              (e["desc"]?.toLowerCase() ?? "").contains(searchText),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(height: 1, color: Colors.black12),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final item = filtered[i];
              return GestureDetector(
                onTap: () {
                  if (isTest) {
                    // MBTI тест рүү л шилжүүлнэ
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MbtiTestPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(
                          title: item["title"] ?? "",
                          desc: item["desc"] ?? "",
                          image: item["image"] ?? "",
                        ),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isTest
                            ? Colors.purple[50]
                            : const Color(0xFFF0E7FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black26),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item["image"] != null &&
                              item["image"]!.isNotEmpty)
                            Hero(
                              tag: item["image"]! + i.toString(),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(item["image"]!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.article_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            item["title"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isTest)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Шинэ тест",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
