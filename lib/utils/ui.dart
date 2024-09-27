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
      animType: action == 'confirmation'
          ? QuickAlertAnimType.slideInRight
          : QuickAlertAnimType.slideInLeft,
      barrierDismissible: true,
      confirmBtnText: 'Confirmar',
      confirmBtnColor: const Color(0xFF433D8B),
      customAsset: action == 'confirmation'
          ? 'assets/images/warning.gif'
          : 'assets/images/confirm.gif',
      widget: widget,
      onConfirmBtnTap: () {
        navigator!.pop(context);
        onConfirm();
      },
      title: action == 'confirmation'
          ? 'El balance de este número de parte ha sido actualizado.'
          : '¿Estás seguro que deseas realizar este movimiento?',
      titleColor: Colors.white,
      text: action == "confirmation"
          ? '¿Deseas continuar con este movimiento?'
          : action == "substract"
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
