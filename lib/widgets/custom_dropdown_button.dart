import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/widgets/custom_bottom_sheet.dart';

class CustomDropDownButton extends StatefulWidget {
  const CustomDropDownButton({
    super.key,
    required this.filters,
    required this.height,
    required this.menuFilters,
    required this.isValidFilter,
    required this.toggleFilter,
    required this.applyFiltersAndUpdate,
    required this.uniques,
    this.top,
    this.left,
  });

  final double? top;
  final double? left;
  final List<String> menuFilters;
  final double height;
  final Map<String, List<String>> filters;
  final Function(String, String) isValidFilter;
  final Function(String, String) toggleFilter;
  final VoidCallback applyFiltersAndUpdate;
  final Map<String, List<String>> uniques;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  // get number of items in bottom sheet
  int getItemCount(String filterSelected) {
    switch (filterSelected) {
      case "Por Número de Parte":
        return widget.uniques['partNumber']!.length;
      case "Por Usuario":
        return widget.uniques['username']!.length;
      case "Por Movimiento":
        return widget.uniques['type']!.length;
      case "Por Número de Orden":
        return widget.uniques['orderNumber']!.length;
      default:
        return 0;
    }
  }

  // get values to filter
  List<String> getValues(String filterSelected) {
    switch (filterSelected) {
      case "Por Número de Parte":
        return widget.uniques['partNumber']!.toList();
      case "Por Usuario":
        return widget.uniques['username']!.toList();
      case "Por Movimiento":
        return widget.uniques['type']!.toList();
      case "Por Número de Orden":
        return widget.uniques['orderNumber']!.toList();
      default:
        return [];
    }
  }

  // get values to filter
  String getField(String filterSelected) {
    switch (filterSelected) {
      case "Por Número de Parte":
        return 'partNumber';
      case "Por Usuario":
        return 'username';
      case "Por Movimiento":
        return 'type';
      case "Por Número de Orden":
        return 'orderNumber';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String? selectedFilter;

    return Positioned(
      top: widget.top,
      left: widget.left,
      child: SizedBox(
        width: 250,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: const Row(
              children: [
                Icon(
                  Icons.filter_alt,
                  size: 16,
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Filtrar...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: widget.menuFilters
                .map((String filter) => DropdownMenuItem<String>(
                      value: filter,
                      child: Text(
                        filter,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: selectedFilter,
            onChanged: (String? value) {
              //movementFilters(value);
              setState(() {
                selectedFilter = value;

                // show bottom sheet
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    int itemCount = getItemCount(value!);
                    List<String> values = getValues(value);
                    String field = getField(value);

                    // custom widget
                    return CustomBottomSheet(
                      height: widget.height,
                      itemCount: itemCount,
                      values: values,
                      filters: widget.filters,
                      field: field,
                      isValidFilter: widget.isValidFilter,
                      toggleFilter: widget.toggleFilter,
                      applyFiltersAndUpdate: widget.applyFiltersAndUpdate,
                    );
                  },
                );
              });
            },

            // Button Style
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: 160,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF433D8B),
              ),
            ),

            // Dropdown Style
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF433D8B),
              ),
              offset: const Offset(100, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            // Menu Item Style
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ),
    );
  }
}
