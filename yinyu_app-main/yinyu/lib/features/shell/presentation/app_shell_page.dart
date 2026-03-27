import 'package:flutter/material.dart';

import '../../home/presentation/home_tab_page.dart';
import '../../community/presentation/community_page.dart';
import '../../mall/presentation/mall_page.dart';
import '../../profile/presentation/profile_page.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  int _index = 0;

  final _pages = const [
    HomeTabPage(),
    CommunityPage(),
    MallPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: '首页'),
          NavigationDestination(icon: Icon(Icons.forum_rounded), label: '社区'),
          NavigationDestination(icon: Icon(Icons.storefront_rounded), label: '商城'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: '我的'),
        ],
      ),
    );
  }
}
