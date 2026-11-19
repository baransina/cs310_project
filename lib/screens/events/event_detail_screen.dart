import 'package:flutter/material.dart';

import '../../models/study_event.dart';
import '../../theme.dart';
import '../../widgets/common_widgets.dart';

// Screen 11 - Event Detail & RSVP
// Changes the event object directly (join / leave), so the list screen
// only needs setState() when it comes back.
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

  Widget _mainButton() {
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius));

    if (e.isHost) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(shape: shape),
        child: const Text("You're hosting this session"),
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
          // 1 - Who, where, when
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

          // 2 - Seats
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

          // 3 - Join / Group chat
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
