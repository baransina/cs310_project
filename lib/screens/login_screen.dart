import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'root_screen.dart';

class LoginScreen extends StatefulWidget {
	const LoginScreen({super.key});

	@override
	State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _formKey = GlobalKey<FormState>();
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();

	bool _hidePassword = true;

	void _signIn() {
		if (_formKey.currentState!.validate()) {
			Navigator.pushAndRemoveUntil(
				context,
				MaterialPageRoute(
					builder: (context) => RootScreen(
						email: _emailController.text.trim(),
					),
				),
				(route) => false,
			);
		}
	}

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(24),
					child: Form(
						key: _formKey,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								const SizedBox(height: 48),
								const Icon(
									Icons.school,
									size: 64,
								),
								const SizedBox(height: 16),
								const Text(
									'CampusConnect',
									textAlign: TextAlign.center,
									style: TextStyle(
										fontSize: 30,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 8),
								const Text(
									'Deadlines and study groups, in one place.',
									textAlign: TextAlign.center,
								),
								const SizedBox(height: 40),
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
								const SizedBox(height: 24),
								ElevatedButton(
									onPressed: _signIn,
									child: const Text('Sign in'),
								),
								const SizedBox(height: 8),
								TextButton(
									onPressed: () {
										Navigator.push(
											context,
											MaterialPageRoute(
												builder: (context) => const SignUpScreen(),
											),
										);
									},
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