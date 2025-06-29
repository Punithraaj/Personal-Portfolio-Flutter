// lib/main.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/core/utils/contants.dart';
import 'package:my_portfolio/features/about/about_section.dart';
import 'package:my_portfolio/features/common/portfolio_navigation.dart';
import 'package:my_portfolio/features/experience/experience_section.dart';
import 'package:my_portfolio/features/home/home_section.dart';
import 'package:my_portfolio/features/skills/skills_section.dart';

void main() => runApp(const MyPortfolioApp());

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
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  String _activeSection = 'Home';
  bool _isProgrammatic = false;

  final _keys = {
    'Home': GlobalKey(),
    'About': GlobalKey(),
    'Skills': GlobalKey(),
    'Experience': GlobalKey(),
    'Projects': GlobalKey(),
    'Contact': GlobalKey(),
  };

  static const _scrollStep = 100.0;
  static const _pageFraction = 0.8;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isProgrammatic) return;
    for (final entry in _keys.entries.toList().reversed) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final y = (ctx.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero)
          .dy;
      if (y <= kToolbarHeight + 20) {
        if (_activeSection != entry.key) {
          setState(() => _activeSection = entry.key);
        }
        break;
      }
    }
  }

  void _scrollTo(String section) {
    setState(() {
      _activeSection = section;
      _isProgrammatic = true;
    });

    final ctx = _keys[section]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _isProgrammatic = false);
        });
      });
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _isProgrammatic = false);
      });
    }
  }

  void _onKeyEvent(KeyEvent event) {
    // Only respond to non-repeat down events or explicit repeat events
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      // (Optionally filter out the very first repeat if you like:)
      // if (event is KeyDownEvent && event.repeat == false || event is KeyRepeatEvent) { ... }

      double offset = _scrollController.offset;
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          offset += _scrollStep;
          break;
        case LogicalKeyboardKey.arrowUp:
          offset -= _scrollStep;
          break;
        case LogicalKeyboardKey.pageDown:
          offset += MediaQuery.of(context).size.height * _pageFraction;
          break;
        case LogicalKeyboardKey.pageUp:
          offset -= MediaQuery.of(context).size.height * _pageFraction;
          break;
        default:
          return;
      }

      final min = _scrollController.position.minScrollExtent;
      final max = _scrollController.position.maxScrollExtent;
      offset = offset.clamp(min, max);

      _scrollController.jumpTo(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _onKeyEvent,
      child: Scaffold(
        endDrawer: PortfolioDrawer(
          activeSection: _activeSection,
          onItemSelected: _scrollTo,
        ),
        body: Stack(
          children: [
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
                  // ...projects, contact, etc.
                ],
              ),
            ),
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
      ),
    );
  }
}
