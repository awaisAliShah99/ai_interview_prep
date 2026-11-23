import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/feature_card.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    final email = user?.email ?? 'User';
    final firstName = email.split('@').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        title: const Text(
          'AI Interview Prep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  },
  icon: const Icon(Icons.person_outline),
  tooltip: 'My Profile',
),
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
            },
            
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Text(
              'Hello, $firstName 👋',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B2E),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Ready to prepare for your next interview?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // Purple welcome card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6D4AFF),
                    Color(0xFF4325B8),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Dream Job Starts Here!',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Practice smarter with AI-powered '
                    'interview preparation.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Powered by AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Statistics
            const Text(
              'Your Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Interviews',
                    value: '0',
                    icon: Icons.mic,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: StatCard(
                    title: 'Practice Hours',
                    value: '0',
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Expanded(
                  child: StatCard(
                    title: 'MCQs Completed',
                    value: '0',
                    icon: Icons.quiz,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: StatCard(
                    title: 'Average Score',
                    value: '0%',
                    icon: Icons.trending_up,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Features
            const Text(
              'Start Practicing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const FeatureCard(
              title: 'AI Mock Interview',
              description: 'Practice real interview questions with AI.',
              icon: Icons.record_voice_over,
              color: Color(0xFF6D4AFF),
            ),

            const FeatureCard(
              title: 'MCQ Practice',
              description: 'Test your technical and general knowledge.',
              icon: Icons.quiz_outlined,
              color: Colors.orange,
            ),

            const FeatureCard(
              title: 'Performance & Feedback',
              description: 'Understand your strengths and weaknesses.',
              icon: Icons.analytics_outlined,
              color: Colors.green,
            ),

            const FeatureCard(
              title: 'Interview History',
              description: 'Review your previous interview sessions.',
              icon: Icons.history,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}