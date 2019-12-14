
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/App.dart';

class ShowFirebaseMessageUsecase {
  final _notificationRepository = dependencies.notificationRepository;

  void invoke(BuildContext context, Map<String, dynamic> message) {
    _notificationRepository.showFirebaseMessage(context, message);
  }
}