import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/movement.dart';
import 'package:qr_warehouse/utils/formatters.dart';

class Filters {
  // shows a dialog for filters
  static void movementFilters(String property, BuildContext context,
      List<Movement> selectedMovementList, Function function) async {
    await FilterListDialog.display<Movement>(
      context,
      themeData: FilterListThemeData.raw(
        // Choice Chip theme
        choiceChipTheme: const ChoiceChipThemeData(
          backgroundColor: Color(0xFF433D8B),
          selectedBackgroundColor: Color(0xFFC8ACD6),
          side: BorderSide.none,
        ),

        // Header Theme
        headerTheme: const HeaderThemeData(
          backgroundColor: Color(0xFF17153B),
          searchFieldBackgroundColor: Color(0xFF433D8B),
          closeIconColor: Colors.white,
          searchFieldIconColor: Colors.white,
          searchFieldHintText: "Buscar...",
        ),

        // Control Button Bar Theme
        controlBarButtonTheme: ControlButtonBarThemeData(context,
            backgroundColor: const Color(0xFF433D8B),
            controlButtonTheme: const ControlButtonThemeData(
              primaryButtonBackgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              textStyle: TextStyle(
                color: Colors.white,
              ),
            )),

        borderRadius: 10,
        wrapAlignment: WrapAlignment.start,
        wrapCrossAxisAlignment: WrapCrossAlignment.start,
        wrapSpacing: 10,
        backgroundColor: const Color(0xFF17153B),
      ),
      applyButtonText: "Aplicar",
      resetButtonText: "Reiniciar",
      allButtonText: "Todos",
      selectedItemsText: "selecionados",
      width: 800,
      height: 1000,
      listData: selectedMovementList,
      selectedListData: selectedMovementList,
      choiceChipLabel: (move) => property == "Por Número de Parte"
          ? move!.partNumber
          : property == "Por Usuario"
              ? move!.username
              : property == "Por Movimiento"
                  ? move!.type
                  : property == "Por Orden"
                      ? move!.orderNumber
                      : property == "Por Fecha"
                          ? Formatters.formatDateFromString(move!.dateTime)
                          : null,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (move, query) {
        if (property == "Por Número de Parte") {
          return move.partNumber.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Usuario") {
          return move.username.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Movimiento") {
          return move.type.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Orden") {
          return move.orderNumber.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Fecha") {
          return Formatters.formatDateFromString(move.dateTime)
              .toLowerCase()
              .contains(query.toLowerCase());
        } else {
          return false;
        }
      },
      onApplyButtonClick: (list) {
        function(list);
      },
    );
  }
}
