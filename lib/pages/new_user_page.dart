import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/models/user.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_form_text_field.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/widgets/show_pin_icon.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  // formKey to validate form
  final formKey = GlobalKey<FormState>();

  // check if user already exists in database
  bool userNameExists = false;
  bool userIdExists = false;

  // is pin visible
  bool pinHidden = true;

  // list of users
  List<User> users = [];

  // Username List
  List<String> userName = [];

  // TEXT CONTROLLERS
  final idController = TextEditingController();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final pinController = TextEditingController();
  final pinConfirmationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // get registered users
    getUsers();
  }

  Future<void> getUsers() async {
    http.Response response = await FormController.getTable('users', '');
    if (response.statusCode == 200) {
      setState(() {
        users = List<User>.from(
          jsonDecode(response.body).map((model) => User.fromJson(model)),
        );
      });
    }
  }

  // inserts user
  void insertUser() async {
    String id = idController.text;
    String username = usernameController.text;
    String pin = pinController.text;
    String fullName = fullNameController.text;
    String userType = "User";

    String values = "'$id', '$username', '$pin', '$fullName', '$userType'";
    Map<String, dynamic> result =
        await FormController.insertRecords("users", values);

    //update users again
    if (result["success"] == "true") {
      getUsers();
      idController.clear();
      usernameController.clear();
      fullNameController.clear();
      pinController.clear();
      pinConfirmationController.clear();
    }

    SnackBar snackBar = SnackBar(
      content: result["success"] == "true"
          ? const Text("Registro Completo.")
          : const Text("El registro no pudo ser completado."),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // validates form
  void validateForm() {
    userNameExists =
        users.any((user) => user.username == usernameController.text);

    userIdExists = users.any((user) => user.id == idController.text);

    if (formKey.currentState!.validate()) {
      // Insert user
      insertUser();
    }
  }

  String? validatePinConfirmation(value) {
    if (value != pinController.text) {
      return 'El PIN no coincide.';
    }
    return null;
  }

  String? validatePin(value) {
    if (value == null || value.isEmpty || value.length < 4) {
      return 'Ingresa un PIN válido.';
    }
    return null;
  }

  String? validateUsername(value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un nombre de usuario válido.';
    } else if (userNameExists) {
      return 'Nombre de usuario ya existente.';
    }
    return null;
  }

  String? validateFullName(value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un nombre de empleado válido.';
    }
    return null;
  }

  String? validateId(value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un número de empleado válido.';
    } else if (userIdExists) {
      return 'Número de empleado ya existente.';
    }
    return null;
  }

  void createUserName(value) {
    setState(() {
      userName = value.split(' ');

      if (userName.length > 1) {
        usernameController.text =
            userName[0][0].toLowerCase() + userName[1].toLowerCase();
      } else if (userName.length == 1) {
        if (userName[0] == '') {
          usernameController.text = '';
        } else {
          usernameController.text = userName[0][0].toLowerCase();
        }
      } else if (userName.isEmpty) {
        usernameController.text = '';
      }
    });
  }

  void inContact(TapDownDetails details) {
    setState(() {
      pinHidden = false;
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      pinHidden = true;
    });
  }

  void cancelContact() {
    setState(() {
      pinHidden = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // screen size variables
    final screenWidth = MediaQuery.of(context).size.width;
    final double desktopPadding = screenWidth * 0.39;
    final double mobilePadding = screenWidth * 0.10;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: screenWidth < 800 ? mobilePadding : desktopPadding,
          ),
          child: Center(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),

                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Creación de Usuario",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),

                      const SizedBox(height: 82),

                      // EMPLOYEE ID
                      CustomFormTextField(
                        controller: idController,
                        hintText: 'Número de Empleado',
                        textInputType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) => validateId(value),
                        onFieldSubmitted: (_) => validateForm(),
                      ),

                      const SizedBox(height: 16),

                      // FULL NAME
                      CustomFormTextField(
                        controller: fullNameController,
                        hintText: 'Nombre Completo',
                        validator: (value) => validateFullName(value),
                        onChanged: (value) => createUserName(value),
                        onFieldSubmitted: (_) => validateForm(),
                      ),
                      const SizedBox(height: 64),

                      // USERNAME
                      CustomFormTextField(
                        controller: usernameController,
                        hintText: 'Nombre de Usuario',
                        enabled: false,
                        validator: (value) => validateUsername(value),
                      ),

                      const SizedBox(height: 16),

                      // PIN
                      CustomFormTextField(
                        controller: pinController,
                        maxLength: 4,
                        obscureText: pinHidden,
                        hintText: 'PIN',
                        textInputType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        suffixIcon: ShowPinIcon(
                          pinHidden: pinHidden,
                          onTapDown: inContact,
                          onTapUp: outContact,
                          onTapCancel: cancelContact,
                        ),
                        interactiveSelection: false,
                        validator: (value) => validatePin(value),
                        onFieldSubmitted: (_) => validateForm(),
                      ),

                      const SizedBox(height: 16),

                      // PIN CONFIRMATION
                      CustomFormTextField(
                        controller: pinConfirmationController,
                        maxLength: 4,
                        obscureText: true,
                        hintText: 'Confirma el PIN',
                        textInputType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        interactiveSelection: false,
                        validator: (value) => validatePinConfirmation(value),
                        onFieldSubmitted: (_) => validateForm(),
                      ),

                      const SizedBox(height: 32),

                      // Generate QR Code
                      CustomIconButton(
                        text: "Crear Usuario",
                        icon: Icons.person,
                        height: 50,
                        width: 400,
                        onPressed: () => validateForm(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
