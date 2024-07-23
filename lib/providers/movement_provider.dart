import 'package:flutter/cupertino.dart';
import 'package:qr_warehouse/models/movement.dart';

class MovementProvider with ChangeNotifier {
  final List<Movement> _movements = [];
  List<Movement> get movements => _movements;

  final String _selectedPartNumber = '';
  final String _selectedUserName = '';
  final String _selectedType = '';

  String get selectedPartNumber => _selectedPartNumber;
  String get selectedUserName => _selectedUserName;
  String get selectedType => _selectedType;

  Future<void> fetchMovements() async {}
}
