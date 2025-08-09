import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/pose.dart';

class SessionScreen extends StatefulWidget {
  final List<Pose> poses;

  // ignore: use_super_parameters
  const SessionScreen({Key? key, required this.poses}) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  int _timeLeft = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startPose(widget.poses[_currentIndex]);
  }

  void _startPose(Pose pose) async {
    setState(() {
      _timeLeft = pose.duration;
      _isPlaying = true;
    });

    // Play audio
    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource(pose.audioPath.replaceFirst('assets/', '')),
    );

    // Countdown timer
    _countdown(pose);
  }

  void _countdown(Pose pose) {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
        _countdown(pose);
      } else {
        _nextPose();
      }
    });
  }

  void _nextPose() {
    if (_currentIndex < widget.poses.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startPose(widget.poses[_currentIndex]);
    } else {
      setState(() {
        _isPlaying = false;
      });
      _audioPlayer.stop();
      _showSessionCompleteDialog();
    }
  }

  void _showSessionCompleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Session Complete!"),
        content: const Text("Great job completing your yoga session."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pose = widget.poses[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text("Yoga Session"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pose.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              pose.imagePath,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              "Time left: $_timeLeft sec",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 40),
            if (!_isPlaying)
              ElevatedButton(
                onPressed: () => _startPose(pose),
                child: const Text("Restart Session"),
              ),
          ],
        ),
      ),
    );
  }
}
