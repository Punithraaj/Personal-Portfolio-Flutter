// lib/widgets/portfolio_navigation.dart

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/nav_items.dart';
import 'package:my_portfolio/core/utils/contants.dart';
import 'package:my_portfolio/core/utils/responsive.dart';

class PortfolioNavigation extends StatelessWidget {
  final void Function(String section) onNavItemClicked;
  final String activeSection;

  const PortfolioNavigation({
    Key? key,
    required this.onNavItemClicked,
    required this.activeSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: isMobile ? _buildMobile(context) : _buildDesktop(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'PUNITHRAJ M N',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: accentColor,
          ),
        ),
        Row(
          children: navItems.map((title) {
            final isActive = title == activeSection;
            return GestureDetector(
              onTap: () => onNavItemClicked(title),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: isActive
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: accentColor, width: 3),
                        ),
                      )
                    : null,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? accentColor : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'PUNITHRAJ M N',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
          ),
        ),
      ],
    );
  }
}

/// Drawer for mobile navigation
class PortfolioDrawer extends StatelessWidget {
  final void Function(String section) onItemSelected;
  final String activeSection;

  const PortfolioDrawer({
    Key? key,
    required this.onItemSelected,
    required this.activeSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: navItems.map((title) {
            final isActive = title == activeSection;
            return ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? accentColor : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                onItemSelected(title);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
