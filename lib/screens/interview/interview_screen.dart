
import 'package:flutter/material.dart';

import '../../core/services/ai_interview_service.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final _roleController = TextEditingController();
  final _experienceController = TextEditingController();

  final AiInterviewService _aiService = AiInterviewService();

  List<String> _questions = [];
  bool _isGenerating = false;

  Future<void> _generateQuestions() async {
    if (_roleController.text.trim().isEmpty ||
        _experienceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your role and experience'),
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _questions = [];
    });

    try {
      final questions = await _aiService.generateQuestions(
        targetRole: _roleController.text.trim(),
        experience: _experienceController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _questions = questions;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating questions: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('AI Mock Interview'),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prepare for Your Interview',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your details to generate personalized '
              'interview questions using AI.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                labelText: 'Target Role',
                hintText: 'e.g. Flutter Developer',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Experience',
                hintText: 'e.g. 1 year, Fresh Graduate',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    _isGenerating ? null : _generateQuestions,
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  _isGenerating
                      ? 'Generating Questions...'
                      : 'Generate Questions',
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (_questions.isNotEmpty) ...[
              const Text(
                'Your Interview Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              for (int i = 0; i < _questions.length; i++)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${i + 1}'),
                    ),
                    title: Text(_questions[i]),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
