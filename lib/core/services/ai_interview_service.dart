
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

  Future<String> evaluateAnswer({
    required String question,
    required String answer,
    required String targetRole,
    required String experience,
  }) async {
    final prompt = '''
You are an expert technical interview evaluator.

Evaluate the candidate's answer fairly and professionally.

Target Role: $targetRole
Experience: $experience

Interview Question:
$question

Candidate Answer:
$answer

Evaluate the answer based on:
- Relevance to the question
- Technical accuracy
- Clarity and communication
- Completeness

Return your evaluation in this format:

Score: (score out of 10)

Strengths:
- (List strengths)

Weaknesses:
- (List weaknesses)

Improved Answer:
(Write a better sample answer)

Final Feedback:
(Brief professional feedback)
''';

    final response = await _model.generateContent([
      Content.text(prompt),
    ]);

    final responseText = response.text;

    if (responseText == null || responseText.trim().isEmpty) {
      throw Exception('AI could not evaluate the answer');
    }

    return responseText.trim();
  }

}
