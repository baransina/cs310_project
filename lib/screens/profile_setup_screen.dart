import 'package:flutter/material.dart';
import 'notification_level_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
	const ProfileSetupScreen({
		super.key,
		required this.email,
	});

	final String email;

	@override
	State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
	final _formKey = GlobalKey<FormState>();
	final _nameController = TextEditingController();
	final _majorController = TextEditingController();
	final _courseController = TextEditingController();

	final List<String> _courses = [];
	String? _courseError;

	void _addCourse() {
		final course = _courseController.text
			.trim()
			.toUpperCase()
			.replaceAll(' ', '');

		if (course.isEmpty) {
			setState(() {
				_courseError = 'Enter a course code';
			});
			return;
		}

		if (_courses.contains(course)) {
			setState(() {
				_courseError = 'This course is already added';
			});
			return;
		}

		setState(() {
			_courses.add(course);
			_courseError = null;
		});

		_courseController.clear();
	}

	void _removeCourse(String course) {
		setState(() {
			_courses.remove(course);
		});
	}

	void _continueSetup() {
		if (_formKey.currentState!.validate()) {
			Navigator.push(
				context,
				MaterialPageRoute(
					builder: (context) => NotificationLevelScreen(
						email: widget.email,
						name: _nameController.text.trim(),
						major: _majorController.text.trim(),
						courses: List<String>.from(_courses),
					),
				),
			);
		}
	}

	@override
	void dispose() {
		_nameController.dispose();
		_majorController.dispose();
		_courseController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Set up your profile'),
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(24),
					child: Form(
						key: _formKey,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								const Text(
									'Tell us about yourself',
									style: TextStyle(
										fontSize: 26,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 8),
								Text(widget.email),
								const SizedBox(height: 32),
								TextFormField(
									controller: _nameController,
									decoration: const InputDecoration(
										labelText: 'Full name',
										border: OutlineInputBorder(),
									),
									validator: (value) {
										if (value == null || value.trim().isEmpty) {
											return 'Enter your full name';
										}

										return null;
									},
								),
								const SizedBox(height: 16),
								TextFormField(
									controller: _majorController,
									decoration: const InputDecoration(
										labelText: 'Major',
										hintText: 'Computer Science',
										border: OutlineInputBorder(),
									),
									validator: (value) {
										if (value == null || value.trim().isEmpty) {
											return 'Enter your major';
										}

										return null;
									},
								),
								const SizedBox(height: 24),
								const Text(
									'Enrolled courses',
									style: TextStyle(
										fontSize: 18,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 12),
								TextField(
									controller: _courseController,
									decoration: InputDecoration(
										labelText: 'Course code',
										hintText: 'CS310',
										border: const OutlineInputBorder(),
										errorText: _courseError,
									),
								),
								const SizedBox(height: 8),
								OutlinedButton(
									onPressed: _addCourse,
									child: const Text('Add course'),
								),
								const SizedBox(height: 12),
								Wrap(
									spacing: 8,
									runSpacing: 8,
									children: [
										for (final course in _courses)
											Chip(
												label: Text(course),
												onDeleted: () {
													_removeCourse(course);
												},
											),
									],
								),
								const SizedBox(height: 24),
								ElevatedButton(
									onPressed: _continueSetup,
									child: const Text('Continue'),
								),
							],
						),
					),
				),
			),
		);
	}
}