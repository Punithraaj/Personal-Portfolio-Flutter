// lib/sections/skills_section.dart

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:my_portfolio/core/utils/contants.dart';
import '../../core/utils/responsive.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  bool _hasAnimated = false;

  // Map categories → (skill, proficiency)
  final Map<String, List<MapEntry<String, double>>> _groups = {
    'Mobile & Web': [
      MapEntry('Flutter', 0.85),
      MapEntry('Dart', 0.80),
      MapEntry('React', 0.70),
    ],
    'Backend': [
      MapEntry('Java', 0.85),
      MapEntry('Node.js', 0.75),
      MapEntry('Python', 0.70),
    ],
    'Database': [MapEntry('DB2', 0.75), MapEntry('SQL', 0.65)],
    'Tools & DevOps': [
      MapEntry('Git', 0.90),
      MapEntry('Firebase', 0.60),
      MapEntry('Docker', 0.50),
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
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

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: FadeTransition(
        opacity: _fadeIn,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 32 : 48,
            horizontal: isMobile ? 16 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // subtle drop shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 12),
                    ),
                    // blue glow
                    BoxShadow(
                      color: Colors.blue.shade700.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 24 : 32,
                  horizontal: isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Wrap into two columns on desktop, single column on mobile
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final spacing = 16.0;
                        final itemWidth = isMobile
                            ? double.infinity
                            : (constraints.maxWidth - spacing) / 2;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: _groups.entries.map((grp) {
                            return SizedBox(
                              width: itemWidth,
                              child: _SkillCategory(
                                title: grp.key,
                                skills: grp.value,
                                isMobile: isMobile,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String title;
  final List<MapEntry<String, double>> skills;
  final bool isMobile;

  const _SkillCategory({
    required this.title,
    required this.skills,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...skills.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.key,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: e.value,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(accentColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
