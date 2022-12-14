import 'package:flutter_application_03/services/auth/auth_exceptions.dart';
import 'package:flutter_application_03/services/auth/auth_provider.dart';
import 'package:flutter_application_03/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to beginwith', () {
      expect(provider.isInilialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able be initialized to beginwith', () async {
      await provider.initialize();
      expect(provider.isInilialized, true);
    });

    test('USer Should  be null after  initialized', () {
      expect(provider.currentUser, null);
    });

    test('Should not be initialized to beginwith', () {
      expect(provider.isInilialized, false);
    });

    test(
      'Should   be able to initialized in less that 2 Seconds',
      () async {
        await provider.initialize();
        expect(provider.isInilialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create  User should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: "xxx@gmail.com",
        password: "anyPasword",
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPAsswordlUser = provider.createUser(
        email: "anyEmail@gmail.com",
        password: "xxxx",
      );
      expect(badPAsswordlUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "anyEmail@gmail.com",
        password: "anyPAssword",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('login user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to  logout & login again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitiliazed = false;
  bool get isInilialized => _isInitiliazed;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInilialized) throw NotInitializedException();

    await Future.delayed(const Duration(seconds: 1));

    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitiliazed = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInilialized) throw NotInitializedException();
    if (email == "xxx@gmail.com") throw UserNotFoundAuthException();
    if (password == "xxxx") throw WrongPasswordAuthException();

    const user = AuthUser(
        isEmailVerified: false, email: 'testCaseUser@gmail.com', id: 'myID');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInilialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInilialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
        isEmailVerified: true, email: 'testCaseUser@gmail.com', id: 'myId');
    _user = newUser;
  }
}
