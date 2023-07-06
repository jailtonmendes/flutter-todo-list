// ignore_for_file: avoid_print, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(s);

      // Verificando se já tem login, e retornando o metodo de login criado
      // email-already-exists
      if (e.code == 'email-already-in-use') {
        //Verificando o tipo de login que o usuário se registrou
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message: 'E-mail já utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthException(
              message:
                  'Você se cadastrou no TodoList pelo Google, por favor utilize ele para entrar!!!');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);

      throw AuthException(message: e.message ?? 'Erro ao realiar login');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'wrong-password') {
        throw AuthException(message: 'login ou senha inválidos');
      }
      throw AuthException(message: e.message ?? 'Erro ao realiar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(
            message:
                'Cadastro realizado com o google, não pode ser resetado a senha');
      } else {
        throw AuthException(message: 'E-mail não cadastrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: 'Erro ao resetar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser =
          await googleSignIn.signIn(); //Abertura da janela de login fo google

      if (googleUser != null) {
        //Se usuário fez login googleUser vai ser diferente de null
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(googleUser
            .email); //Verificando se email já está cadastrado e tipo de login.

        if (loginMethods.contains('password')) {
          throw AuthException(
              message:
                  'Você utilizou o e-mail para cadastro no TodoList, caso tenha esquecido sua senha por favor clique no link esqueci minha senha');
        } else {
          final googleAuth =
              await googleUser.authentication; //Realizando login com o google
          final firebaseCredencial = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          var userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredencial);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'account-exists-width-different-credential') {
        throw AuthException(message: ''' 
          Login inválido você se registrou no TodoList com os seguintes provedores:
          ${loginMethods?.join(',')}
        ''');
      } else {
        throw AuthException(message: 'Erro ao realizar login');
      }
    }
    return null;
  }

  @override
  Future<void> googleLogout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }
}
