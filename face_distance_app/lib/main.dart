import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Use super.key for constructors

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Distance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FaceDistanceScreen(),
    );
  }
}

class FaceDistanceScreen extends StatefulWidget {
  const FaceDistanceScreen({super.key});

  @override
  State<FaceDistanceScreen> createState() => _FaceDistanceScreenState();
}

class _FaceDistanceScreenState extends State<FaceDistanceScreen> {
  double distance = 0.0;
  final AudioPlayer audioPlayer = AudioPlayer();

  // Function to fetch the distance from the server
  Future<void> fetchDistance() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.7.20.154:5000/get_distance'));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          if (jsonResponse['error'] == null) {
            distance = jsonResponse['distance'];

            // Play sound if distance is below a threshold (e.g., 50 cm)
            if (distance < 50.0) {
              playAlarm();
            }
          } else {
            distance = 0.0; // Reset distance on error
          }
        });
      }
    } catch (e) {
      print('Error fetching distance: $e');
    }
  }

  // Function to play sound from assets
  void playAlarm() {
    audioPlayer.play(AssetSource('assets/sounds/beepbeepbeep-53921.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Distance App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Distance to face:',
            ),
            Text(
              '$distance cm',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: fetchDistance,
              child: const Text('Get Distance'),
            ),
          ],
        ),
      ),
    );
  }
}
