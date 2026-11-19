import 'package:flutter/material.dart';
import '../theme.dart';
import 'home/home_screen.dart';
import 'tasks/task_list_screen.dart' show TaskListScreen;
import 'events/event_list_screen.dart';
import 'friends/friends_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
	  super.key,
	  this.email = 'demo@sabanciuniv.edu',
	  this.name = 'Demo Student',
	  this.major = 'Computer Science',
	  this.courses = const ['CS310', 'CS303'],
	  this.nagLevel = 'Normal',
  });

	final String email;
	final String name;
	final String major;
	final List<String> courses;
	final String nagLevel;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int index = 0;
  	List<Widget> get _screens => [
    const HomeScreen(),
    const TaskListScreen(),
    EventListScreen(),
    FriendsScreen(),
    ProfileScreen(
			email: widget.email,
			name: widget.name,
			major: widget.major,
			courses: widget.courses,
			nagLevel: widget.nagLevel,
		),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.check_box_outlined), selectedIcon: Icon(Icons.check_box), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Friends'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
