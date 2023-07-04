// ignore_for_file: avoid_print

import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessages;

  LoginController({required UserService userService})
      : _userService = userService;

  bool get hasInfo => infoMessages != null;

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      infoMessages = null;
      notifyListeners();
      final user = await _userService.login(email, password);

      if (user != null) {
        success();
      } else {
        setError('Usuário ou senha inválidos');
      }
    } on AuthException catch (e) {
      setError(e.message);
      print(e);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      infoMessages = null;
      notifyListeners();
      await _userService.forgotPassword(email);
      infoMessages = 'Resete de senha enviado para seu e-mail';
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError('Error ao resetar senha');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
