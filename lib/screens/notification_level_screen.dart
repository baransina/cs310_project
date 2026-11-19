import 'package:flutter/material.dart';
import 'root_screen.dart';

class NotificationLevelScreen extends StatefulWidget {
	const NotificationLevelScreen({
		super.key,
		required this.email,
		required this.name,
		required this.major,
		required this.courses,
	});

	final String email;
	final String name;
	final String major;
	final List<String> courses;

	@override
	State<NotificationLevelScreen> createState() =>
		_NotificationLevelScreenState();
}

class _NotificationLevelScreenState
	extends State<NotificationLevelScreen> {
	final List<String> _levels = [
		'Calm',
		'Normal',
		'Harassment',
	];

	String _selectedLevel = 'Normal';

	String _description(String level) {
		if (level == 'Calm') {
			return 'Gentle reminder one day before.';
		}

		if (level == 'Normal') {
			return 'Daily nudges as deadlines get closer.';
		}

		return 'Frequent reminders as deadlines approach.';
	}

	void _finishSetup() {
		Navigator.pushAndRemoveUntil(
			context,
			MaterialPageRoute(
				builder: (context) => RootScreen(
					email: widget.email,
					name: widget.name,
					major: widget.major,
					courses: widget.courses,
					nagLevel: _selectedLevel,
				),
			),
			(route) => false,
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Notification level'),
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(24),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							const Text(
								'Pick your nag level',
								style: TextStyle(
									fontSize: 26,
									fontWeight: FontWeight.bold,
								),
							),
							const SizedBox(height: 8),
							const Text(
								'Choose how often you want reminders.',
							),
							const SizedBox(height: 24),
							for (final level in _levels)
								Padding(
									padding: const EdgeInsets.only(bottom: 12),
									child: OutlinedButton(
										onPressed: () {
											setState(() {
												_selectedLevel = level;
											});
										},
										child: Padding(
											padding: const EdgeInsets.all(16),
											child: Column(
												crossAxisAlignment:
													CrossAxisAlignment.stretch,
												children: [
													Text(
														level,
														style: const TextStyle(
															fontSize: 18,
															fontWeight: FontWeight.bold,
														),
													),
													const SizedBox(height: 8),
													Text(_description(level)),
													if (_selectedLevel == level)
														const Padding(
															padding: EdgeInsets.only(top: 8),
															child: Icon(Icons.check_circle),
														),
												],
											),
										),
									),
								),
							const SizedBox(height: 16),
							ElevatedButton(
								onPressed: _finishSetup,
								child: const Text('Finish setup'),
							),
						],
					),
				),
			),
		);
	}
}