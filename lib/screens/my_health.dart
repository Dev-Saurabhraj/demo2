import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'package:swaasthi/widgets/history_details_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyHealth extends StatefulWidget {
  const MyHealth({Key? key}) : super(key: key);

  @override
  State<MyHealth> createState() => _MyHealthState();
}

class _MyHealthState extends State<MyHealth> with SingleTickerProviderStateMixin {
  List<double> _animatedYValues = List.filled(7, 0.0);
  double _stepsPercent = 0.0;
  double _caloriesPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations(){
    // Animate Bar Chart
    final targetYValues = [7500.0, 8200.0, 6800.0, 9100.0, 8700.0, 7300.0, 5600.0];
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      bool done = true;
      setState(() {
        for (int i = 0; i < _animatedYValues.length; i++) {
          if (_animatedYValues[i] < targetYValues[i]) {
            _animatedYValues[i] += 300;
            done = false;
          } else {
            _animatedYValues[i] = targetYValues[i];
          }
        }
      });
      if (done) timer.cancel();
    });

    // Animate Circular Indicators
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_stepsPercent < 0.75) _stepsPercent += 0.03;
        if (_caloriesPercent < 0.6) _caloriesPercent += 0.03;

        if (_stepsPercent >= 0.75 && _caloriesPercent >= 0.6) {
          _stepsPercent = 0.75;
          _caloriesPercent = 0.6;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, Saurabh', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Keep up the good work!', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green.shade100,
                      ),
                      child: Center(
                        child: Icon(Icons.person, color: Colors.green.shade700, size: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: InkWell(
                    onTap: (){
                      GoRouter.of(context).pushNamed('pose_detector');
                    },
                    child: const Row(
                      children: [
                        Text("Go for Yoga", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Progress Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3CB371), Color(0xFF4CAF50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Today\'s Progress', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Icon(Icons.more_horiz, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircularPercentIndicator(
                            radius: 55.0,
                            lineWidth: 12.0,
                            percent: _stepsPercent.clamp(0.0, 1.0),
                            center: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('7,532', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('Steps', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            progressColor: Colors.white,
                          ),
                          CircularPercentIndicator(
                            radius: 55.0,
                            lineWidth: 12.0,
                            percent: _caloriesPercent.clamp(0.0, 1.0),
                            center: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('1,800', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('Calories', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            progressColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Weekly Chart Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Weekly Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              CircleAvatar(radius: 6, backgroundColor: Color(0xFF3CB371)),
                              SizedBox(width: 5),
                              Text('Steps', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              SizedBox(width: 10),
                              CircleAvatar(radius: 6, backgroundColor: Color(0xFFAED581)),
                              SizedBox(width: 5),
                              Text('Calories', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 10000,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        titles[value.toInt()],
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(7, (index) {
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: _animatedYValues[index],
                                    color: const Color(0xFF3CB371),
                                    width: 15,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SymptomsHistorySection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class SymptomsHistorySection extends StatefulWidget {
  @override
  _SymptomsHistorySectionState createState() => _SymptomsHistorySectionState();
}

class _SymptomsHistorySectionState extends State<SymptomsHistorySection> {
  bool _expanded = false;
  List<Map<String, dynamic>> _symptomsHistory = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchSymptomsHistory();
  }

  Future<void> fetchSymptomsHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('user_history')
          .doc(user.uid)
          .collection('predictions')
          .orderBy('timestamp', descending: true)
          .get();

      if (!mounted) return;

      final history = snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        _symptomsHistory = history;
      });
    } catch (e) {
      print("Error fetching symptoms history: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> clearHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final batch = FirebaseFirestore.instance.batch();
    final snapshot = await FirebaseFirestore.instance
        .collection('user_history')
        .doc(user.uid)
        .collection('predictions')
        .get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    fetchSymptomsHistory(); // Refresh after deleting
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown time";
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    final latestSymptom = _symptomsHistory.isNotEmpty
        ? _symptomsHistory.first['symptom'] ?? "No data"
        : "No symptoms recorded";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with clear button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Last Symptoms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Clear history',
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Clear History"),
                          content: const Text("Are you sure you want to delete all symptom history?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes")),
                          ],
                        ),
                      );
                      if (confirm == true) await clearHistory();
                    },
                  ),
                  IconButton(
                    icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() => _expanded = !_expanded);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Body
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_symptomsHistory.isEmpty)
            const Text("No symptoms recorded yet.", style: TextStyle(fontSize: 16, color: Colors.black54))
          else if (!_expanded)
              Text(latestSymptom, style: const TextStyle(fontSize: 16, color: Colors.black87))
            else
              Column(
                children: _symptomsHistory.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 6)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Symptom: ${entry['symptom'] ?? 'N/A'}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        Text("Age: ${entry['age'] ?? 'N/A'} | Gender: ${entry['gender'] ?? 'N/A'} | Severity: ${entry['severity'] ?? 'N/A'}"),
                        const SizedBox(height: 5),
                        Text("Remedy: ${entry['remedy'] ?? 'N/A'}"),
                        const SizedBox(height: 5),
                        Text("Yoga: ${entry['yoga'] ?? 'N/A'}"),
                        const SizedBox(height: 5),
                        Text("Date: ${formatTimestamp(entry['timestamp'])}", style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  );
                }).toList(),
              ),
        ],
      ),
    );
  }
}
