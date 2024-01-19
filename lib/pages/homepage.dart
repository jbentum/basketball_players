import 'dart:convert';

import 'package:basketball_players/model/player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Player> players = [];

  Future getPlayers() async {
    var response =
        await http.get(Uri.https('balldontlie.io', 'api/v1/players'));
    var jsonData = jsonDecode(response.body);

    for (var eachPlayer in jsonData['data']) {
      final player = Player(
          first_name: eachPlayer['first_name'],
          position: eachPlayer['position']);

      players.add(player);
    }

    print(players.length);
  }

  @override
  Widget build(BuildContext context) {
    getPlayers();
    return Scaffold(
      body: FutureBuilder(
        future: getPlayers(),
        builder: (context, snapshot) {
          // is done loading , show team data
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.greenAccent,
                    ),
                    child: ListTile(
                      title: Text(players[index].first_name),
                      subtitle: Text(
                        players[index].position,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // if it is not done , show a circular lading circle
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
