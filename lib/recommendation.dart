import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class InvestmentAdvisorScreen extends StatefulWidget {
  final String userId;
  const InvestmentAdvisorScreen({super.key, required this.userId});

  @override
  State<InvestmentAdvisorScreen> createState() =>
      _InvestmentAdvisorScreenState();
}

class _InvestmentAdvisorScreenState extends State<InvestmentAdvisorScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String selectedGender = 'Male';
  String selectedAvenue = 'Stocks';
  String selectedPurpose = 'Wealth Creation';

  WebSocketChannel? channel;
  String response = '';

  final List<String> genderList = ['Male', 'Female', 'Other'];
  final List<String> avenueList = [
    'Stocks',
    'Mutual Funds',
    'Real Estate',
    'Gold',
    'Fixed Deposit'
  ];
  final List<String> purposeList = [
    'Wealth Creation',
    'Retirement',
    'Short-term Goals',
    'Emergency Fund'
  ];

  void connectWebSocket() {
    const socketUrl = 'wss://accf-34-125-20-154.ngrok-free.app/ws/investment';
    channel = WebSocketChannel.connect(Uri.parse(socketUrl));
    channel?.stream.listen((event) {
      print("📩 Received: $event");

      try {
        final data = json.decode(event);
        print("✅ Parsed Data: $data");

        if (data is Map && data.containsKey('result')) {
          setState(() {
            response = data['result'];
          });
        } else {
          setState(() => response = 'Invalid response format');
        }
      } catch (e) {
        setState(() => response = 'Error parsing response: $e');
      }
    });
  }

  void sendInvestmentQuery() {
    if (channel == null) connectWebSocket();

    final data = {
      "age": int.tryParse(ageController.text) ?? 0,
      "gender": selectedGender,
      "avenue": selectedAvenue,
      "purpose": selectedPurpose,
      "duration": durationController.text,
    };
    print("📤 Sending to backend: ${json.encode(data)}");
    channel?.sink.add(json.encode(data));
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  Widget buildInput(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.edit_outlined),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.arrow_drop_down),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('AI Investment Advisor'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    buildInput('Age', ageController,
                        type: TextInputType.number),
                    buildDropdown('Gender', selectedGender, genderList,
                        (val) => setState(() => selectedGender = val!)),
                    buildDropdown('Avenue', selectedAvenue, avenueList,
                        (val) => setState(() => selectedAvenue = val!)),
                    buildDropdown('Purpose', selectedPurpose, purposeList,
                        (val) => setState(() => selectedPurpose = val!)),
                    buildInput('Duration (e.g. 5 years)', durationController),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: sendInvestmentQuery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.auto_graph, color: Colors.white),
                        label: const Text(
                          'Get Recommendation',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (response.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "AI Recommendation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    response,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
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
