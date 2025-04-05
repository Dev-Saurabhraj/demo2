import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Gemini/gemini_configuration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;
  String? remedy_details;
  String? yoga_details;
  String? selectedSeverity;
  String result_remedy = "Enter details and press 'Predict'";
  String result_yoga = "";
  bool remedy_shown = false;
  bool isLoading = false;

  Future<void> getPrediction() async {
    if (symptomsController.text.isEmpty ||
        ageController.text.isEmpty ||
        selectedGender == null ||
        selectedSeverity == null) {
      setState(() {
        remedy_shown = false;
        result_remedy = "⚠️ Please fill all fields!";
      });
      return;
    }

    setState(() {
      isLoading = true;
      remedy_shown = false;
      result_remedy = "";
      result_yoga = "";
    });

    final url = Uri.parse("http://10.87.81.31:5000/predict");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "disease": symptomsController.text,
          "age": int.tryParse(ageController.text) ?? 0,
          "gender": selectedGender,
          "severity": selectedSeverity,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          remedy_shown = true;
          result_remedy = jsonResponse["home_remedy"] ?? "No prediction received";
          result_yoga = jsonResponse["yoga"];
        });

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('user_history')
              .doc(user.uid)
              .collection('predictions')
              .add({
            'timestamp': FieldValue.serverTimestamp(),
            'symptom': symptomsController.text,
            'age': ageController.text,
            'gender': selectedGender,
            'severity': selectedSeverity,
            'remedy': result_remedy,
            'yoga': result_yoga,
          });
        }
      } else {
        setState(() {
          remedy_shown = false;
          result_remedy = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        remedy_shown = false;
        result_remedy = "⚠️ Failed to connect. Make sure API is running!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Saurabh',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Keep up the good work!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push('/profile_screen');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green.shade100,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.green.shade700,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField("Enter your symptoms..", symptomsController),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField("Age..", ageController, isNumeric: true),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown("Gender", ["Male", "Female", "Other"],
                                        (val) => selectedGender = val),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildDropdown("Severity", ["Low", "Medium", "High"],
                                  (val) => selectedSeverity = val),
                          SizedBox(height: 20),

                          isLoading
                              ? CircularProgressIndicator(color: Colors.green.shade700)
                              : ElevatedButton(
                            onPressed: getPrediction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Predict",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          SizedBox(height: 20),
                          Text(
                            remedy_shown ? "Remedy : $result_remedy" : result_remedy,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            remedy_shown ? "Yoga : $result_yoga" : result_yoga,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          remedy_shown
                              ? GeminiApi(remedy: result_remedy, yoga: result_yoga)
                              : Container(),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown(
      String hint, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: Text(hint),
      icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green.shade700),
      style: TextStyle(color: Colors.black, fontSize: 16),
      dropdownColor: Colors.white,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        setState(() {
          onChanged(value);
        });
      },
    );
  }
}
