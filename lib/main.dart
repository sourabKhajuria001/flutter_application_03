import 'package:flutter/material.dart';
import 'package:flutter_application_03/Views/forgot_password_view.dart';
import 'package:flutter_application_03/Views/register_view.dart';
import 'package:flutter_application_03/helpers/loading/loading_screen.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_event.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_state.dart';
import 'package:flutter_application_03/services/auth/firebase_auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_03/Views/login_view.dart';
import 'package:flutter_application_03/Views/notes/create_update_note_view.dart';
import 'package:flutter_application_03/Views/verify_email_view.dart';
import 'package:flutter_application_03/constants/route.dart';
import 'Views/notes/notes_view.dart';
//   1:09:02:02

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'My Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait',
          );
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
