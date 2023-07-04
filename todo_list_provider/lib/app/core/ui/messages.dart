import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/theme_Extensions.dart';

class Messages {
  final BuildContext context;

  // Construtor Privado
  Messages._(this.context);

  // Construtor do tipo: Factory - recebendo o context
  factory Messages.of(BuildContext context) {
    // retornando o Messages
    return Messages._(context);
  }

  void showError(String message) => _showMessage(message, Colors.red);

  void showInfo(String message) => _showMessage(message, context.primaryColor);

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
