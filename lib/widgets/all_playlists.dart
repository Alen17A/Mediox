import 'package:flutter/material.dart';
import 'package:mediox/screens/favourites_audio.dart';

class AllPlaylists extends StatelessWidget {
  const AllPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            overlayColor: const WidgetStatePropertyAll(
                Color.fromARGB(255, 197, 120, 115)),
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FavouritesAudio()));
            },
            child: const Card(
              surfaceTintColor: Colors.red,
              child: ListTile(
                leading: Icon(
                  Icons.favorite_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  "Favourites",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
