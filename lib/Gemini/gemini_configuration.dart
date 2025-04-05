import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';

class GeminiApi extends StatefulWidget {
  final String remedy;
  final String yoga;

  const GeminiApi({Key? key, required this.remedy, required this.yoga})
      : super(key: key);

  @override
  State<GeminiApi> createState() => _GeminiApiState();
}

class _GeminiApiState extends State<GeminiApi>
    with SingleTickerProviderStateMixin {
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey:
        'AIzaSyAU9qIHOgtPIoJKRtMrd2notqg8WJQPM0g', // Replace with actual API key
  );

  Map<String, dynamic>? _remedyData;
  Map<String, dynamic>? _yogaData;
  bool _isLoading = false;
  String? _error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRemedySteps();
    _fetchYogaDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchRemedySteps() async {
    if (widget.remedy.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _remedyData = null;
    });

    try {
      final prompt = '''
      Provide detailed steps to use the remedy product "${widget.remedy}" in strict JSON format:
      
      {
        "product_name": "string",
        "description": "string",
        "steps": ["step 1", "step 2"],
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

  Future<void> _fetchYogaDetails() async {
    if (widget.yoga.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _yogaData = null;
    });

    try {
      final prompt = '''
      Provide detailed information about the yoga practice "${widget.yoga}" in strict JSON format:
      
      {
        "name": "string",
        "sanskrit_name": "string",
        "description": "string",
        "steps": ["step 1", "step 2"],
        "benefits": ["string"],
        "contraindications": ["string"],
        "duration": "string",
        "breathing_technique": "string"
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
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.teal,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.teal,
            tabs: const [
              Tab(text: 'Remedy Instructions'),
              Tab(text: 'Yoga Practice'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tab Bar View
        SizedBox(
          height: MediaQuery.of(context).size.height *
              2.5, // Adjust height as needed
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              _buildRemedyResults(),
              _buildYogaResults(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemedyResults() {
    if (_isLoading) {
      return Center(
          child: Lottie.asset('assets/images/progress_indicator.json'));
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_remedyData == null) {
      return const Center(
        child: Text(
          'Enter a remedy product name to get usage instructions',
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
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
        Text(_remedyData!['description'], style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text('Usage Steps:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_remedyData!['steps'] as List).map((precaution) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.arrow_circle_right_rounded,
                      color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    precaution,
                    style: TextStyle(fontFamily: 'RobotoSlab'),
                  )),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Precautions:',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_remedyData!['precautions'] as List).map((precaution) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    precaution,
                    style: TextStyle(fontFamily: 'RobotoSlab'),
                  )),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text('Best time to use: ${_remedyData!['best_time']}',
            style: const TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }

  Widget _buildYogaResults() {
    if (_isLoading) {
      return Center(
          child: Lottie.asset('assets/images/progress_indicator.json'));
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_yogaData == null) {
      return const Center(
        child: Text(
          'Enter a yoga practice name to get detailed instructions',
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_yogaData!['name']} (${_yogaData!['sanskrit_name']})',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(_yogaData!['description'], style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text('How to Practice:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_remedyData!['steps'] as List).map((precaution) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.arrow_circle_right_rounded,
                      color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    precaution,
                    style: TextStyle(fontFamily: 'RobotoSlab'),
                  )),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Benefits:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_yogaData!['benefits'] as List).map((benefit) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
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
        const Text('Contraindications:',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (_yogaData!['contraindications'] as List).map((contra) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(contra)),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text('Duration: ${_yogaData!['duration']}',
            style: const TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 8),
        Text('Breathing Technique: ${_yogaData!['breathing_technique']}',
            style: const TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }
}
