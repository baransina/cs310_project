import 'package:flutter/material.dart';

import '../../models/study_event.dart';
import '../../theme.dart';
import '../../widgets/common_widgets.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.event});
  final StudyEvent event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  StudyEvent get e => widget.event;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _join() {
    final ok = e.join();
    setState(() {});
    _showMessage(ok ? "You're in! See you there." : 'This session is full');
  }

  void _leave() {
    setState(() => e.leave());
    _showMessage('You left ${e.title}');
  }

  Future<void> _cancelSession() async {
    final others = e.seatsTaken - 1;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this session?'),
        content: Text(others > 0
            ? '$others ${others == 1 ? 'person has' : 'people have'} joined. '
                'They will be notified that the session is cancelled.'
            : 'The session will be removed from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Cancel session'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  Widget _mainButton() {
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius));

    if (e.isHost) {
      return OutlinedButton(
        onPressed: _cancelSession,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: const BorderSide(color: AppColors.red),
          shape: shape,
        ),
        child: const Text('Cancel session'),
      );
    }
    if (e.isJoined) {
      return OutlinedButton(
        onPressed: _leave,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: const BorderSide(color: AppColors.red),
          shape: shape,
        ),
        child: const Text('Leave session'),
      );
    }
    return FilledButton(
      onPressed: e.isFull ? null : _join,
      style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary, shape: shape),
      child: Text(e.isFull ? 'Session is full' : 'Join session'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibilityText = e.visibility == EventVisibility.friends
        ? 'Visible to friends'
        : 'Open to everyone in ${e.courseCode}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Events', style: AppText.section),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.lg),
        children: [
          Text(
            e.location.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(e.title, style: AppText.title),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${formatDay(e.dateTime)} · ${formatTime(e.dateTime)} – ${formatTime(e.endTime)}',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(e.isHost ? 'Hosted by you' : 'Hosted by ${e.hostName}',
              style: AppText.small),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              CourseChip(course: e.courseCode),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: Text(visibilityText, style: AppText.small)),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Text('Participants', style: AppText.section),
              const Spacer(),
              Text('${e.seatsTaken} of ${e.maxParticipants} seats',
                  style: AppText.small.copyWith(
                      color: e.isFull ? AppColors.red : null)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: LinearProgressIndicator(
              value: e.seatsTaken / e.maxParticipants,
              minHeight: 6,
              backgroundColor: AppColors.border,
              color: e.isFull ? AppColors.red : AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              for (final id in e.attendeeIds)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PersonAvatar(name: id == currentUserId ? currentUserName : nameOf(id)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(nameOf(id), style: AppText.small),
                  ],
                ),
            ],
          ),

          if (e.note.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(e.note, style: AppText.body),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          SizedBox(height: 50, child: _mainButton()),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () =>
                _showMessage('Group chat is an optional feature, coming soon'),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Open group chat'),
          ),
        ],
      ),
    );
  }
}
