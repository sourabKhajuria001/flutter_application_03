import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable //Immutable data constructs are those that cannot be mutated (altered) after they've been initialized.
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  }); // constructor
  //NOTE:  we are creating factory constructor and Initilaising our AuthUser with Firebases user
  //and assigning firebase's emailVerified ONLY  to our AuthUser constructor
  //and not exposing other properties of Firebase Users
  // in video 15:18:11
  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      email: user.email!,
      isEmailVerified: user.emailVerified,
      id: user.uid,
    );
  }
}
