
import 'package:firebase_ai/firebase_ai.dart';

class AiInterviewService {
  final GenerativeModel _model =
      FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
  );

  Future<List<String>> generateQuestions({
    required String targetRole,
    required String experience,
  }) async {
    final prompt = '''
You are a professional technical interviewer.

Generate exactly 5 interview questions for a candidate.

Target Role: $targetRole
Experience: $experience

Requirements:
- Questions must be relevant to the target role.
- Adjust difficulty according to experience.
- Include practical and technical questions.
- Return only a numbered list.
- Do not include answers or explanations.
''';

    final response = await _model.generateContent([
      Content.text(prompt),
    ]);

    final responseText = response.text;

    if (responseText == null || responseText.trim().isEmpty) {
      throw Exception('AI did not generate any questions');
    }

    return responseText
        .split('\n')
        .map(
          (question) => question.replaceFirst(
            RegExp(r'^\s*\d+[\.\)]\s*'),
            '',
          ).trim(),
        )
        .where((question) => question.isNotEmpty)
        .toList();
  }
}
