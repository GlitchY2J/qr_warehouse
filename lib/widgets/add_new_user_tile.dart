import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/new_user_page.dart';

class AddNewUserTile extends StatelessWidget {
  const AddNewUserTile({
    super.key,
    required this.getMovements,
  });

  final VoidCallback getMovements;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text("Añadir Nuevo Usuario"),
      onTap: () => {
        Navigator.pop(context),
        Navigator.of(context)
            .push(CupertinoPageRoute(
          builder: (context) => const NewUserPage(),
        ))
            .then((value) {
          getMovements();
        })
      },
    );
  }
}
