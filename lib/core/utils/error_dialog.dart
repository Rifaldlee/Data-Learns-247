import 'package:data_learns_247/shared_ui/widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';

class ErrorDialog {
  static void showErrorDialog(
    BuildContext context,
    String message,
    VoidCallback onClose
  ) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialogWidget(
        message: message,
        onClose: onClose,
      ),
      barrierDismissible: false,
    );
  }
}