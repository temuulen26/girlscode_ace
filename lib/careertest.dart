import 'package:flutter/material.dart';

class CareerTestPage extends StatefulWidget {
  const CareerTestPage({super.key});

  @override
  _CareerTestPageState createState() => _CareerTestPageState();
}

class Question {
  final String text;
  final String keyLetter;
  Question({required this.text, required this.keyLetter});
}

class _CareerTestPageState extends State<CareerTestPage> {
  final List<Question> questions = [
    Question(
      text: "Логик, математикийн асуудал шийдэх сонирхолтой.",
      keyLetter: "A",
    ),
    Question(
      text: "Хүмүүсийн зан төлөв, сэтгэл зүйн талаар ойлгох дуртай.",
      keyLetter: "B",
    ),
    Question(
      text: "Дизайн, зураг, бүтээлч зүйл хийх сонирхолтой.",
      keyLetter: "C",
    ),
    Question(text: "Техник, төхөөрөмжтэй оролдох дуртай.", keyLetter: "D"),
    Question(
      text: "Бизнес, зах зээлийн тухай бодох сонирхолтой.",
      keyLetter: "E",
    ),
  ];

  List<String?> selectedAnswers = [];
  Map<String, double> score = {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0};
  bool showResult = false;
  String bestCategory = "";

  final Map<String, String> titles = {
    "A": "Технологи / Аналитик",
    "B": "Хүмүүнлэг / Нийгэм",
    "C": "Урлаг / Дизайн",
    "D": "Инженерчлэл / Техник",
    "E": "Бизнес / Менежмент",
  };

  final Map<String, String> icons = {
    "A": "💻",
    "B": "🤝",
    "C": "🎨",
    "D": "⚙️",
    "E": "📊",
  };

  final Map<String, String> desc = {
    "A":
        "Та IT, программчлал, дата анализ, математик, технологийн салбарт илүү тохиромжтой.",
    "B":
        "Та хүмүүстэй харилцах, туслах, зөвлөгөө өгөх, нийгмийн шинжлэх ухааны чиглэлд тохирно.",
    "C": "Та дизайны мэдрэмж өндөр бөгөөд бүтээлч орчинд илүү үр бүтээлтэй.",
    "D":
        "Та техник, инженерчлэл, тоног төхөөрөмж, роботик зэрэг практик салбарт тохиромжтой.",
    "E":
        "Та бизнес, удирдлага, маркетинг, стратеги төлөвлөлтөд илүү сонирхолтой.",
  };

  final Map<String, List<String>> suggestions = {
    "A": [
      "Программист",
      "Data Analyst",
      "Software Engineer",
      "AI/ML Engineer",
      "Системийн админ",
    ],
    "B": ["Сэтгэл зүйч", "Багш", "Human Resource", "Social Worker"],
    "C": [
      "Graphic Designer",
      "UI/UX Designer",
      "Animator",
      "Digital Artist",
      "Content Creator",
    ],
    "D": [
      "Механик инженер",
      "Электроник инженер",
      "Автоматжуулалтын инженер",
      "Роботик",
    ],
    "E": ["Бизнес менежер", "Маркетер", "Entrepreneur", "Project Manager"],
  };

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<String?>.filled(questions.length, null);
  }

  void calculateResult() {
    score = {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0};
    for (int i = 0; i < questions.length; i++) {
      final answer = selectedAnswers[i];
      if (answer != null) {
        if (answer == "yes")
          score[questions[i].keyLetter] = score[questions[i].keyLetter]! + 1;
        if (answer == "maybe")
          score[questions[i].keyLetter] = score[questions[i].keyLetter]! + 0.5;
      }
    }
    bestCategory = score.keys.reduce((a, b) => score[a]! > score[b]! ? a : b);
    setState(() => showResult = true);
  }

  double getProgress() {
    int answered = selectedAnswers.where((e) => e != null).length;
    return answered / questions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мэргэжил Сонголтын Тест"),
        backgroundColor: const Color(0xFFA58BFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: getProgress(),
              minHeight: 14,
              backgroundColor: Colors.purple.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${index + 1}. ${q.text}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: [
                              ChoiceChip(
                                label: const Text("Тийм"),
                                selected: selectedAnswers[index] == "yes",
                                onSelected: (selected) {
                                  setState(() {
                                    selectedAnswers[index] = selected
                                        ? "yes"
                                        : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text("Магадгүй"),
                                selected: selectedAnswers[index] == "maybe",
                                onSelected: (selected) {
                                  setState(() {
                                    selectedAnswers[index] = selected
                                        ? "maybe"
                                        : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text("Үгүй"),
                                selected: selectedAnswers[index] == "no",
                                onSelected: (selected) {
                                  setState(() {
                                    selectedAnswers[index] = selected
                                        ? "no"
                                        : null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: calculateResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA58BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  "Дүн гаргах",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (showResult)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Text(
                              icons[bestCategory]!,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Таны чиглэл: ${titles[bestCategory]}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        desc[bestCategory]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Танд тохирох боломжит мэргэжлүүд:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...suggestions[bestCategory]!.map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            "• $s",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
