
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Interview Prep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('AI Interview Prep'),
        ),

        body: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                'Welcome to AI Interview Prep!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              AppButton(
                text: 'Get Started',
                onPressed: () {
                  debugPrint('Get Started button clicked!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
