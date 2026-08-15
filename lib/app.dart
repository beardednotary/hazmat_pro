import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/review_service.dart';
import 'theme/hazmat_theme.dart';
import 'widgets/hazmat_header.dart';
import 'screens/placards_screen.dart';
import 'screens/un_numbers_screen.dart';
import 'screens/glossary_screen.dart';
import 'screens/quick_ref_screen.dart';
import 'screens/identify_screen.dart';
import 'screens/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _titles = ['PLACARDS', 'UN NUMBERS', 'GLOSSARY', 'QUICK REF', 'IDENTIFY'];
  static const _subtitles = [
    '9 DOT HAZARD CLASSES',
    'SEARCHABLE · STARRABLE',
    'GHS · DOT TERMINOLOGY',
    'PPE · ZONES · SDS · ERG',
    'HOLD & SPEAK TO IDENTIFY',
  ];

  @override
  void initState() {
    super.initState();
    ReviewService.instance.onTabVisited(0);
  }

  void _onTab(int index) {
    if (index != _currentIndex) {
      HapticFeedback.selectionClick();
      setState(() => _currentIndex = index);
      ReviewService.instance.onTabVisited(index);
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HazmatHeader(
              title: _titles[_currentIndex],
              subtitle: _subtitles[_currentIndex],
              onSettings: _openSettings,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  PlacardsScreen(),
                  UnNumbersScreen(),
                  GlossaryScreen(),
                  QuickRefScreen(),
                  IdentifyScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _HazardBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTab,
      ),
    );
  }
}

class _HazardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _HazardBottomNav({required this.currentIndex, required this.onTap});

  static const _tabs = [
    _TabData(icon: Icons.crop_square, label: 'PLACARDS'),
    _TabData(icon: Icons.tag, label: 'UN NO.'),
    _TabData(icon: Icons.menu_book_outlined, label: 'GLOSSARY'),
    _TabData(icon: Icons.shield_outlined, label: 'QUICK REF'),
    _TabData(icon: Icons.mic, label: 'IDENTIFY'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: HMColors.divider)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final selected = i == currentIndex;
            final tab = _tabs[i];
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: selected ? HMColors.hazardYellow : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 20,
                        color: selected ? HMColors.hazardYellow : HMColors.dimText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: HMTextStyles.sectionHeader.copyWith(
                          color: selected ? HMColors.hazardYellow : HMColors.dimText,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabData {
  final IconData icon;
  final String label;
  const _TabData({required this.icon, required this.label});
}
