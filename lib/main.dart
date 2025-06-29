import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/contants.dart';
import 'package:my_portfolio/features/about/about_section.dart';
import 'package:my_portfolio/features/common/portfolio_navigation.dart';
import 'package:my_portfolio/features/experience/experience_section.dart';
import 'package:my_portfolio/features/home/home_section.dart';
import 'package:my_portfolio/features/skills/skills_section.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punithraj M N | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: accentColor),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  String _activeSection = 'Home';
  bool _isProgrammaticScroll = false;

  final Map<String, GlobalKey> _keys = {
    'Home': GlobalKey(),
    'About': GlobalKey(),
    'Skills': GlobalKey(),
    'Experience': GlobalKey(),
    'Projects': GlobalKey(),
    'Contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Ignore updates during programmatic scrolling
    if (_isProgrammaticScroll) return;

    // Find the deepest section whose top is at or above the toolbar
    for (final entry in _keys.entries.toList().reversed) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final y = box.localToGlobal(Offset.zero).dy;
      if (y <= kToolbarHeight + 20) {
        if (_activeSection != entry.key) {
          setState(() => _activeSection = entry.key);
        }
        break;
      }
    }
  }

  void _scrollTo(String section) {
    // 1) Immediately set active
    setState(() {
      _activeSection = section;
      _isProgrammaticScroll = true;
    });

    // 2) Scroll to that section
    final ctx = _keys[section]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        // 3) After a brief delay, re-enable scroll-listener updates
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() => _isProgrammaticScroll = false);
          }
        });
      });
    } else {
      // Fallback: clear flag after a short delay
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _isProgrammaticScroll = false);
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: PortfolioDrawer(
        activeSection: _activeSection,
        onItemSelected: _scrollTo,
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(key: _keys['Home'], child: const HomeSection()),
                Container(key: _keys['About'], child: const AboutSection()),
                Container(key: _keys['Skills'], child: const SkillsSection()),
                Container(
                  key: _keys['Experience'],
                  child: const ExperienceSection(),
                ),

                // Container(
                //     key: _keys['Contact'], child: const ContactSection()),
              ],
            ),
          ),

          // Sticky, blurred navbar with active‐state underline
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Material(
                  elevation: 4,
                  color: Colors.white.withOpacity(0.8),
                  child: PortfolioNavigation(
                    activeSection: _activeSection,
                    onNavItemClicked: _scrollTo,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
