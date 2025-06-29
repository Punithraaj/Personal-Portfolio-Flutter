// lib/sections/experience_section.dart

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/contants.dart';
import 'package:my_portfolio/features/experience/model/company_experience.dart';
import 'package:my_portfolio/features/experience/model/position.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/utils/responsive.dart';

/// Helper to compute a human-readable duration
String _computePeriod(DateTime start, DateTime end) {
  final now = DateTime.now();
  final effectiveEnd = end.isBefore(now) ? end : now;
  int totalMonths =
      (effectiveEnd.year - start.year) * 12 +
      (effectiveEnd.month - start.month);
  if (effectiveEnd.day < start.day) {
    totalMonths -= 1;
  }
  final years = totalMonths ~/ 12;
  final months = totalMonths % 12;
  if (years > 0 && months > 0) {
    return '$years yr${years > 1 ? 's' : ''} $months mo${months > 1 ? 's' : ''}';
  } else if (years > 0) {
    return '$years yr${years > 1 ? 's' : ''}';
  } else {
    return '$months mo${months > 1 ? 's' : ''}';
  }
}

/// Formats a DateTime as "MMM yyyy" (non-breaking)
String _fmt(DateTime d) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[d.month]}\u00A0${d.year}';
}

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  bool _hasAnimated = false;

  final List<CompanyExperience> _data = [
    CompanyExperience(
      startDate: DateTime(2021, 7, 31),
      endDate: DateTime.now(),
      companyName: 'Morgan Stanley',
      logoAsset: 'assets/logos/morgan_stanley.jpg',
      positions: [
        Position(
          title: 'Director',
          startDate: DateTime(2025, 1, 13),
          endDate: DateTime.now(),
          description: 'Bengaluru, Karnataka, India · Hybrid',
        ),
        Position(
          title: 'Manager',
          startDate: DateTime(2023, 1, 13),
          endDate: DateTime(2025, 1, 12),
          description: 'Bengaluru, Karnataka, India · On-site',
        ),
        Position(
          title: 'Senior Associate Engineer',
          startDate: DateTime(2021, 7, 31),
          endDate: DateTime(2023, 1, 12),
          description: 'Bangalore Urban, Karnataka, India · Hybrid',
        ),
        Position(
          title: 'Software Development Consultant at Morgan Stanley',
          startDate: DateTime(2019, 8, 5),
          endDate: DateTime(2021, 7, 30),
          description: 'Bengaluru Area, India',
        ),
      ],
    ),
    CompanyExperience(
      startDate: DateTime(2019, 8, 5),
      endDate: DateTime(2021, 7, 30),
      companyName: 'Zen & Art',
      logoAsset: 'assets/logos/zenArt.jpg',
      positions: [
        Position(
          title: 'Software Engineer',
          startDate: DateTime(2019, 8, 5),
          endDate: DateTime(2021, 7, 30),
          description: 'Bengaluru Area, India',
        ),
      ],
    ),
    CompanyExperience(
      startDate: DateTime(2018, 10, 1),
      endDate: DateTime(2019, 8, 4),
      companyName: 'NOVELSYNTH Soft Solutions Private Limited',
      logoAsset: null,
      positions: [
        Position(
          title: 'Software Developer',
          startDate: DateTime(2018, 10, 1),
          endDate: DateTime(2019, 8, 4),
          description: 'Bangalore Urban, Karnataka, India',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.2) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final sorted = List<CompanyExperience>.from(_data)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: FadeTransition(
        opacity: _fadeIn,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 24 : 48,
            horizontal: isMobile ? 16 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experience',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...sorted.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final group = entry.value;
                    return _CompanyTimelineEntry(
                      group: group,
                      isLast: idx == sorted.length - 1,
                      isMobile: isMobile,
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompanyTimelineEntry extends StatelessWidget {
  final CompanyExperience group;
  final bool isLast;
  final bool isMobile;

  const _CompanyTimelineEntry({
    required this.group,
    required this.isLast,
    required this.isMobile,
  });

  Widget _companyHeader() {
    if (group.logoAsset != null) {
      return Image.asset(group.logoAsset!, height: isMobile ? 32 : 40);
    } else {
      final initials = group.companyName
          .split(' ')
          .where((w) => w.isNotEmpty)
          .map((w) => w[0])
          .take(2)
          .join();
      return CircleAvatar(
        radius: isMobile ? 16 : 20,
        backgroundColor: accentColor,
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endNormalized = DateTime(
      group.endDate.year,
      group.endDate.month,
      group.endDate.day,
    );
    final startText = _fmt(group.startDate);
    final endText = endNormalized.isBefore(today)
        ? _fmt(group.endDate)
        : 'Present';
    final companyLabel = '$startText\u00A0–\u00A0$endText';

    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 100 : 140,
            child: Column(
              children: [
                Text(
                  companyLabel,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: accentColor)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isMobile ? 24 : 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 4,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _companyHeader(),
                  const SizedBox(height: 12),
                  Text(
                    group.companyName,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Positions with dividers
                  ...group.positions.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final pos = entry.value;
                    final posStart = pos.startDate;
                    final posEnd = pos.endDate;
                    final normalizedEnd = DateTime(
                      posEnd.year,
                      posEnd.month,
                      posEnd.day,
                    );
                    final posLabelStart = _fmt(posStart);
                    final posLabelEnd = normalizedEnd.isBefore(today)
                        ? _fmt(posEnd)
                        : 'Present';
                    final posRange = '$posLabelStart\u00A0–\u00A0$posLabelEnd';
                    final posDuration = _computePeriod(posStart, posEnd);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (idx > 0)
                          const Divider(color: Colors.black12, thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pos.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '$posRange · $posDuration',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pos.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
