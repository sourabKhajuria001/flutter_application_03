import 'package:flutter/material.dart';
import 'package:flutter_application_03/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We have now sent you password reset email.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
