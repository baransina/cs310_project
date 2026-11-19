import 'package:flutter/material.dart';

import '../../models/study_event.dart';
import '../../theme.dart';
import '../../widgets/common_widgets.dart';
import 'create_event_screen.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final List<StudyEvent> events = createDummyEvents();
  bool showMap = false;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _join(StudyEvent e) {
    final joined = e.join();
    setState(() {});
    _showMessage(joined ? 'You joined ${e.title}' : 'This session is full');
  }

  Future<void> _openDetail(StudyEvent e) async {
    final cancelled = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: e)),
    );
    if (!mounted) return;
    if (cancelled == true) {
      setState(() => events.remove(e));
      _showMessage('Session cancelled: ${e.title}');
      return;
    }
    setState(() {});
  }

  Future<void> _hostSession() async {
    final created = await Navigator.push<StudyEvent>(
      context,
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );
    if (created == null) return;
    setState(() => events.add(created));
    _showMessage('Session created: ${created.title}');
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...events]..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Study events', style: AppText.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.md),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                      value: false,
                      label: Text('List'),
                      icon: Icon(Icons.view_list)),
                  ButtonSegment(
                      value: true, label: Text('Map'), icon: Icon(Icons.map)),
                ],
                selected: {showMap},
                onSelectionChanged: (s) => setState(() => showMap = s.first),
              ),
            ),
          ),
          Expanded(
            child: showMap
                ? const _MapPlaceholder()
                : sorted.isEmpty
                    ? const Center(
                        child: Text('No sessions yet. Host the first one!',
                            style: AppText.small),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.page),
                        itemCount: sorted.length,
                        itemBuilder: (context, i) => EventCard(
                          key: ValueKey(sorted[i].eventId),
                          event: sorted[i],
                          onTap: () => _openDetail(sorted[i]),
                          onJoin: () => _join(sorted[i]),
                        ),
                      ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _hostSession,
                  icon: const Icon(Icons.add),
                  label: const Text('Host a session'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radius),
                    ),
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

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onJoin,
  });

  final StudyEvent event;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  Widget _actionButton() {
    if (event.isHost) {
      return const StatusTag(text: 'Hosting', color: AppColors.primary);
    }
    if (event.isJoined) {
      return const StatusTag(text: 'Going', color: AppColors.green);
    }
    if (event.isFull) {
      return const FilledButton(onPressed: null, child: Text('Full'));
    }
    return FilledButton(
      onPressed: onJoin,
      style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
      child: const Text('Join'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = event;
    return Card(
      elevation: 0,
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: appCardShape(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CourseChip(course: e.courseCode),
                    const SizedBox(height: AppSpacing.sm),
                    Text(e.title, style: AppText.cardTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${e.location} · ${formatDay(e.dateTime)} ${formatTime(e.dateTime)}',
                      style: AppText.small,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            size: 16,
                            color: e.isFull ? AppColors.red : AppColors.textGrey),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${e.seatsTaken}/${e.maxParticipants} seats',
                          style: AppText.small.copyWith(
                              color: e.isFull ? AppColors.red : null),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _actionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, size: 64, color: AppColors.textGrey),
          SizedBox(height: AppSpacing.sm),
          Text('Campus map is coming soon', style: AppText.section),
          SizedBox(height: AppSpacing.xs),
          Text('Use the list view for now.', style: AppText.small),
        ],
      ),
    );
  }
}
