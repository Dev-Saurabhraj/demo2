import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

const String apiKey = 'AIzaSyDtrqKierdGYGnMeQXayVLbEhYPehkRZkE';

Future<String?> fetchYogaVideoId(String poseName) async {
  final query = Uri.encodeFull('$poseName yoga tutorial');
  final url =
      'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=1&q=$query&key=$apiKey';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final items = data['items'];
    if (items != null && items.isNotEmpty) {
      return items[0]['id']['videoId'];
    }
  }
  return null;
}

class YogaVideoCard extends StatefulWidget {
  final String poseName;
  const YogaVideoCard({super.key, required this.poseName});

  @override
  State<YogaVideoCard> createState() => _YogaVideoCardState();
}

class _YogaVideoCardState extends State<YogaVideoCard> {
  YoutubePlayerController? _controller;
  bool isLoading = true;
  String? videoId;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  Future<void> loadVideo() async {
    videoId = await fetchYogaVideoId(widget.poseName);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.poseName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_controller != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.green,
                ),
              )
            else
              const Text("No video found for this pose."),
          ],
        ),
      ),
    );
  }
}
