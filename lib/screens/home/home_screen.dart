import 'package:flutter/material.dart';
import '../../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var todayTasks = [
  {'id': '1', 'title': 'Project prototype', 'course': 'CS310', 'priority': 'High', 'color': AppColors.red},
  {'id': '2', 'title': 'Quiz 3 revision', 'course': 'CS303', 'priority': 'Medium', 'color': AppColors.orange},
  ];

  void _removeTask(String id) {
    setState(() {
      todayTasks.removeWhere((task) => task['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning,', style: AppText.label),
                      Text(
                        'Deniz',
                        style: AppText.title.copyWith(fontSize: 28),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.page),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C28),
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEXT DEADLINE • CS310 PROJECT',
                        style: AppText.label.copyWith(fontSize: 12, color: AppColors.textGrey)),
                    const SizedBox(height: AppSpacing.sm),
                    const Text('02d 14h 08m',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value: 0.35,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('35% done', style: AppText.small.copyWith(color: AppColors.textGrey)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Today', style: AppText.section),
              const SizedBox(height: AppSpacing.md),
              ...todayTasks.map((task) => Dismissible(
                key: Key(task['id'] as String),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _removeTask(task['id'] as String),
                background: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  elevation: 0,
                  color: AppColors.card,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  shape: appCardShape(),
                  child: ListTile(
                    leading: const Icon(Icons.circle_outlined, color: AppColors.textGrey),
                    title: Text(task['title'] as String, style: AppText.cardTitle),
                    subtitle: Text('${task['course']} • ${task['priority']} priority', style: AppText.small),
                    trailing: Icon(Icons.circle, size: 12, color: task['color'] as Color),
                  ),
                ),
              )),
              const SizedBox(height: AppSpacing.lg),
              Text('Upcoming session', style: AppText.section),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CS310 Focus Session', style: AppText.cardTitle.copyWith(color: AppColors.primary)),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Library F2 • 14:00 • 4/6 seats', style: AppText.small),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radius)),
                      ),
                      onPressed: () {},
                      child: const Text('Going'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
