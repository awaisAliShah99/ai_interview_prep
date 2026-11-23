
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/ai_interview_service.dart';
import '../../core/services/audio_recording_service.dart';
import '../../core/services/audio_playback_service.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final _roleController = TextEditingController();
  final _experienceController = TextEditingController();

  final AiInterviewService _aiService = AiInterviewService();
  final AudioRecordingService _recordingService =
      AudioRecordingService();
  final AudioPlaybackService _playbackService =
      AudioPlaybackService();

  List<String> _questions = [];
  final Map<int, String> _recordings = {};

  bool _isGenerating = false;
  bool _isRecording = false;
  int? _recordingQuestionIndex;

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
      _recordings.clear();
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

  Future<void> _startRecording(int index) async {
    try {
      await _playbackService.stopPlayback();

      final started = await _recordingService.startRecording();

      if (!mounted) return;

      if (!started) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required'),
          ),
        );
        return;
      }

      setState(() {
        _isRecording = true;
        _recordingQuestionIndex = index;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording error: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final filePath = await _recordingService.stopRecording();

      if (!mounted) return;

      setState(() {
        if (filePath != null && _recordingQuestionIndex != null) {
          _recordings[_recordingQuestionIndex!] = filePath;
        }

        _isRecording = false;
        _recordingQuestionIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
    }
  }

  Future<void> _playRecording(String filePath) async {
    try {
      await _playbackService.playRecording(filePath);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playback error: $e')),
      );
    }
  }

  Future<void> _stopPlayback() async {
    await _playbackService.stopPlayback();
  }

  @override
  void dispose() {
    _roleController.dispose();
    _experienceController.dispose();

    unawaited(_recordingService.dispose());
    unawaited(_playbackService.dispose());

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
                onPressed: _isGenerating || _isRecording
                    ? null
                    : _generateQuestions,
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
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text('${i + 1}'),
                          ),
                          title: Text(_questions[i]),
                        ),

                        const Divider(),

                        if (_isRecording &&
                            _recordingQuestionIndex == i) ...[
                          const Text(
                            'Recording in progress...',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _stopRecording,
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop Recording'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isRecording
                                  ? null
                                  : () => _startRecording(i),
                              icon: const Icon(Icons.mic),
                              label: const Text('Record Answer'),
                            ),
                          ),

                          if (_recordings.containsKey(i)) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Answer recorded successfully',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        _playRecording(_recordings[i]!),
                                    icon: const Icon(Icons.play_arrow),
                                    label: const Text('Play'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _stopPlayback,
                                    icon: const Icon(Icons.stop),
                                    label: const Text('Stop Audio'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
