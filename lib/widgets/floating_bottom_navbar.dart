import 'package:flutter/material.dart';
import 'package:mediox/presentation/audio/audio_home/audios_home.dart';
import 'package:mediox/presentation/video/video_home/videos_home.dart';

class FloatingBottomNavBar extends StatefulWidget {
  const FloatingBottomNavBar({super.key});

  @override
  State<FloatingBottomNavBar> createState() => _FloatingBottomNavBarState();
}

class _FloatingBottomNavBarState extends State<FloatingBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          padding: const EdgeInsets.all(8),
          // height: 95,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0XFF253D2C),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 228, 232, 229),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AudioHome()));
                  },
                  label: const Text(
                    "Audios",
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: const Icon(
                    Icons.audiotrack_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VideoHome()));
                  },
                  label: const Text(
                    "Videos",
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: const Icon(
                    Icons.video_camera_back_outlined,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
