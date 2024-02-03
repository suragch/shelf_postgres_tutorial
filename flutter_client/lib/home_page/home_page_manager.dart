import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/score.dart';

const baseUrl = 'http://localhost:8080';
const headers = {'Content-Type': 'application/json; charset=UTF-8'};

class HomePageManager {
  final listNotifier = ListNotifier();
  final selectedScoreNotifier = ValueNotifier<Score?>(null);
  final nameController = TextEditingController();
  final scoreController = TextEditingController();

  void Function(String message)? snackbarCallback;

  Future<void> create() async {
    final userId = nameController.text;
    if (userId.isEmpty) {
      snackbarCallback?.call('Name is required');
      return;
    }

    final score = scoreController.text;
    final scoreInt = int.tryParse(score);
    if (scoreInt == null) {
      snackbarCallback?.call('Score must be an integer');
      return;
    }

    final data = {
      'user_id': userId,
      'score': scoreInt,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: headers,
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    print(body);

    if (response.statusCode != 200) {
      snackbarCallback?.call(body);
      return;
    }

    listNotifier.add(Score.fromJson(body));
    scoreController.clear();
    nameController.clear();
  }

  Future<void> read() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));
    final body = jsonDecode(response.body);
    print(body);

    if (response.statusCode != 200) {
      snackbarCallback?.call(body);
      return;
    }

    final scores = <Score>[];
    for (final row in body) {
      final score = Score.fromJson(row);
      scores.add(score);
    }
    listNotifier.replace(scores);

    if (scores.isEmpty) {
      snackbarCallback?.call('No scores found');
      return;
    }
  }

  Future<void> update() async {
    final score = selectedScoreNotifier.value;
    if (score == null) {
      snackbarCallback?.call('No score selected');
      return;
    }

    if (nameController.text != score.userId) {
      snackbarCallback?.call('Sorry you can\'t change the name');
      return;
    }

    final scoreInt = int.tryParse(scoreController.text);
    if (scoreInt == null) {
      snackbarCallback?.call('Score must be an integer');
      return;
    }

    final data = {
      'id': score.id,
      'score': scoreInt,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: headers,
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    print(body);

    if (response.statusCode != 200) {
      snackbarCallback?.call(body);
      return;
    }

    selectedScoreNotifier.value = null;
    scoreController.clear();
    nameController.clear();
    listNotifier.update(score.copyWith(
      score: body['score'],
      updated: DateTime.parse(body['updated']),
    ));
  }

  Future<void> delete() async {
    final score = selectedScoreNotifier.value;
    if (score == null) {
      snackbarCallback?.call('No score selected');
      return;
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/delete/${score.id}'),
      headers: headers,
    );
    final body = response.body;
    print(body);

    if (response.statusCode != 200) {
      snackbarCallback?.call(body);
      return;
    }

    selectedScoreNotifier.value = null;
    listNotifier.delete(score);
    nameController.clear();
    scoreController.clear();
  }

  void onScoreTapped(Score row) {
    selectedScoreNotifier.value = row;
    nameController.text = row.userId;
    scoreController.text = row.score.toString();
  }
}

class ListNotifier extends ValueNotifier<List<Score>> {
  ListNotifier() : super([]);

  void add(Score score) {
    value.add(score);
    notifyListeners();
  }

  void replace(List<Score> scores) {
    value = scores;
  }

  void update(Score score) {
    final index = value.indexWhere((s) => s.id == score.id);
    if (index == -1) return;
    value[index] = score;
    value = value.toList();
    notifyListeners();
  }

  void delete(Score score) {
    value.removeWhere((s) => s.id == score.id);
    notifyListeners();
  }
}
