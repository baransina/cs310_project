import 'package:flutter/material.dart';
import 'profile_setup_screen.dart';

class SignUpScreen extends StatefulWidget {
	const SignUpScreen({super.key});

	@override
	State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
	final _formKey = GlobalKey<FormState>();
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();
	final _confirmPasswordController = TextEditingController();

	bool _hidePassword = true;

	void _createAccount() {
		if (_formKey.currentState!.validate()) {
			showDialog(
				context: context,
				builder: (dialogContext) {
					return AlertDialog(
						title: const Text('Information checked'),
						content: const Text(
							'Your details are valid. This is a UI demo; '
							'account creation will be connected in Step 3.',
						),
						actions: [
							TextButton(
								onPressed: () {
									Navigator.pop(dialogContext);

									Navigator.push(
										context,
										MaterialPageRoute(
											builder: (context) => ProfileSetupScreen(
												email: _emailController.text.trim(),
											),
										),
									);
								},
								child: const Text('Continue'),
							),
						],
					);
				},
			);
		}
	}

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		_confirmPasswordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Create account'),
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
									'Join CampusConnect',
									style: TextStyle(
										fontSize: 26,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 8),
								const Text('Use your university email to get started.'),
								const SizedBox(height: 32),
								TextFormField(
									controller: _emailController,
									keyboardType: TextInputType.emailAddress,
									decoration: const InputDecoration(
										labelText: 'University email',
										hintText: 'name@sabanciuniv.edu',
										border: OutlineInputBorder(),
									),
									validator: (value) {
										final email = value?.trim() ?? '';

										if (email.isEmpty) {
											return 'Enter your university email';
										}

										final parts = email.split('@');

										if (parts.length != 2 ||
											parts[0].trim().isEmpty ||
											parts[1].toLowerCase() != 'sabanciuniv.edu' ||
											email.contains(' ')) {
											return 'Use your @sabanciuniv.edu email';
										}

										return null;
									},
								),
								const SizedBox(height: 16),
								TextFormField(
									controller: _passwordController,
									obscureText: _hidePassword,
									decoration: InputDecoration(
										labelText: 'Password',
										border: const OutlineInputBorder(),
										suffixIcon: IconButton(
											icon: Icon(
												_hidePassword
													? Icons.visibility
													: Icons.visibility_off,
											),
											onPressed: () {
												setState(() {
													_hidePassword = !_hidePassword;
												});
											},
										),
									),
									validator: (value) {
										if (value == null || value.trim().isEmpty) {
											return 'Enter your password';
										}

										return null;
									},
								),
								const SizedBox(height: 16),
								TextFormField(
									controller: _confirmPasswordController,
									obscureText: _hidePassword,
									decoration: const InputDecoration(
										labelText: 'Confirm password',
										border: OutlineInputBorder(),
									),
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Confirm your password';
										}

										if (value != _passwordController.text) {
											return 'Passwords do not match';
										}

										return null;
									},
								),
								const SizedBox(height: 24),
								ElevatedButton(
									onPressed: _createAccount,
									child: const Text('Create account'),
								),
							],
						),
					),
				),
			),
		);
	}
}