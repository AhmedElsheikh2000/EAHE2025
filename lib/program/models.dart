// lib/program/models.dart
class Topic {
  final String id, title;
  final DateTime start, end;
  final String? speakerName, speakerRole;

  Topic({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.speakerName,
    this.speakerRole,
  });

  Duration timeLeft() => end.difference(DateTime.now());
}

class SessionModel {
  final String id, title;
  final DateTime start, end;
  final bool isBreak;
  final List<Topic> topics;

  SessionModel({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.isBreak,
    required this.topics,
  });

  Duration timeLeft() => end.difference(DateTime.now());
}

class ProgramDay {
  final DateTime date;
  final String title;
  final List<SessionModel> sessions;

  ProgramDay({
    required this.date,
    required this.title,
    required this.sessions,
  });
}
