// Todas as controllers vão estender essa classe
import 'package:flutter/cupertino.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  bool _success = false;

  bool get loading => _loading;
  String? get error => _error;
  bool get hasError => error != null;
  bool get isSuccess => _success;

  void showLoading() => _loading = true;
  void hideLoading() => _loading = false;
  void success() => _success = true;
  void setError(String? error) => _error = error;

  //Metódo para resetar valores
  void showLoadingAndResetState() {
    showLoading();
    resetState();
  }

  void resetState() {
    setError(null);
    _success = false;
  }
}
