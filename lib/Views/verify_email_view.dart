import 'package:flutter/material.dart';
import 'package:flutter_application_03/constants/route.dart';
import 'package:flutter_application_03/services/auth/auth_service.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(children: [
        const Text(
            "We've already sent you email verification, please check email."),
        const Text('Resend verification email'),
        TextButton(
          onPressed: () async {
            context.read<AuthBloc>().add(
                  const AuthEventSendEmailVerification(),
                );
          },
          child: const Text('Send emal verification'),
        ),
        TextButton(
          onPressed: () async {
            context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
