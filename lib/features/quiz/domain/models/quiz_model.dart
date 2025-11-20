class QuestionModel {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  const QuestionModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  QuestionModel copyWith({
    String? type,
    String? difficulty,
    String? category,
    String? question,
    String? correctAnswer,
    List<String>? incorrectAnswers,
  }) {
    return QuestionModel(
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      question: question ?? this.question,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      incorrectAnswers: incorrectAnswers ?? List<String>.from(this.incorrectAnswers),
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawQuestion = json['question']?.toString() ?? '';
    final rawCorrect = json['correct_answer']?.toString() ?? '';
    final rawIncorrect = json['incorrect_answers'];

    final decodedQuestion = _decodeHtml(rawQuestion);
    final decodedCorrect = _decodeHtml(rawCorrect);

    final incorrects = <String>[];
    if (rawIncorrect is List) {
      for (final item in rawIncorrect) {
        incorrects.add(_decodeHtml(item?.toString() ?? ''));
      }
    }

    return QuestionModel(
      type: (json['type'] as String?)?.trim() ?? 'multiple',
      difficulty: (json['difficulty'] as String?)?.trim() ?? 'easy',
      category: (json['category'] as String?)?.trim() ?? '',
      question: decodedQuestion,
      correctAnswer: decodedCorrect,
      incorrectAnswers: incorrects,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'difficulty': difficulty,
    'category': category,
    'question': question,
    'correct_answer': correctAnswer,
    'incorrect_answers': incorrectAnswers,
  };

  @override
  String toString() {
    return 'QuestionModel(type: $type, difficulty: $difficulty, category: $category, question: $question, correctAnswer: $correctAnswer, incorrectAnswers: $incorrectAnswers)';
  }

  static String _decodeHtml(String input) {
    if (input.isEmpty) return input;

    var out = input;
    out = out.replaceAll('&quot;', '"');
    out = out.replaceAll('&ldquo;', '“');
    out = out.replaceAll('&rdquo;', '”');
    out = out.replaceAll('&amp;', '&');
    out = out.replaceAll('&lt;', '<');
    out = out.replaceAll('&gt;', '>');
    out = out.replaceAll('&apos;', "'");
    out = out.replaceAll('&#039;', "'");

    out = out.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
      final code = int.tryParse(m[1] ?? '');
      if (code == null) return m[0] ?? '';
      return String.fromCharCode(code);
    });

    out = out.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (m) {
      final code = int.tryParse(m[1] ?? '', radix: 16);
      if (code == null) return m[0] ?? '';
      return String.fromCharCode(code);
    });

    return out;
  }
}