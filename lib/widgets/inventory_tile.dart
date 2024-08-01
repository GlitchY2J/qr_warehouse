import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/query_page.dart';

class InventoryTile extends StatelessWidget {
  const InventoryTile({
    super.key,
    required this.refreshMovements,
  });

  final VoidCallback refreshMovements;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: const Text("Inventario"),
      onTap: () => {
        Navigator.pop(context),
        Navigator.of(context)
            .push(CupertinoPageRoute(
          builder: (context) => const QueryPage(),
        ))
            .then((value) {
          refreshMovements();
        })
      },
    );
  }
}
