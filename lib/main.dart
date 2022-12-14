import 'package:flutter/material.dart';
import 'package:flutter_application_03/Views/login_view.dart';
import 'package:flutter_application_03/Views/notes/create_update_note_view.dart';
import 'package:flutter_application_03/Views/register_view.dart';
import 'package:flutter_application_03/Views/verify_email_view.dart';
import 'package:flutter_application_03/constants/route.dart';
import 'package:flutter_application_03/services/auth/auth_service.dart';
import 'Views/notes/notes_view.dart';
import 'dart:developer' as devtools show log;
//   1:00:46:33.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'My Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
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
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            devtools.log("logged in user: ${user.toString()}");
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
