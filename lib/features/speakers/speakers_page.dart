import 'package:flutter/material.dart';

/// يحذف أي بادئة Dr/DR. من أول الاسم ويظبط المسافات
String cleanName(String n) {
  final withoutTitle =
      n.replaceFirst(RegExp(r'^\s*dr\.?\s*', caseSensitive: false), '');
  return withoutTitle.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class SpeakersPage extends StatefulWidget {
  const SpeakersPage({super.key});
  @override
  State<SpeakersPage> createState() => _SpeakersPageState();
}

class _SpeakersPageState extends State<SpeakersPage> {
  static const Color bg = Color(0xFFE9DFD1);

  static const List<_Speaker> _all = [
    _Speaker('Dr.Ahmed Nader',     'assets/speakers/ahmed_nader.jpg'),
    _Speaker('Dr.Ahmed Seyam',     'assets/speakers/ahmed_seyam.jpg'),
    _Speaker('DR.Amal Sedrak',     'assets/speakers/dr_amal_sedrak.jpg'),
    _Speaker('DR.Ashraf Hatem',    'assets/speakers/ashraf_hatem.jpg'),
    _Speaker('DR.Baher Elezbawy',  'assets/speakers/baher.jpg'),
    _Speaker('DR.Kareem Elfass',   'assets/speakers/dr_kareem.jpg'),
    _Speaker('DR.Nader Fasseeh',   'assets/speakers/nader_fasseeh.jpg'),
    _Speaker('DR.Sherif Abaza',    'assets/speakers/sherif_abaza.jpg'),
    _Speaker('DR.Zoltan Kalo',     'assets/speakers/zoltan.jpg'),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    // ترتيب أبجدي مع تجاهل Dr/DR. + فلترة حسب البحث
    final filtered = _all
        .where((s) => cleanName(s.name).toLowerCase().contains(_query.toLowerCase()))
        .toList()
      ..sort((a, b) => cleanName(a.name).toLowerCase().compareTo(cleanName(b.name).toLowerCase()));

    final width = MediaQuery.of(context).size.width;
    final cols = width >= 1100 ? 4 : width >= 750 ? 3 : 2;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF141414) : bg;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? const [Color(0xFF252525), Color(0xFF1B1B1B)]
                      : const [Color(0xFFEADFCC), Color(0xFFD9CBB5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black26, offset: Offset(0, 8))],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        'Speakers',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          letterSpacing: .2,
                          color: isDark ? Colors.white : Colors.brown.shade900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SearchField(
                        hint: 'Search by name… | ابحث بالاسم…',
                        onChanged: (v) => setState(() => _query = v.trim()),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // الشبكة
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: .75,
              ),
              itemBuilder: (_, i) => _SpeakerCard(data: filtered[i], isDark: isDark),
            ),
          ),
          if (filtered.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No speakers found.\nلا يوجد نتائج مطابقة.'),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged, required this.hint, required this.isDark});
  final ValueChanged<String> onChanged;
  final String hint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      cursorWidth: 1.8,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0D6C4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0D6C4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white70 : Colors.brown.shade600, width: 1.4),
        ),
      ),
    );
  }
}

class _SpeakerCard extends StatefulWidget {
  const _SpeakerCard({required this.data, required this.isDark});
  final _Speaker data;
  final bool isDark;

  @override
  State<_SpeakerCard> createState() => _SpeakerCardState();
}

class _SpeakerCardState extends State<_SpeakerCard> {
  bool _pressed = false;

  static const double imgSize = 110;

  @override
  Widget build(BuildContext context) {
    final displayName = cleanName(widget.data.name);

    final borderGradient = LinearGradient(
      colors: widget.isDark
          ? const [Color(0xFF4D3C2B), Color(0xFF7A5C3B)]
          : const [Color(0xFFB08D67), Color(0xFFD1B08A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          setState(() => _pressed = false);
          // TODO: افتح صفحة تفاصيل المتحدث لو عايز
          // Navigator.of(context).push(...);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: widget.isDark
                ? const LinearGradient(
                    colors: [Color(0xFF1F1F1F), Color(0xFF232323)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFF8F4EE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(widget.isDark ? 0.35 : 0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            // إطار متدرّج رفيع
            margin: const EdgeInsets.all(1.2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              gradient: borderGradient,
            ),
            child: Container(
              margin: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: widget.isDark ? const Color(0xFF1B1B1B) : Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                children: [
                  // حلقة متدرجة حول الصورة + ظل لطيف
                  Container(
                    width: imgSize + 14,
                    height: imgSize + 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: borderGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(widget.isDark ? 0.4 : 0.18),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          widget.data.asset,
                          width: imgSize,
                          height: imgSize,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 56),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      height: 1.12,
                      letterSpacing: .2,
                      color: widget.isDark ? Colors.white : Colors.brown.shade900,
                    ),
                  ),
                  const Spacer(),
                  // شريط زخرفي بسيط تحت الاسم
                  Opacity(
                    opacity: .7,
                    child: Container(
                      height: 4,
                      width: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: borderGradient,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Speaker {
  final String name;
  final String asset;
  const _Speaker(this.name, this.asset);
}
