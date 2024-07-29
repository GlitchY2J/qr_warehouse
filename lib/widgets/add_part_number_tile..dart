import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/inventory_form.dart';

class AddPartNumberTile extends StatelessWidget {
  const AddPartNumberTile({
    super.key,
    required this.getMovements,
  });

  final VoidCallback getMovements;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text("Añadir Número de Parte"),
      onTap: () => {
        Navigator.pop(context),
        Navigator.of(context)
            .push(CupertinoPageRoute(
          builder: (context) => const InventoryFormPage(),
        ))
            .then((value) {
          getMovements();
        })
      },
    );
  }
}
