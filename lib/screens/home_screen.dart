import 'package:flutter/material.dart';
import '../models/pose.dart';
import '../services/pose_loader.dart';
import 'session_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Pose>> _posesFuture;

  @override
  void initState() {
    super.initState();
    _posesFuture = PoseLoader.loadPoses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Session Preview'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pose>>(
        future: _posesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No poses found.'));
          }

          final poses = snapshot.data!;

          return ListView.builder(
            itemCount: poses.length,
            itemBuilder: (context, index) {
              final pose = poses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.asset(pose.imagePath, width: 60, fit: BoxFit.cover),
                  title: Text(pose.name),
                  subtitle: Text('${pose.duration} seconds'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<List<Pose>>(
        future: _posesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SessionScreen(poses: snapshot.data!),
                  ),
                );
              },
              label: const Text('Start Session'),
              icon: const Icon(Icons.play_arrow),
            );
          }
          return const SizedBox.shrink(); // don't show FAB if no poses
        },
      ),
    );
  }
}
