import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// عدّل الاستيرادين دول حسب مشروعك لو مساراتهم مختلفة
import 'package:eahe2025/program/models.dart';     // لازم يحتوي ProgramDay وفيه day.sessions/day.topics
import 'package:eahe2025/program/csv_loader.dart'; // لازم يوفر fetchProgramFromCsv(csvUrl)

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});
  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> with TickerProviderStateMixin {
  static const kBgSoft = Color(0xFFE9DFD1);
  static const kPrimary = Color(0xFF27456B);

  // تبويبات: Schedule / Favorites
  late final TabController _tabCtrl;

  // الداتا
  List<ProgramDay> _days = [];
  Set<String> fav = {};
  bool _loading = true;

  // تاريخ بدء إظهار العدّ التنازلي (يوم المؤتمر)
  static final DateTime _countdownBaseline = DateTime(2025, 10, 6);

  // هنظهر العد فقط إذا اليوم >= 6/10/2025
  bool get _shouldShowCountdown {
    final now = DateTime.now();
    return now.isAfter(_countdownBaseline) ||
        (now.year == _countdownBaseline.year &&
            now.month == _countdownBaseline.month &&
            now.day == _countdownBaseline.day);
  }

  // الـ Timer مش هنشغّله قبل البايسلاين
  Timer? _timer;

  // مصدر الجدول (Google Sheet CSV)
  final String csvUrl =
      'https://docs.google.com/spreadsheets/d/1e8eVFf2wIEMQoIyZWV808FzPjKRLLVzNOUhfVb0mh28/export?format=csv&gid=0';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _loadFav();
    try {
      final days = await fetchProgramFromCsv(csvUrl);
      if (!mounted) return;
      setState(() {
        _days = days;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }

    // شغّل التايمر فقط لو العدّ مفروض يظهر
    if (_shouldShowCountdown) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {}); // تحديث UI للعد
      });
    }
  }

  Future<void> _loadFav() async {
    final sp = await SharedPreferences.getInstance();
    fav = (sp.getStringList("fav_items") ?? []).toSet();
  }

  String _fmtTime(DateTime dt) => DateFormat('HH:mm').format(dt);
  String _fmtRange(DateTime a, DateTime b) => '${_fmtTime(a)} - ${_fmtTime(b)}';

  String _fmtLeft(Duration d) {
    if (d.isNegative) return 'Ended';
    final h = d.inHours, m = d.inMinutes % 60, s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // Chip للعدّ—مخفي تمامًا قبل 6/10/2025
  Widget _maybeCountdownChip(DateTime end) {
    if (!_shouldShowCountdown) return const SizedBox.shrink();
    final left = end.difference(DateTime.now());
    final ended = left.isNegative;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ended ? Colors.black12 : kPrimary.withOpacity(.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ended ? Colors.black26 : kPrimary.withOpacity(.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ended ? Icons.check_circle_outline : Icons.timer_outlined, size: 16, color: ended ? Colors.black54 : kPrimary),
          const SizedBox(width: 6),
          Text(
            ended ? 'Ended' : 'Ends in ${_fmtLeft(left)}',
            style: TextStyle(fontWeight: FontWeight.w600, color: ended ? Colors.black87 : kPrimary),
          ),
        ],
      ),
    );
  }

  // إضافة/إزالة من المفضلة + التحويل تلقائي لتبويب Favorites عند الإضافة
  Future<void> _toggleFav(String key, {required bool added}) async {
    final sp = await SharedPreferences.getInstance();
    if (fav.contains(key)) {
      fav.remove(key);
    } else {
      fav.add(key);
    }
    await sp.setStringList("fav_items", fav.toList());
    if (!mounted) return;
    setState(() {});
    if (added) _tabCtrl.animateTo(1); // روح لتبويب Favorites
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgSoft,
      appBar: AppBar(
        backgroundColor: kBgSoft,
        elevation: 0,
        centerTitle: true,
        title: const Text('Program', style: TextStyle(fontWeight: FontWeight.w900)),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: kPrimary,
          indicatorColor: kPrimary,
          tabs: const [
            Tab(text: 'Schedule'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _days.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'No program data found.\nPlease check the sheet share settings and column names.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildSchedule(),
                    _buildFavorites(),
                  ],
                ),
    );
  }

  // ==================== تبويب Schedule ====================
  Widget _buildSchedule() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemCount: _days.length,
      itemBuilder: (_, di) {
        final day = _days[di];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kPrimary.withOpacity(.12)),
            boxShadow: [BoxShadow(color: kPrimary.withOpacity(.08), blurRadius: 14, offset: const Offset(0, 8))],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Header
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: kPrimary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${DateFormat('EEE, d MMM yyyy').format(day.date)} • ${day.title}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: kPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Sessions
                ...day.sessions.map((s) {
                  final sessionKey = 'S:${day.date.toIso8601String()}_${_safeId(s)}';
                  final marked = fav.contains(sessionKey);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: _isBreak(s) ? const Color(0xFFF8F5EE) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kPrimary.withOpacity(.10)),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                      initiallyExpanded: false,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_fmtRange(_startOf(s), _endOf(s)), style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                            _titleOf(s) + (_isBreak(s) ? ' (Break)' : ''),
                            style: TextStyle(fontWeight: FontWeight.w900, color: _isBreak(s) ? Colors.brown[700] : kPrimary),
                          ),
                          const SizedBox(height: 6),
                          _maybeCountdownChip(_endOf(s)),
                        ],
                      ),
                      trailing: IconButton(
                        tooltip: 'Fav Session',
                        icon: Icon(marked ? Icons.favorite : Icons.favorite_border, color: marked ? Colors.red : Colors.black54),
                        onPressed: () => _toggleFav(sessionKey, added: !marked),
                      ),
                      children: [
                        if (_topicsOf(s).isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('No topics in this session.'),
                          ),
                        ..._topicsOf(s).map((t) {
                          final topicKey = 'T:${_safeId(t)}';
                          final speakerKey = 'P:${(_speakerNameOf(t)).toLowerCase()}';
                          final tMarked = fav.contains(topicKey);
                          final pMarked = (_speakerNameOf(t)).isNotEmpty && fav.contains(speakerKey);

                          return Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                title: Text('${_fmtTime(_startOf(t))} • ${_titleOf(t)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_speakerNameOf(t).isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          (_speakerRoleOf(t)).isEmpty
                                              ? _speakerNameOf(t)
                                              : '${_speakerNameOf(t)} • ${_speakerRoleOf(t)}',
                                        ),
                                      ),
                                    const SizedBox(height: 6),
                                    _maybeCountdownChip(_endOf(t)),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: 4,
                                  children: [
                                    IconButton(
                                      tooltip: 'Fav Topic',
                                      icon: Icon(tMarked ? Icons.favorite : Icons.favorite_border,
                                          color: tMarked ? Colors.red : Colors.black45),
                                      onPressed: () => _toggleFav(topicKey, added: !tMarked),
                                    ),
                                    if (_speakerNameOf(t).isNotEmpty)
                                      IconButton(
                                        tooltip: 'Fav Speaker',
                                        icon: Icon(pMarked ? Icons.star : Icons.star_border,
                                            color: pMarked ? Colors.amber[700] : Colors.black45),
                                        onPressed: () => _toggleFav(speakerKey, added: !pMarked),
                                      ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== تبويب Favorites ====================
  Widget _buildFavorites() {
    // نجمع العناصر المفضلة: Sessions, Topics, Speakers
    final List<_FavItem> items = [];

    for (final day in _days) {
      for (final s in day.sessions) {
        final sKey = 'S:${day.date.toIso8601String()}_${_safeId(s)}';
        if (fav.contains(sKey)) {
          items.add(_FavItem.session(day: day, session: s, key: sKey));
        }
        for (final t in _topicsOf(s)) {
          final tKey = 'T:${_safeId(t)}';
          if (fav.contains(tKey)) {
            items.add(_FavItem.topic(day: day, session: s, topic: t, key: tKey));
          }
          final pKey = 'P:${(_speakerNameOf(t)).toLowerCase()}';
          if (_speakerNameOf(t).isNotEmpty && fav.contains(pKey)) {
            items.add(_FavItem.speaker(day: day, session: s, topic: t, speakerKey: pKey));
          }
        }
      }
    }

    if (items.isEmpty) {
      return const Center(child: Text('No favorites yet.\nقم بإضافة عناصر إلى المفضلة.', textAlign: TextAlign.center));
    }

    // ترتيب بسيط: حسب اليوم ثم الوقت ثم نوع العنصر
    items.sort((a, b) {
      final ad = a.day.date.compareTo(b.day.date);
      if (ad != 0) return ad;
      final at = a.time.compareTo(b.time);
      if (at != 0) return at;
      return a.typeOrder.compareTo(b.typeOrder);
    });

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final it = items[i];

        IconData leadingIcon;
        Color stripe;
        String title;
        String subtitle;

        switch (it.type) {
          case _FavType.session:
            leadingIcon = Icons.event_note_outlined;
            stripe = kPrimary;
            title = '${_fmtRange(_startOf(it.session!), _endOf(it.session!))} • ${_titleOf(it.session!)}';
            subtitle = DateFormat('EEE, d MMM yyyy').format(it.day.date);
            break;
          case _FavType.topic:
            leadingIcon = Icons.article_outlined;
            stripe = Colors.teal.shade700;
            title = '${_fmtTime(_startOf(it.topic!))} • ${_titleOf(it.topic!)}';
            subtitle = (_speakerNameOf(it.topic!)).isEmpty
                ? DateFormat('EEE, d MMM yyyy').format(it.day.date)
                : '${_speakerNameOf(it.topic!)} • ${_speakerRoleOf(it.topic!)}'.trim();
            break;
          case _FavType.speaker:
            leadingIcon = Icons.star;
            stripe = Colors.amber.shade700;
            title = _speakerNameOf(it.topic!);
            subtitle = _titleOf(it.topic!);
            break;
        }

        final rightChip = _shouldShowCountdown ? _maybeCountdownChip(it.end) : const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kPrimary.withOpacity(.10)),
          ),
          child: Row(
            children: [
              Container(width: 4, height: 80, decoration: BoxDecoration(color: stripe, borderRadius: BorderRadius.circular(14))),
              Expanded(
                child: ListTile(
                  leading: Icon(leadingIcon, color: stripe),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(subtitle),
                  ),
                  trailing: rightChip,
                  onLongPress: () => _toggleFav(it.key, added: false), // شيل من المفضلة بالضغط الطويل
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== Helpers للوصول للحقول بشكل مرن ====================
  // الموديلات عندك لازم يكون فيها الحقول دي بالأسماء دي.
  // بنستخدم dynamic عشان نتفادى اختلاف أسماء الكلاسات.
  String _safeId(Object o) {
    final d = o as dynamic;
    if (d.id != null) return d.id.toString();
    // fallback: كوّن بصمة من الوقت والعنوان لو مافيش id
    final start = _startOf(o).toIso8601String();
    final title = _titleOf(o);
    return '${start}_$title';
  }

  DateTime _startOf(Object o) => (o as dynamic).start as DateTime;
  DateTime _endOf(Object o) => (o as dynamic).end as DateTime;
  String _titleOf(Object o) => ((o as dynamic).title as String?) ?? '';
  bool _isBreak(Object o) => (((o as dynamic).isBreak) as bool?) ?? false;

  List<dynamic> _topicsOf(Object session) {
    final t = (session as dynamic).topics;
    if (t == null) return const [];
    if (t is List) return t.cast<dynamic>();
    return const [];
  }

  String _speakerNameOf(Object topic) {
    final v = (topic as dynamic).speakerName;
    return (v is String) ? v : '';
    // لو عندك حقل speakersList مثلاً، ممكن تعدّل هنا
  }

  String _speakerRoleOf(Object topic) {
    final v = (topic as dynamic).speakerRole;
    return (v is String) ? v : '';
  }
}

// ==================== Helpers لصفحة Favorites ====================
enum _FavType { session, topic, speaker }

class _FavItem {
  final _FavType type;
  final String key;
  final ProgramDay day;
  // مرنين: Object بدل أسماء كلاس محددة
  final Object? session;
  final Object? topic;

  _FavItem._(this.type, this.key, this.day, this.session, this.topic);

  factory _FavItem.session({required ProgramDay day, required Object session, required String key}) =>
      _FavItem._(_FavType.session, key, day, session, null);

  factory _FavItem.topic({required ProgramDay day, required Object session, required Object topic, required String key}) =>
      _FavItem._(_FavType.topic, key, day, session, topic);

  factory _FavItem.speaker({required ProgramDay day, required Object session, required Object topic, required String speakerKey}) =>
      _FavItem._(_FavType.speaker, speakerKey, day, session, topic);

  // للترتيب في المفضلة
  DateTime get time {
    switch (type) {
      case _FavType.session:
        return (session as dynamic).start as DateTime;
      case _FavType.topic:
      case _FavType.speaker:
        return (topic as dynamic).start as DateTime;
    }
  }

  DateTime get end {
    switch (type) {
      case _FavType.session:
        return (session as dynamic).end as DateTime;
      case _FavType.topic:
      case _FavType.speaker:
        return (topic as dynamic).end as DateTime;
    }
  }

  int get typeOrder {
    switch (type) {
      case _FavType.session:
        return 0;
      case _FavType.topic:
        return 1;
      case _FavType.speaker:
        return 2;
    }
  }
}
