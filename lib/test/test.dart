import 'package:flutter/material.dart';

class Movement {
  final String partNumber;
  final String description;
  final String type;
  final String quantity;
  final String username;
  final String dateTime;
  final String orderNumber;

  Movement({
    required this.partNumber,
    required this.description,
    required this.type,
    required this.quantity,
    required this.username,
    required this.dateTime,
    required this.orderNumber,
  });
}

class PersonFilterScreen extends StatefulWidget {
  const PersonFilterScreen({super.key});

  @override
  State<PersonFilterScreen> createState() => _PersonFilterScreenState();
}

class _PersonFilterScreenState extends State<PersonFilterScreen> {
  List<Movement> getMovements() {
    return [
      Movement(
          partNumber: '00-00-1234-00',
          description: 'description',
          type: 'Salida',
          quantity: '32',
          username: 'jguerra',
          dateTime: '2024-07-23 15:04',
          orderNumber: '4657'),
      Movement(
          partNumber: '00-00-4321-00',
          description: 'description',
          type: 'Entrada',
          quantity: '100',
          username: 'jzamora',
          dateTime: '2024-07-22 11:14',
          orderNumber: '5453'),
      Movement(
          partNumber: '00-00-3321-00',
          description: 'description',
          type: 'Salida',
          quantity: '32',
          username: 'jguerra',
          dateTime: '2024-07-23 15:04',
          orderNumber: '3421'),
      Movement(
          partNumber: '00-00-1111-00',
          description: 'description',
          type: 'Salida',
          quantity: '32',
          username: 'jguerra',
          dateTime: '2024-07-23 15:04',
          orderNumber: '4363'),
      Movement(
          partNumber: '00-00-9999-00',
          description: 'description',
          type: 'Salida',
          quantity: '32',
          username: 'csanchez',
          dateTime: '2024-07-23 15:04',
          orderNumber: '1133'),
      Movement(
          partNumber: '00-00-9999-00',
          description: 'description',
          type: 'Salida',
          quantity: '32',
          username: 'csanchez',
          dateTime: '2024-07-23 15:04',
          orderNumber: '5323'),
    ];
  }

  List<Movement> applyFilters(
    List<Movement> movements,
    Map<String, List<String>> filters,
  ) {
    List<Movement> filteredMovements = movements;

    filters.forEach((filter, value) {
      if (value.isNotEmpty) {
        filteredMovements = filteredMovements.where((move) {
          if (filter == 'partNumber') return value.contains(move.partNumber);
          if (filter == 'username') return value.contains(move.username);
          if (filter == 'orderNumber') return value.contains(move.orderNumber);
          return true;
        }).toList();
      }
    });

    return filteredMovements;
  }

  List<Movement> movements = [];
  List<Movement> filteredMovements = [];
  Map<String, List<String>> filters = {
    'partNumber': [],
    'username': [],
    'orderNumber': [],
  };

  // unique values for filters
  List<String> partNumbers = [];
  List<String> users = [];
  List<String> orders = [];

  @override
  void initState() {
    super.initState();
    movements = getMovements();
    filteredMovements = movements;
    //initializeFilters();
    updateUniqueValues();
  }

  void initializeFilters() {
    setState(() {
      partNumbers = movements.map((move) => move.partNumber).toSet().toList();
      users = movements.map((move) => move.username).toSet().toList();
      orders = movements.map((move) => move.orderNumber).toSet().toList();

      filters['partNumber'] = List.from(partNumbers);
      filters['users'] = List.from(users);
      filters['orderNumber'] = List.from(orders);
    });
  }

  void updateUniqueValues() {
    final localFilteredMovements = applyFilters(movements, filters);

    setState(() {
      partNumbers = movements.map((move) => move.partNumber).toSet().toList();
      users = movements.map((move) => move.username).toSet().toList();
      orders = movements.map((move) => move.orderNumber).toSet().toList();
    });
  }

  void applyFiltersAndUpdate() {
    setState(() {
      filteredMovements = applyFilters(movements, filters);
      updateUniqueValues();
    });
  }

  void toggleFilter(String category, String value) {
    setState(() {
      if (filters[category]!.contains(value)) {
        filters[category]!.remove(value);
      } else {
        filters[category]!.add(value);
      }
      applyFiltersAndUpdate();
    });
  }

  bool isValidFilter(String category, String value) {
    final tempFilters = Map<String, List<String>>.from(filters);
    tempFilters[category] = [value];
    return applyFilters(movements, tempFilters).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filters
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(
                    title: const Text('Part Number'),
                    children: partNumbers.map((part) {
                      return CheckboxListTile(
                        title: Text(part),
                        value: filters['partNumber']!.contains(part),
                        onChanged: isValidFilter('partNumber', part)
                            ? (checked) {
                                toggleFilter('partNumber', part);
                              }
                            : null,
                      );
                      // return filters['partNumber']!.contains(part)
                      //     ? CheckboxListTile(
                      //         title: Text(part),
                      //         value: true,
                      //         onChanged: (checked) {
                      //           toggleFilter('partNumber', part);
                      //         },
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //       )
                      //     : const SizedBox.shrink();
                    }).toList(),
                  ),
                  ExpansionTile(
                    title: const Text('Username'),
                    children: users.map((user) {
                      return CheckboxListTile(
                        title: Text(user),
                        value: filters['username']!.contains(user),
                        onChanged: isValidFilter('username', user)
                            ? (checked) {
                                toggleFilter('username', user);
                              }
                            : null,
                      );
                      // return filters['username']!.contains(user)
                      //     ? CheckboxListTile(
                      //         title: Text(user),
                      //         value: true,
                      //         onChanged: (checked) {
                      //           toggleFilter('username', user);
                      //         },
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //       )
                      //     : const SizedBox.shrink();
                    }).toList(),
                  ),
                  ExpansionTile(
                    title: const Text('Order Number'),
                    children: orders.map((order) {
                      return CheckboxListTile(
                        title: Text(order),
                        value: filters['orderNumber']!.contains(order),
                        onChanged: isValidFilter('orderNumber', order)
                            ? (checked) {
                                toggleFilter('orderNumber', order);
                              }
                            : null,
                      );
                      // return filters['orderNumber']!.contains(order)
                      //     ? CheckboxListTile(
                      //         title: Text(order),
                      //         value: true,
                      //         onChanged: (checked) {
                      //           toggleFilter('orderNumber', order);
                      //         },
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //       )
                      //     : const SizedBox.shrink();
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
                itemCount: filteredMovements.length,
                itemBuilder: (context, index) {
                  final movement = filteredMovements[index];
                  return ListTile(
                    title: Text(movement.partNumber),
                    subtitle:
                        Text('${movement.username}, ${movement.orderNumber}'),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
