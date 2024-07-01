import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/bloc/auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
  if (state is FirstTimeLogin) {
    Navigator.pushReplacementNamed(context, '/reset-password');
  } else if (state is StudentAuthenticated) {
    Navigator.pushReplacementNamed(context, '/student');
  } else if (state is CanteenAuthenticated) {
    Navigator.pushReplacementNamed(context, '/canteen');
  } else if (state is AuthStateError) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(state.error)));
  }
},
        builder: (context, state) {
          if (state is AuthStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('All fields are required')),
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                          LoggedInEvent(
                            username: email,
                            password: password,
                          ),
                        );
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reset-email');
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
