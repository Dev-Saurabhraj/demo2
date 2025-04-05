import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

import 'package:lottie/lottie.dart';
import 'package:swaasthi/Youtube/yt_video.dart';

class RemedyScreen extends StatefulWidget {
  const RemedyScreen({super.key});

  @override
  State<RemedyScreen> createState() => _RemedyScreenState();
}

class _RemedyScreenState extends State<RemedyScreen> {
  final TextEditingController _remedyController = TextEditingController();
  final TextEditingController _yogaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Gemini AI model
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAU9qIHOgtPIoJKRtMrd2notqg8WJQPM0g',
  );

  // Response data
  Map<String, dynamic>? _remedyData;
  Map<String, dynamic>? _yogaData;
  bool _isLoading = false;
  String? _error;

  // Fetch remedy steps from Gemini
  Future<void> _fetchRemedySteps() async {
    if (_remedyController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _remedyData = null;
    });

    try {
      final prompt = '''
      Provide detailed steps to use the remedy product "${_remedyController.text}" 
      in strict JSON format with this structure:
      
      {
        "product_name": "string",
        "description": "string",
        "steps": ["step 1", "step 2", "step 3"],
        "precautions": ["string"],
        "best_time": "string"
      }
      
      Return only the JSON object with no additional text or markdown.
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final jsonString = response.text
              ?.replaceAll('```json', '')
              .replaceAll('```', '')
              .trim() ??
          '';
      final jsonResponse = json.decode(jsonString) as Map<String, dynamic>;

      setState(() {
        _remedyData = jsonResponse;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get remedy steps: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch yoga details from Gemini
  Future<void> _fetchYogaDetails() async {
    if (_yogaController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _yogaData = null;
    });

    try {
      final prompt = '''
      Provide detailed information about the yoga practice "${_yogaController.text}" 
      in strict JSON format with this structure:
      
      {
        "name": "string",
        "sanskrit_name": "string",
        "description": "string",
        "steps": ["step 1", "step 2", "step 3"],
        "benefits": ["string"],
        "contraindications": ["string"],
        "duration": "string",
        "breathing_technique": "string"
        "youtube_videoUrl": "string"
        "video_title": "string"
        "video_description": "string"
      }
      
      Return only the JSON object with no additional text or markdown.
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final jsonString = response.text
              ?.replaceAll('```json', '')
              .replaceAll('```', '')
              .trim() ??
          '';
      final jsonResponse = json.decode(jsonString) as Map<String, dynamic>;

      setState(() {
        _yogaData = jsonResponse;
        print(_yogaData!['youtube_videoUrl']);
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get yoga details: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        appBar: AppBar(
          title: Text(
            'Remedy & Yoga',
            style: TextStyle(fontFamily: 'RobotoSlab'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Remedy Products', icon: Icon(Icons.medical_services)),
              Tab(text: 'Yoga Practices', icon: Icon(Icons.self_improvement)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Remedy Products Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _remedyController,
                          decoration: InputDecoration(
                            labelText: 'Enter remedy product name',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _fetchRemedySteps,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a remedy name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: _fetchRemedySteps,
                          child: const Text('Get Usage Steps',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'RobotoSlab')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildRemedyResults(),
                ],
              ),
            ),

            // Yoga Practices Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _yogaController,
                          decoration: InputDecoration(
                            labelText: 'Enter yoga practice name',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _fetchYogaDetails,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a yoga practice';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: _fetchYogaDetails,
                          child: const Text('Get Yoga Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'RobotoSlab')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildYogaResults(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemedyResults() {
    if (_isLoading) {
      return Center(
          child: Lottie.asset('assets/animations/loading_animation.json'));
    }

    if (_error != null) {
      return Text(
        _error!,
        style: const TextStyle(color: Colors.red),
      );
    }

    if (_remedyData == null) {
      return const Text(
        'Enter a remedy product name to get usage instructions',
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _remedyData!['product_name'],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _remedyData!['description'],
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Text(
          'Usage Steps:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _remedyData!['steps'].length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text(_remedyData!['steps'][index]),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Precautions:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_remedyData!['precautions'] as List).map((precaution) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(precaution)),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Best time to use: ${_remedyData!['best_time']}',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildYogaResults() {
    if (_isLoading) {
      return Center(
          child: Lottie.asset('assets/animations/loading_animation.json',
              fit: BoxFit.contain));
    }

    if (_error != null) {
      return Text(
        _error!,
        style: const TextStyle(color: Colors.red),
      );
    }

    if (_yogaData == null) {
      return const Text(
        'Enter a yoga practice name to get detailed instructions',
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YogaVideoCard(poseName: _yogaData!['name']),
        Text(
          '${_yogaData!['name']} (${_yogaData!['sanskrit_name']})',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _yogaData!['description'],
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Text(
          'How to Practice:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _yogaData!['steps'].length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text(_yogaData!['steps'][index]),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Benefits:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_yogaData!['benefits'] as List).map((benefit) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(benefit)),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Contraindications:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_yogaData!['contraindications'] as List).map((warning) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.asset('assets/animations/alert.json',
                      width: 25, height: 30),
                  SizedBox(width: 8),
                  Expanded(child: Text(warning)),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Recommended Duration: ${_yogaData!['duration']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Breathing Technique: ${_yogaData!['breathing_technique']}',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _remedyController.dispose();
    _yogaController.dispose();
    super.dispose();
  }
}
