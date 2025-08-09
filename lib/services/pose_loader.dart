import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pose.dart';

class PoseLoader {
  static Future<List<Pose>> loadPoses() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/poses.json');
      final Map<String, dynamic> decoded = json.decode(jsonData);

      final imagesMap = Map<String, dynamic>.from(decoded['assets']['images']);
      final audioMap = Map<String, dynamic>.from(decoded['assets']['audio']);
      final List<dynamic> sequence = decoded['sequence'];

      return sequence.map<Pose>((seq) {
        final name = seq['name'] ?? 'Unnamed Pose';
        final duration = seq['durationSec'] ?? 0;

        final audioKey = seq['audioRef'] ?? '';
        final audioFile = audioMap[audioKey] ?? '';

        // Use first script's imageRef
        String imageFile = '';
        if (seq['script'] != null && seq['script'].isNotEmpty) {
          final firstScript = seq['script'][0];
          final imageKey = firstScript['imageRef'] ?? '';
          imageFile = imagesMap[imageKey] ?? '';
        }

        return Pose.fromResolved(
          name: name,
          imageFile: imageFile,
          audioFile: audioFile,
          duration: duration,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load poses: $e');
    }
  }
}
