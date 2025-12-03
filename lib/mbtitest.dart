import 'package:flutter/material.dart';

class MbtiTestPage extends StatefulWidget {
  const MbtiTestPage({super.key});

  @override
  State<MbtiTestPage> createState() => _MbtiTestPageState();
}

/* --------------------- MODEL --------------------- */

class MbtiQuestion {
  final String text;
  final String type; // EI, SN, TF, JP
  final int yes; // Тийм гэж хариулбал нэмэгдэх оноо
  final int no; // Үгүй гэж хариулбал нэмэгдэх оноо

  MbtiQuestion({
    required this.text,
    required this.type,
    required this.yes,
    required this.no,
  });
}

/* --------------------- STATE --------------------- */

class _MbtiTestPageState extends State<MbtiTestPage> {
  // MBTI асуултуудын жагсаалт
  final List<MbtiQuestion> questions = [
    MbtiQuestion(
      text: "Би хүмүүстэй уулзахдаа эрч хүч авдаг.",
      type: "EI",
      yes: 1,
      no: -1,
    ),
    MbtiQuestion(
      text: "Би ирээдүй, боломжийн талаар их боддог.",
      type: "SN",
      yes: -1,
      no: 1,
    ),
    MbtiQuestion(
      text: "Би шийдвэр гаргахдаа логик баримталдаг.",
      type: "TF",
      yes: 1,
      no: -1,
    ),
    MbtiQuestion(
      text: "Би төлөвлөгөө гаргаж, тогтмол мөрдөх дуртай.",
      type: "JP",
      yes: 1,
      no: -1,
    ),
  ];

  // Хариултыг хадгалах
  late List<String?> answers;

  // MBTI оноо
  int ei = 0, sn = 0, tf = 0, jp = 0;

  bool showResult = false;
  String mbti = "";

  @override
  void initState() {
    super.initState();
    answers = List<String?>.filled(questions.length, null);
  }

  /* --------------------- CALCULATE --------------------- */

  void calculate() {
    ei = sn = tf = jp = 0;

    for (int i = 0; i < questions.length; i++) {
      final String? sel = answers[i];
      if (sel == null) continue;

      final q = questions[i];
      final int val = sel == "yes" ? q.yes : q.no;

      switch (q.type) {
        case "EI":
          ei += val;
          break;
        case "SN":
          sn += val;
          break;
        case "TF":
          tf += val;
          break;
        case "JP":
          jp += val;
          break;
      }
    }

    String e = ei >= 0 ? "E" : "I";
    String s = sn >= 0 ? "S" : "N";
    String t = tf >= 0 ? "T" : "F";
    String j = jp >= 0 ? "J" : "P";

    mbti = "$e$s$t$j";

    setState(() => showResult = true);
  }

  /* --------------------- PROGRESS --------------------- */

  double getProgress() {
    int answered = answers.where((x) => x != null).length;
    return answered / questions.length;
  }

  /* --------------------- UI --------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MBTI Test"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: getProgress(),
              minHeight: 12,
              backgroundColor: Colors.deepPurple.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 12),

            /* ----------- Questions List ----------- */
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, i) {
                  final q = questions[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${i + 1}. ${q.text}",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: [
                              ChoiceChip(
                                label: const Text("Тийм"),
                                selected: answers[i] == "yes",
                                onSelected: (sel) {
                                  setState(() {
                                    answers[i] = sel ? "yes" : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text("Үгүй"),
                                selected: answers[i] == "no",
                                onSelected: (sel) {
                                  setState(() {
                                    answers[i] = sel ? "no" : null;
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

            /* ----------- Button ----------- */
            ElevatedButton(
              onPressed: calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                child: Text("Дүн Гаргах", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 16),

            /* ----------- Result Box ----------- */
            if (showResult)
              Card(
                color: Colors.deepPurple.shade50,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Таны MBTI төрөл:",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mbti,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
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
