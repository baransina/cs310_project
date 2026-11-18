import 'package:flutter/material.dart';

void main() => runApp(const CampusConnectApp());

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusConnect',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const TaskListScreen(),
    );
  }
}

class Task {
  final String id, title, courseCode, type, priority, description;
  final DateTime dueDate;
  final bool isCompleted;
  final int progress;

  Task({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.type,
    required this.priority,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.progress = 0,
  });

  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(dueDate.year, dueDate.month, dueDate.day)
        .difference(today)
        .inDays;
  }

}

final List<String> userCourses = ['CS310', 'CS303', 'MATH204', 'SPS102'];

List<Task> createDummyTasks() {
  final n = DateTime.now();
  return [
    Task(id: 't1', title: 'Project prototype', courseCode: 'CS310',
        type: 'Project', priority: 'High',
        description: 'Login, task list and event feed screens in Flutter.',
        dueDate: DateTime(n.year, n.month, n.day + 2, 18), progress: 35),
    Task(id: 't2', title: 'Quiz 3', courseCode: 'CS303', type: 'Exam',
        priority: 'Medium', description: 'Chapters 4 and 5.',
        dueDate: DateTime(n.year, n.month, n.day + 6, 10)),
    Task(id: 't3', title: 'Homework 4', courseCode: 'MATH204',
        type: 'Assignment', priority: 'Low',
        description: 'Problems 1-12 from the textbook.',
        dueDate: DateTime(n.year, n.month, n.day + 12, 23)),
    Task(id: 't4', title: 'Reflection essay', courseCode: 'SPS102',
        type: 'Assignment', priority: 'Medium',
        description: '500 words about the field trip.',
        dueDate: DateTime(n.year, n.month, n.day - 1, 23),
        isCompleted: true, progress: 100),
  ];
}

class AppColors {
  static const Color primary = Color(0xFF3D5AFE);
  static const Color background = Color(0xFFF6F7FB);
  static const Color card = Colors.white;
  static const Color textDark = Color(0xFF1C1C28);
  static const Color textGrey = Color(0xFF7A7A8C);
  static const Color border = Color(0xFFE2E3EC);
  static const Color red = Color(0xFFE53935);
  static const Color orange = Color(0xFFFB8C00);
  static const Color green = Color(0xFF43A047);

  static Color priority(String p) =>
      p == 'High' ? red : (p == 'Medium' ? orange : green);

  static Color due(int days) => days < 3 ? red : (days < 7 ? orange : green);
}

class AppText {
  static const TextStyle title = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const TextStyle section = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const TextStyle label = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textGrey);
  static const TextStyle cardTitle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const TextStyle small = TextStyle(fontSize: 13, color: AppColors.textGrey);
  static const TextStyle body =
      TextStyle(fontSize: 15, color: AppColors.textDark, height: 1.4);
  static const TextStyle error = TextStyle(fontSize: 12, color: AppColors.red);
}

class AppSpacing {
  static const double xs = 4, sm = 8, md = 16, lg = 24;
  static const double page = 20, radius = 14;
}

String daysLeftText(int days) {
  if (days < 0) return 'Overdue';
  if (days == 0) return 'Today';
  return days == 1 ? '1 day' : '$days days';
}

class OptionGroup extends StatelessWidget {
  const OptionGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<String> options;
  final String? selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in options)
          ElevatedButton(
            onPressed: () => onSelect(option),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  option == selected ? AppColors.primary : AppColors.card,
              foregroundColor:
                  option == selected ? Colors.white : AppColors.textDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
            child: Text(option),
          ),
      ],
    );
  }
}

class DueTag extends StatelessWidget {
  const DueTag({super.key, required this.daysLeft});
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.due(daysLeft);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(daysLeftText(daysLeft),
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  final Task task;
  final void Function() onTap;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final done = task.isCompleted;
    return Card(
      elevation: 0,
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: done
            ? const Icon(Icons.check_circle, color: AppColors.green)
            : Icon(Icons.circle, size: 12,
                color: AppColors.priority(task.priority)),
        title: Text(task.title,
            style: done
                ? AppText.cardTitle.copyWith(color: AppColors.textGrey)
                : AppText.cardTitle),
        subtitle: Text(
          done
              ? task.courseCode
              : '${task.courseCode} · ${task.type} · ${task.priority}',
          style: AppText.small,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!done) DueTag(daysLeft: task.daysLeft),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = createDummyTasks();
  String filter = 'All';

  void addTask(Task t) => setState(() => tasks = [...tasks, t]);

  void removeTask(Task t) =>
      setState(() => tasks = tasks.where((x) => x.id != t.id).toList());

  Widget card(Task t) => TaskCard(
        key: ValueKey(t.id),
        task: t,
        onTap: () {},
        onDelete: () => removeTask(t),
      );

  @override
  Widget build(BuildContext context) {
    final visible = filter == 'All'
        ? tasks
        : tasks.where((t) => t.courseCode == filter).toList();
    final active = visible.where((t) => !t.isCompleted).toList();
    active.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final completed = visible.where((t) => t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Tasks', style: AppText.title),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.page, AppSpacing.sm, AppSpacing.page, 80),
        children: [
          OptionGroup(
            options: ['All', ...userCourses],
            selected: filter,
            onSelect: (f) => setState(() => filter = f),
          ),
          const SizedBox(height: AppSpacing.md),
          if (active.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('No tasks here. Tap + to add one.',
                  textAlign: TextAlign.center, style: AppText.small),
            ),
          for (final t in active) card(t),
          if (completed.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('Completed (${completed.length})',
                  style: AppText.section),
            ),
          for (final t in completed) card(t),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
