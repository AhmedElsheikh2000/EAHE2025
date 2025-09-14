// lib/program/csv_loader.dart
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'dart:developer' as dev;

Future<List<ProgramDay>> fetchProgramFromCsv(String csvUrl) async {
  dev.log('CSV URL => $csvUrl', name: 'ProgramLoader');

  final res = await http.get(Uri.parse(csvUrl));
  if (res.statusCode != 200) {
    dev.log('CSV HTTP Error: ${res.statusCode}', name: 'ProgramLoader', error: res.body);
    throw Exception('CSV load failed: ${res.statusCode}');
  }

  // جرّب التحويل بدون eol مخصص (يشتغل مع CRLF/Unix)
  final rows = const CsvToListConverter(shouldParseNumbers: false).convert(res.body);
  if (rows.isEmpty) {
    dev.log('CSV rows empty!', name: 'ProgramLoader');
    return [];
  }

  final header = rows.first.map((e) => e.toString().trim()).toList();
  dev.log('Header: $header', name: 'ProgramLoader');

  int idx(String name) => header.indexOf(name);

  final indices = {
    'day_date': idx('day_date'),
    'day_title': idx('day_title'),
    'session_id': idx('session_id'),
    'session_title': idx('session_title'),
    'session_start': idx('session_start'),
    'session_end': idx('session_end'),
    'is_break': idx('is_break'),
    'topic_id': idx('topic_id'),
    'topic_title': idx('topic_title'),
    'topic_start': idx('topic_start'),
    'topic_end': idx('topic_end'),
    'speaker_name': idx('speaker_name'),
    'speaker_role': idx('speaker_role'),
  };
  dev.log('Indices: $indices', name: 'ProgramLoader');

  // لو أي اندكس = -1 يبقى فيه عمود ناقص/اسم مختلف
  if (indices.values.any((v) => v == -1)) {
    throw Exception('Header mismatch. Please ensure all column names match exactly.');
  }

  final diDayDate = indices['day_date']!;
  final diDayTitle = indices['day_title']!;
  final diSessionId = indices['session_id']!;
  final diSessionTitle = indices['session_title']!;
  final diSessionStart = indices['session_start']!;
  final diSessionEnd = indices['session_end']!;
  final diIsBreak = indices['is_break']!;
  final diTopicId = indices['topic_id']!;
  final diTopicTitle = indices['topic_title']!;
  final diTopicStart = indices['topic_start']!;
  final diTopicEnd = indices['topic_end']!;
  final diSpeakerName = indices['speaker_name']!;
  final diSpeakerRole = indices['speaker_role']!;

  final Map<String, ProgramDay> dayMap = {};
  final Map<String, SessionModel> sessionMap = {};

  DateTime _dt(String date, String hm) {
    final parts = hm.split(':');
    return DateTime.parse(
      '$date ${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:00',
    );
  }

  int addedTopics = 0, addedSessions = 0;
  for (var i = 1; i < rows.length; i++) {
    final r = rows[i].map((e) => (e ?? '').toString().trim()).toList();
    if (r.every((e) => e.isEmpty)) continue;

    final dayDate = r[diDayDate];
    final dayTitle = r[diDayTitle].isEmpty ? 'Day' : r[diDayTitle];
    final sessionId = r[diSessionId];
    final sessionTitle = r[diSessionTitle].isEmpty ? 'Session' : r[diSessionTitle];
    final sessionStart = r[diSessionStart];
    final sessionEnd = r[diSessionEnd];
    final isBreak = (r[diIsBreak].toLowerCase() == 'true');

    final topicId = r[diTopicId];
    final topicTitle = r[diTopicTitle];
    final topicStart = r[diTopicStart];
    final topicEnd = r[diTopicEnd];
    final speakerName = r[diSpeakerName].isEmpty ? null : r[diSpeakerName];
    final speakerRole = r[diSpeakerRole].isEmpty ? null : r[diSpeakerRole];

    // day
    final dayKey = dayDate;
    dayMap.putIfAbsent(
      dayKey,
      () => ProgramDay(
        date: DateTime.parse('$dayDate 00:00:00'),
        title: dayTitle,
        sessions: [],
      ),
    );

    // session
    final sessKey = '$dayKey|$sessionId';
    if (!sessionMap.containsKey(sessKey)) {
      sessionMap[sessKey] = SessionModel(
        id: sessionId,
        title: sessionTitle,
        start: _dt(dayDate, sessionStart),
        end: _dt(dayDate, sessionEnd),
        isBreak: isBreak,
        topics: [],
      );
      dayMap[dayKey]!.sessions.add(sessionMap[sessKey]!);
      addedSessions++;
    }

    // topic (اختياري)
    if (topicId.isNotEmpty &&
        topicTitle.isNotEmpty &&
        topicStart.isNotEmpty &&
        topicEnd.isNotEmpty) {
      sessionMap[sessKey]!.topics.add(
        Topic(
          id: topicId,
          title: topicTitle,
          start: _dt(dayDate, topicStart),
          end: _dt(dayDate, topicEnd),
          speakerName: speakerName,
          speakerRole: speakerRole,
        ),
      );
      addedTopics++;
    }
  }

  final days = dayMap.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  for (final d in days) {
    d.sessions.sort((a, b) => a.start.compareTo(b.start));
    for (final s in d.sessions) {
      s.topics.sort((a, b) => a.start.compareTo(b.start));
    }
  }

  dev.log('Built days: ${days.length}, sessions: $addedSessions, topics: $addedTopics', name: 'ProgramLoader');
  return days;
}
