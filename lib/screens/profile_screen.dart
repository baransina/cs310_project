import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
	const ProfileScreen({
		super.key,
		required this.email,
		required this.name,
		required this.major,
		required this.courses,
		required this.nagLevel,
	});

	final String email;
	final String name;
	final String major;
	final List<String> courses;
	final String nagLevel;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Profile'),
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(24),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							const CircleAvatar(
								radius: 40,
								child: Icon(
									Icons.person,
									size: 48,
								),
							),
							const SizedBox(height: 16),
							Text(
								name,
								textAlign: TextAlign.center,
								style: const TextStyle(
									fontSize: 26,
									fontWeight: FontWeight.bold,
								),
							),
							const SizedBox(height: 8),
							Text(
								major,
								textAlign: TextAlign.center,
							),
							const SizedBox(height: 8),
							Text(
								email,
								textAlign: TextAlign.center,
							),
							const SizedBox(height: 32),
							const Text(
								'Enrolled courses',
								style: TextStyle(
									fontSize: 18,
									fontWeight: FontWeight.bold,
								),
							),
							const SizedBox(height: 12),
							if (courses.isEmpty)
								const Text('No courses added'),
							Wrap(
								spacing: 8,
								runSpacing: 8,
								children: [
									for (final course in courses)
										Chip(
											label: Text(course),
										),
								],
							),
							const SizedBox(height: 24),
							const Divider(),
							const SizedBox(height: 16),
							const Text(
								'Notification level',
								style: TextStyle(
									fontSize: 18,
									fontWeight: FontWeight.bold,
								),
							),
							const SizedBox(height: 8),
							Text(nagLevel),
						],
					),
				),
			),
		);
	}
}