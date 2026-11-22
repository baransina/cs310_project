import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
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
	State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
	final _formKey = GlobalKey<FormState>();
	final _nameController = TextEditingController();
	final _majorController = TextEditingController();

	String _name = '';
	String _major = '';
	bool _isEditing = false;

	@override
	void initState() {
		super.initState();
		_name = widget.name;
		_major = widget.major;
	}

	void _startEditing() {
		_nameController.text = _name;
		_majorController.text = _major;

		setState(() {
			_isEditing = true;
		});
	}

	void _cancelEditing() {
		setState(() {
			_isEditing = false;
		});
	}

	void _saveProfile() {
		if (_formKey.currentState!.validate()) {
			setState(() {
				_name = _nameController.text.trim();
				_major = _majorController.text.trim();
				_isEditing = false;
			});
		}
	}

	@override
	void dispose() {
		_nameController.dispose();
		_majorController.dispose();
		super.dispose();
	}

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
								backgroundImage: AssetImage(
									'assets/images/profile_avatar.png',
								),
							),
							const SizedBox(height: 16),
							Text(
								_name,
								textAlign: TextAlign.center,
								style: const TextStyle(
									fontSize: 26,
									fontWeight: FontWeight.bold,
								),
							),
							const SizedBox(height: 8),
							Text(
								_major,
								textAlign: TextAlign.center,
							),
							const SizedBox(height: 8),
							Text(
								widget.email,
								textAlign: TextAlign.center,
							),
							const SizedBox(height: 24),
							if (_isEditing)
								Form(
									key: _formKey,
									child: Column(
										crossAxisAlignment:
											CrossAxisAlignment.stretch,
										children: [
											TextFormField(
												controller: _nameController,
												decoration: const InputDecoration(
													labelText: 'Full name',
													border: OutlineInputBorder(),
												),
												validator: (value) {
													if (value == null ||
														value.trim().isEmpty) {
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
													border: OutlineInputBorder(),
												),
												validator: (value) {
													if (value == null ||
														value.trim().isEmpty) {
														return 'Enter your major';
													}

													return null;
												},
											),
											const SizedBox(height: 16),
											ElevatedButton(
												onPressed: _saveProfile,
												child: const Text('Save'),
											),
											TextButton(
												onPressed: _cancelEditing,
												child: const Text('Cancel'),
											),
										],
									),
								),
							if (!_isEditing)
								OutlinedButton(
									onPressed: _startEditing,
									child: const Text('Edit profile'),
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
							if (widget.courses.isEmpty)
								const Text('No courses added'),
							Wrap(
								spacing: 8,
								runSpacing: 8,
								children: [
									for (final course in widget.courses)
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
							Text(widget.nagLevel),
						],
					),
				),
			),
		);
	}
}