class Score {
  final String id;
  final DateTime created;
  final DateTime updated;
  final String userId;
  final int score;

  const Score({
    required this.id,
    required this.created,
    required this.updated,
    required this.userId,
    required this.score,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      userId: json['user_id'],
      score: json['score'],
    );
  }

  Score copyWith({
    String? id,
    DateTime? created,
    DateTime? updated,
    String? userId,
    int? score,
  }) {
    return Score(
      id: id ?? this.id,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      userId: userId ?? this.userId,
      score: score ?? this.score,
    );
  }
}
