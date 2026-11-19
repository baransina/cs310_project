import 'package:flutter/material.dart';

import '../../models/friend.dart';
import '../../models/study_event.dart' show myCourses;
import '../../theme.dart';
import '../../widgets/common_widgets.dart';

// Screen 12 - Friends
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final List<Friend> friends = [...createDummyFriends()];
  final List<Friend> suggestions = [...createSuggestedClassmates()];
  String query = '';

  static const _statusOrder = {
    FriendStatus.studying: 0,
    FriendStatus.online: 1,
    FriendStatus.offline: 2,
  };

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  List<Friend> get _visibleFriends {
    final q = query.trim().toLowerCase();
    final list = friends
        .where((f) =>
            q.isEmpty ||
            f.name.toLowerCase().contains(q) ||
            f.email.toLowerCase().contains(q))
        .toList();
    list.sort((a, b) {
      if (a.isPending != b.isPending) return a.isPending ? 1 : -1;
      return _statusOrder[a.status]!.compareTo(_statusOrder[b.status]!);
    });
    return list;
  }

  void _follow(Friend s) {
    setState(() {
      suggestions.remove(s);
      friends.add(s.asPending());
    });
    _showMessage('Friend request sent to ${s.name}');
  }

  // ---- Add friend dialog ----

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    return local
        .split(RegExp(r'[._]'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }

  String? _validateFriendInput(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter a name or university email';
    if (v.contains('@') && !v.toLowerCase().endsWith('@sabanciuniv.edu')) {
      return 'Only @sabanciuniv.edu emails';
    }
    final exists = friends.any((f) =>
        f.email.toLowerCase() == v.toLowerCase() ||
        f.name.toLowerCase() == v.toLowerCase());
    if (exists) return 'Already in your friends list';
    return null;
  }

  Future<void> _openAddFriend() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final input = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add friend'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Name or university email',
              hintText: 'name.surname@sabanciuniv.edu',
            ),
            validator: _validateFriendInput,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Send request'),
          ),
        ],
      ),
    );

    if (input == null) return;
    final isEmail = input.contains('@');
    final friend = Friend(
      id: 'f${DateTime.now().millisecondsSinceEpoch}',
      name: isEmail ? _nameFromEmail(input) : input,
      email: isEmail ? input.toLowerCase() : '',
      status: FriendStatus.offline,
      statusText: 'Friend request sent',
      courses: const [],
      isPending: true,
    );
    setState(() => friends.add(friend));
    _showMessage('Friend request sent to ${friend.name}');
  }

  // ---- Same courses bottom sheet ----

  void _openSuggestions(String course) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final list =
              suggestions.where((s) => s.courses.contains(course)).toList();
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, 0, AppSpacing.page, AppSpacing.lg),
              children: [
                Text('$course classmates', style: AppText.section),
                const SizedBox(height: AppSpacing.sm),
                if (list.isEmpty)
                  const Text('You follow everyone in this course.',
                      style: AppText.small),
                for (final s in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: PersonAvatar(name: s.name),
                    title: Text(s.name, style: AppText.cardTitle),
                    subtitle: Text(s.courses.join(' · '), style: AppText.small),
                    trailing: FilledButton.tonal(
                      onPressed: () {
                        _follow(s);
                        setSheetState(() {});
                      },
                      child: const Text('Follow'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleFriends;
    final courseCounts = {
      for (final c in myCourses)
        c: suggestions.where((s) => s.courses.contains(c)).length,
    }..removeWhere((_, count) => count == 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Friends', style: AppText.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.md),
              children: [
                // Search
                TextField(
                  onChanged: (v) => setState(() => query = v),
                  decoration: appInputDecoration(
                    hint: 'Search classmates',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 1 - Live status
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text('No friends match "$query"',
                        textAlign: TextAlign.center, style: AppText.small),
                  ),
                for (final f in visible) FriendTile(friend: f),

                // 2 - Same courses
                if (courseCounts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Text('Same courses', style: AppText.section),
                  const SizedBox(height: AppSpacing.sm),
                  for (final entry in courseCounts.entries)
                    Card(
                      elevation: 0,
                      color: AppColors.card,
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      shape: appCardShape(),
                      child: ListTile(
                        onTap: () => _openSuggestions(entry.key),
                        leading: const Icon(Icons.group_add_outlined,
                            color: AppColors.primary),
                        title: Text(
                          '${entry.key} · ${entry.value} '
                          '${entry.value == 1 ? 'classmate' : 'classmates'} '
                          "you don't follow yet",
                          style: AppText.body,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                ],
              ],
            ),
          ),

          // 3 - Add friend
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _openAddFriend,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add friend'),
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

class FriendTile extends StatelessWidget {
  const FriendTile({super.key, required this.friend});
  final Friend friend;

  (String, Color) get _tag {
    if (friend.isPending) return ('Pending', AppColors.orange);
    switch (friend.status) {
      case FriendStatus.studying:
        return ('Studying', AppColors.green);
      case FriendStatus.online:
        return ('Online', AppColors.primary);
      case FriendStatus.offline:
        return ('Offline', AppColors.textGrey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (text, color) = _tag;
    return Card(
      elevation: 0,
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: appCardShape(),
      child: ListTile(
        leading: PersonAvatar(name: friend.name),
        title: Text(friend.name, style: AppText.cardTitle),
        subtitle: Text(friend.statusText, style: AppText.small),
        trailing: StatusTag(text: text, color: color),
      ),
    );
  }
}
