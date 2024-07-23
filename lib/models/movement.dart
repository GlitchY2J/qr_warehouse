class Movement {
  Movement({
    required this.partNumber,
    required this.description,
    required this.type,
    required this.quantity,
    required this.username,
    required this.dateTime,
    required this.orderNumber,
  });

  final String partNumber;
  final String description;
  final String type;
  final String quantity;
  final String username;
  final String dateTime;
  final String orderNumber;

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      partNumber: json['partnumber'],
      description: json['description'],
      type: json['type'],
      quantity: json['quantity'],
      username: json['username'],
      dateTime: json['datetime'],
      orderNumber: json['order_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partnumber': partNumber,
      'description': description,
      'type': type,
      'quantity': quantity,
      'username': username,
      'datetime': dateTime,
      'order_number': orderNumber,
    };
  }

  List<String> toList() {
    return [
      partNumber,
      description,
      type,
      quantity,
      username,
      dateTime,
      orderNumber,
    ];
  }
}
