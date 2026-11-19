const String currentUserId = 'me';
const String currentUserName = 'Deniz Y.';

const List<String> myCourses = ['CS310', 'CS303', 'MATH204', 'SPS102'];

const List<String> campusLocations = [
  'Library · Floor 1',
  'Library · Floor 2',
  'FENS G032',
  'FENS L045',
  'IC · Room 1',
  'SL Building · 1022',
  'UC · Study Area',
];

const Map<String, String> userNames = {
  'me': 'You',
  'u1': 'Ece Y.',
  'u2': 'Can K.',
  'u3': 'Mina A.',
  'u4': 'Deniz T.',
  'u5': 'Arda S.',
  'u6': 'Zeynep B.',
  'u7': 'Kerem O.',
  'u8': 'Selin D.',
};

String nameOf(String userId) => userNames[userId] ?? 'Student';

enum EventVisibility { friends, course }

class StudyEvent {
  final String eventId;
  final String hostId;
  final String hostName;
  final String title;
  final String courseCode;
  final String location;
  final DateTime dateTime;
  final int durationMinutes;
  final int maxParticipants;
  final EventVisibility visibility;
  final String note;
  final List<String> attendeeIds;

  StudyEvent({
    required this.eventId,
    required this.hostId,
    required this.hostName,
    required this.title,
    required this.courseCode,
    required this.location,
    required this.dateTime,
    required this.durationMinutes,
    required this.maxParticipants,
    this.visibility = EventVisibility.course,
    this.note = '',
    List<String>? attendeeIds,
  }) : attendeeIds = attendeeIds ?? [];

  int get seatsTaken => attendeeIds.length;
  int get freeSeats => maxParticipants - seatsTaken;
  bool get isFull => seatsTaken >= maxParticipants;
  bool get isJoined => attendeeIds.contains(currentUserId);
  bool get isHost => hostId == currentUserId;
  DateTime get endTime => dateTime.add(Duration(minutes: durationMinutes));

  bool join() {
    if (isJoined || isFull) return false;
    attendeeIds.add(currentUserId);
    return true;
  }

  void leave() {
    if (!isHost) attendeeIds.remove(currentUserId);
  }
}

List<StudyEvent> createDummyEvents() {
  final n = DateTime.now();
  int toTuesday = (DateTime.tuesday - n.weekday + 7) % 7;
  if (toTuesday == 0) toTuesday = 7;

  return [
    StudyEvent(
      eventId: 'e1',
      hostId: 'u1',
      hostName: 'Ece Y.',
      title: 'CS310 Focus Session',
      courseCode: 'CS310',
      location: 'Library · Floor 2',
      dateTime: DateTime(n.year, n.month, n.day, 14),
      durationMinutes: 90,
      maxParticipants: 6,
      note: "Bring: laptop, lecture 6 slides. We'll split the prototype screens.",
      attendeeIds: ['u1', 'u2', 'u3', 'u4'],
    ),
    StudyEvent(
      eventId: 'e2',
      hostId: 'u5',
      hostName: 'Arda S.',
      title: 'HW 4 problem solving',
      courseCode: 'MATH204',
      location: 'FENS G032',
      dateTime: DateTime(n.year, n.month, n.day, 17, 30),
      durationMinutes: 60,
      maxParticipants: 8,
      note: 'We will go over problems 1-12 together.',
      attendeeIds: ['u5', 'u6'],
    ),
    StudyEvent(
      eventId: 'e3',
      hostId: 'u7',
      hostName: 'Kerem O.',
      title: 'Quiz 3 review',
      courseCode: 'CS303',
      location: 'IC · Room 1',
      dateTime: DateTime(n.year, n.month, n.day + toTuesday, 19),
      durationMinutes: 120,
      maxParticipants: 6,
      visibility: EventVisibility.friends,
      note: 'Chapters 4 and 5. Bring past quizzes.',
      attendeeIds: ['u7', 'u8', 'u1', 'u2', 'u3', 'u6'],
    ),
  ];
}

StudyEvent? nextJoinedEvent(List<StudyEvent> events) {
  final joined = events
      .where((e) => e.isJoined && e.endTime.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  return joined.isEmpty ? null : joined.first;
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _two(int n) => n.toString().padLeft(2, '0');

String formatTime(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

String formatDay(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = (day.difference(today).inHours / 24).round();
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff > 1 && diff < 7) return _weekdays[d.weekday - 1];
  return '${_months[d.month - 1]} ${d.day}';
}
