import 'package:flutter/material.dart';

class AudioAppbar extends StatelessWidget{

  const AudioAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          elevation: 5,
          shadowColor: Colors.grey,
          surfaceTintColor: const Color(0xff2E6F40),
          title: Row(
            children: [
              Expanded(
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: "Search Audios....",
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  shadowColor: const WidgetStatePropertyAll(Color(0xff2E6F40)),
                ),
              ),
            ],
          ),
          toolbarHeight: 80,
          bottom: const TabBar(
              padding: EdgeInsets.symmetric(horizontal: 10),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Color(0xff2E6F40),
              dividerColor: Colors.transparent,
              labelColor: Color(0xff2E6F40),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(),
              tabs: [
                Tab(
                  text: "All Songs",
                ),
                Tab(
                  text: "Recently Played",
                ),
                Tab(
                  text: "Mostly Played",
                ),
                Tab(
                  text: "Playlists",
                ),
              ]),
        );
  }
}