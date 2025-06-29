import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/contants.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/utils/responsive.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  bool _hasAnimated = false;

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
    if (!_hasAnimated && info.visibleFraction > 0.3) {
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
      key: const Key('about-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: FadeTransition(
        opacity: _fadeIn,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 40 : 80,
            horizontal: isMobile ? 16 : 24,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 8,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.1),
                    blurRadius: 60,
                    spreadRadius: 2,
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 1000),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _AboutMe(),
                        SizedBox(height: 30),
                        Divider(thickness: 1.2),
                        SizedBox(height: 30),
                        _BasicInfo(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: _AboutMe()),
                        VerticalDivider(
                          width: 60,
                          thickness: 1.5,
                          color: Colors.teal,
                        ),
                        Expanded(child: _BasicInfo()),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutMe extends StatelessWidget {
  const _AboutMe();

  @override
  Widget build(BuildContext context) {
    final Color headingColor = accentColor;
    final Color textColor = Colors.grey.shade800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
        const SizedBox(height: 20),
        SelectableText(
          "I’m Punithraj M N, a full-stack developer with a passion for building high-quality applications across mobile and web platforms.\n\n"
          "With a strong foundation in Flutter, Dart, and backend integration, I take pride in creating seamless user experiences. I enjoy translating complex problems into simple, beautiful, and intuitive designs.\n\n"
          "When I’m not coding, I enjoy contributing to open-source projects and staying active in the developer community.",
          style: TextStyle(fontSize: 14, height: 1.7, color: textColor),
        ),
      ],
    );
  }
}

class _BasicInfo extends StatelessWidget {
  const _BasicInfo();

  Widget _infoItem(String label, String value) {
    final Color labelColor = Colors.blueGrey.shade800;
    final Color valueColor = Colors.grey.shade800;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: labelColor,
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(fontSize: 14, height: 1.5, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color headingColor = accentColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
        const SizedBox(height: 20),
        _infoItem('Date of Birth', 'June 14, 1994'),
        _infoItem('Email', 'punithraaj14@gmail.com'),
        _infoItem('Mobile No', '8088041006'),
        _infoItem('Address', '#397 Ashoka Road, Vidyanagar, Hassan'),
        _infoItem('Languages', 'Kannada, English, Hindi, Telugu'),
      ],
    );
  }
}
