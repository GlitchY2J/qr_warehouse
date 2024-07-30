import 'package:flutter/material.dart';
import 'package:qr_warehouse/widgets/custom_button.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.height,
    this.itemCount,
    required this.values,
    required this.filters,
    required this.field,
    required this.isValidFilter,
    required this.toggleFilter,
    required this.applyFiltersAndUpdate,
  });

  final double height;
  final int? itemCount;
  final List<String> values;
  final Map<String, List<String>> filters;
  final String field;
  final Function(String, String) isValidFilter;
  final Function(String, String) toggleFilter;
  final VoidCallback applyFiltersAndUpdate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        String value = values[index];
                        return CheckboxListTile(
                          title: Text(value),
                          value: filters[field]!.contains(value),
                          onChanged: isValidFilter(field, value)
                              ? (checked) {
                                  {
                                    setState(() {
                                      toggleFilter(field, value);
                                    });
                                  }
                                }
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
                flex: 0,
                child: CustomButton(
                    onTap: () {
                      applyFiltersAndUpdate();
                      Navigator.pop(context);
                    },
                    text: "Aplicar"))
          ],
        ),
      ),
    );
  }
}
