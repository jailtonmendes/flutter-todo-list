// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    required SuccessVoidCallback succesCallback,
    EverVoidCallback? everCallback,
    ErrorVoidCallback? errordCallback,
  }) {
    changeNotifier.addListener(() {
      if (everCallback != null) {
        everCallback(changeNotifier, this);
      }
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (errordCallback != null) {
          errordCallback(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'Erro interno');
      } else if (changeNotifier.isSuccess) {
        succesCallback(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallback = void Function(
    DefaultChangeNotifier notfier, DefaultListenerNotifier listenerNotifier);

typedef ErrorVoidCallback = void Function(
    DefaultChangeNotifier notfier, DefaultListenerNotifier listenerNotifier);

typedef EverVoidCallback = void Function(
    DefaultChangeNotifier notfier, DefaultListenerNotifier listenerNotifier);
