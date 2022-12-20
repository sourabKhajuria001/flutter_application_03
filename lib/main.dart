import 'package:flutter/material.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_event.dart';
import 'package:flutter_application_03/services/auth/bloc/auth_state.dart';
import 'package:flutter_application_03/services/auth/firebase_auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_03/Views/login_view.dart';
import 'package:flutter_application_03/Views/notes/create_update_note_view.dart';
import 'package:flutter_application_03/Views/register_view.dart';
import 'package:flutter_application_03/Views/verify_email_view.dart';
import 'package:flutter_application_03/constants/route.dart';
import 'Views/notes/notes_view.dart';
//   1:03:30:30

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'My Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(), // main UI
        verifyEmailRoute: (context) => const VerifyEmailView(),
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

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
