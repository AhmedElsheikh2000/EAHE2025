import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  static const kBgSoft = Color(0xFFE9DFD1);   // الخلفية المطلوبة
  static const kPrimary = Color(0xFF27456B);  // الأزرق الأساسي

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EAHE 2025 • Information'),
      ),
      body: Container(
        color: kBgSoft,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _Headline(
              title: 'Information',
              subtitle: 'Egyptian Association for Health Economics • 4th Annual Conference',
            ),

            const SizedBox(height: 14),

            // ===== Overview (Announcement) =====
            _SectionCard(
              title: 'Overview',
              child: Text(
                'The Egyptian Association for Health Economics is proud to announce its 4th Annual Conference, '
                'to be held on the 7th of October 2025, at the prestigious Hilton Cairo Grand Nile. '
                'This highly anticipated event brings together experts, professionals, and stakeholders from diverse fields, '
                'including healthcare, media, and governmental institutions.',
                style: text.bodyMedium?.copyWith(height: 1.5),
              ),
            ),

            const SizedBox(height: 14),

            // ===== Vision =====
            _SectionCard(
              title: 'Vision',
              child: Text(
                'Becoming the leading platform in Egypt for advancing knowledge, policy, and practice in health economics, '
                'fostering innovation, and improving health outcomes.',
                style: text.bodyMedium?.copyWith(height: 1.5),
              ),
            ),

            const SizedBox(height: 14),

            // ===== Mission =====
            _SectionCard(
              title: 'Mission',
              child: Text(
                'To facilitate meaningful dialogue and collaboration by providing high-quality workshops, training, and discussions, '
                'the conference aims to empower decision-makers with the knowledge and tools necessary to address the complex '
                'economic challenges in the healthcare sector and to promote sustainable health policies and practices.',
                style: text.bodyMedium?.copyWith(height: 1.5),
              ),
            ),

            const SizedBox(height: 14),

            // ===== About EAHE =====
            _SectionCard(
              title: 'About EAHE',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Egyptian Association for Health Economics was founded in 2022 and has established itself rapidly as a '
                    'leading organization dedicated to the advancement of health economics in Egypt.',
                    style: text.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Board:',
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: kPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _Bullet(text: 'Prof. Ashraf Hatem — Conference President'),
                  const SizedBox(height: 6),
                  const _Bullet(text: 'Major General Dr. Magdy Amin — Conference Vice President'),
                  const SizedBox(height: 6),
                  const _Bullet(text: 'Prof. Nader Fasseeh — Conference Vice President'),
                  const SizedBox(height: 6),
                  const _Bullet(text: 'Dr. Sherif Abaza — Conference General Secretary'),
                  const SizedBox(height: 6),
                  const _Bullet(text: 'Dr. Ahmed Nader Fasseeh — Conference Treasurer'),
                  const SizedBox(height: 14),
                  Text(
                    'As our launching conference, held in October 2022, was a resounding success, the upcoming conference promises to be even more impactful, '
                    'featuring an extensive program that includes engaging discussions, workshops, and short training courses tailored for decision-makers.',
                    style: text.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Health Economics Conference 2025 is proudly sponsored by numerous local and international medical companies, reflecting strong industry support and creating valuable networking opportunities.',
                    style: text.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}

/* ===================== UI Helpers ===================== */

class _Headline extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _Headline({required this.title, this.subtitle});

  static const kPrimary = Color(0xFF27456B);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kPrimary.withOpacity(.15)),
          ),
          child: Text(
            title,
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: kPrimary,
              letterSpacing: .3,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(color: Colors.black87),
          ),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  static const kPrimary = Color(0xFF27456B);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kPrimary.withOpacity(.12)),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.square_rounded, color: kPrimary, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: kPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  static const kPrimary = Color(0xFF27456B);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 7, color: kPrimary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: t.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
