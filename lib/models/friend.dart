// Friend model for Screen 12. Friends live in the "users" collection in the plan.

enum FriendStatus { studying, online, offline }

class Friend {
  final String id;
  final String name;
  final String email;
  final FriendStatus status;
  final String statusText;
  final List<String> courses;
  final bool isPending; // request sent, not accepted yet

  const Friend({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.statusText,
    required this.courses,
    this.isPending = false,
  });

  Friend asPending() => Friend(
        id: id,
        name: name,
        email: email,
        status: FriendStatus.offline,
        statusText: 'Friend request sent',
        courses: courses,
        isPending: true,
      );
}

// "Ece Y." -> "EY", "deniz yilmaz" -> "DY"
String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters.isEmpty ? '?' : letters;
}

List<Friend> createDummyFriends() => const [
      Friend(
        id: 'u1',
        name: 'Ece Y.',
        email: 'ece.y@sabanciuniv.edu',
        status: FriendStatus.studying,
        statusText: 'Studying · CS310 at Library',
        courses: ['CS310', 'CS303'],
      ),
      Friend(
        id: 'u2',
        name: 'Can K.',
        email: 'can.k@sabanciuniv.edu',
        status: FriendStatus.online,
        statusText: 'Online',
        courses: ['CS310', 'MATH204'],
      ),
      Friend(
        id: 'u3',
        name: 'Mina A.',
        email: 'mina.a@sabanciuniv.edu',
        status: FriendStatus.offline,
        statusText: 'Last seen 2h ago',
        courses: ['CS303'],
      ),
      Friend(
        id: 'u4',
        name: 'Deniz T.',
        email: 'deniz.t@sabanciuniv.edu',
        status: FriendStatus.studying,
        statusText: 'Studying · CS303 at IC',
        courses: ['CS303', 'SPS102'],
      ),
      Friend(
        id: 'u5',
        name: 'Arda S.',
        email: 'arda.s@sabanciuniv.edu',
        status: FriendStatus.studying,
        statusText: 'Studying · MATH204 at FENS',
        courses: ['MATH204'],
      ),
    ];

// Classmates from the same courses that the user doesn't follow yet.
List<Friend> createSuggestedClassmates() => const [
      Friend(
        id: 's1',
        name: 'Burak E.',
        email: 'burak.e@sabanciuniv.edu',
        status: FriendStatus.online,
        statusText: 'Online',
        courses: ['CS310'],
      ),
      Friend(
        id: 's2',
        name: 'Ayşe K.',
        email: 'ayse.k@sabanciuniv.edu',
        status: FriendStatus.offline,
        statusText: 'Last seen 1d ago',
        courses: ['CS310', 'CS303'],
      ),
      Friend(
        id: 's3',
        name: 'Mert Ç.',
        email: 'mert.c@sabanciuniv.edu',
        status: FriendStatus.offline,
        statusText: 'Last seen 5h ago',
        courses: ['CS310'],
      ),
      Friend(
        id: 's4',
        name: 'Elif N.',
        email: 'elif.n@sabanciuniv.edu',
        status: FriendStatus.studying,
        statusText: 'Studying · CS310 at Library',
        courses: ['CS310', 'MATH204'],
      ),
      Friend(
        id: 's5',
        name: 'Onur T.',
        email: 'onur.t@sabanciuniv.edu',
        status: FriendStatus.online,
        statusText: 'Online',
        courses: ['SPS102'],
      ),
    ];

// For the Home screen: "● 3 friends studying now"
int friendsStudyingNow(List<Friend> friends) =>
    friends.where((f) => f.status == FriendStatus.studying).length;
