import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SurveyApp());
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removed debug banner
      title: 'Airport Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SurveyScreen(),
    );
  }
}

class SurveyScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final String apiUrl = 'http://192.168.241.229:3000';

  Future<void> submitRating(int rating) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/surveys'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'rating': rating,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          // Check if widget is still mounted
          showThankYouDialog();
        }
      } else {
        if (mounted) {
          // Check if widget is still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit rating: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        print('Failed to submit rating: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting rating: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error submitting rating: $e');
    }
  }

  void showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto-dismiss after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 70,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Thank You',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your feedback is important to us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget ratingButton(String emoji, String label, int rating) {
  //   return Column(
  //     children: [
  //       ElevatedButton(
  //         onPressed: () => submitRating(rating),
  //         style: ElevatedButton.styleFrom(
  //           padding: const EdgeInsets.all(20),
  //           shape: const CircleBorder(),
  //         ),
  //         child: Text(
  //           emoji,
  //           style: const TextStyle(fontSize: 40),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Text(label, style: const TextStyle(fontSize: 18)),
  //     ],
  //   );
  // }
  // Modify your ratingButton function:
  Widget ratingButton(String emoji, String label, int rating) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => submitRating(rating),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width < 400 ? 12 : 20),
                shape: const CircleBorder(),
              ),
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 400 ? 25 : 40,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/zacl.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'How was your experience today?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ratingButton('😠', 'Very Bad', 1),
                  ratingButton('☹️', 'Bad', 2),
                  ratingButton('😐', 'Average', 3),
                  ratingButton('😊', 'Good', 4),
                  ratingButton('😄', 'Very Good', 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
