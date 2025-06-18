import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  void _submitFeedback(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send Feedback"),
          content: TextField(
            controller: feedbackController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Type your feedback here...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                final feedback = feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  print("User Feedback: $feedback"); // Logs to terminal
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Thank you for your feedback!")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=App Help&body=Hi, I need help with...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print("Could not launch email client.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Need help?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "If you have questions or suggestions, feel free to reach out.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Send Feedback"),
              subtitle: const Text("We value your thoughts"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _submitFeedback(context),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email Us"),
              subtitle: const Text("support@example.com"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _launchEmail,
            ),
          ),
        ],
      ),
    );
  }
}
