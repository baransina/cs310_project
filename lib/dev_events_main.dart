import 'package:flutter/material.dart';

import 'screens/events/event_list_screen.dart';
import 'screens/friends/friends_screen.dart';
import 'theme.dart';

// Test entry point for the Events + Friends screens (Screens 09-12).
// Run with:  flutter run -t lib/dev_events_main.dart
// The real app (lib/main.dart) is not changed.
void main() => runApp(const DevEventsApp());

class DevEventsApp extends StatelessWidget {
  const DevEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusConnect (events dev)',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const _DevShell(),
    );
  }
}

class _DevShell extends StatefulWidget {
  const _DevShell();

  @override
  State<_DevShell> createState() => _DevShellState();
}

class _DevShellState extends State<_DevShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's state when switching.
      body: IndexedStack(
        index: index,
        children: const [EventListScreen(), FriendsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Friends'),
        ],
      ),
    );
  }
}
