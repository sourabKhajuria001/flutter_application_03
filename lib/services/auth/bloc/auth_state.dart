import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../auth_user.dart';

// NOTE: Events are INPUT to BLoC  and States  are OUPUT of BLoC

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialize extends AuthState {
  const AuthStateUnInitialize();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

// installed equatable package to implemet equatable. it helps to compare diff states of same class.
// e.g in this case diff cobinations of exception & isLoading
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
