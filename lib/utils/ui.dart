import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class Ui {
  static void showWidgetAlert(BuildContext context, Widget widget,
      VoidCallback onConfirm, String action) {
    QuickAlert.show(
      backgroundColor: const Color(0xFF17153B),
      width: 600,
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Confirmar',
      confirmBtnColor: const Color(0xFF433D8B),
      customAsset: 'assets/images/confirmation.gif',
      widget: widget,
      onConfirmBtnTap: () {
        navigator!.pop(context);
        onConfirm();
      },
      title: '¿Estás seguro que deseas realizar este movimiento?',
      titleColor: Colors.white,
      text: action == "substract"
          ? 'Salida de Inventario'
          : 'Entrada de Inventario',
      textColor: Colors.white,
    );
  }

  static void showSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }
}
