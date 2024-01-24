// tournament_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tornament_temp/modals/tornament.dart';

class TournamentProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Tournament> tournaments = [];

  Future<void> fetchTournaments() async {
    try {
      final data = await _firestore.collection('tournaments').get();
      List<Tournament> tornamentList = [];
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          tornamentList.add(Tournament.fromJson(b.data()));
        }
      }

      tournaments = tornamentList;
      notifyListeners();
    } catch (error) {
      print('Error fetching tournaments: $error');
    }
  }

  Future<void> addTournament(Tournament tournament) async {
    try {
      await _firestore.collection('tournaments').add({
        'type': tournament.type,
        'title': tournament.title,
        'fromDate': tournament.fromDate,
        'toDate': tournament.toDate,
        'venue': tournament.venue,
        'subType': tournament.subType,
      });

      // Fetch tournaments again to update the local list
      await fetchTournaments();
    } catch (error) {
      print('Error adding tournament: $error');
    }
  }

  // Additional methods for updating and editing tournaments

  // ...
}
