class PartNumber {
  final String partNumber;
  final String description;
  final String quantity;
  final String min;
  final String max;
  final String location;
  final String manufacter;
  final String mnfPartNumber;
  final String isActive;

  const PartNumber({
    required this.partNumber,
    required this.description,
    required this.quantity,
    required this.min,
    required this.max,
    required this.location,
    required this.manufacter,
    required this.mnfPartNumber,
    required this.isActive,
  });

  factory PartNumber.fromJson(Map<String, dynamic> json) {
    return PartNumber(
      partNumber: json['partnumber'],
      description: json['description'],
      quantity: json['quantity'],
      min: json['min'],
      max: json['max'],
      location: json['location'],
      manufacter: json['manufacter'],
      mnfPartNumber: json['mnfpartnumber'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partnumber': partNumber,
      'description': description,
      'quantity': quantity,
      'min': min,
      'max': max,
      'location': location,
      'manufacter': manufacter,
      'mfnpartnumber': mnfPartNumber,
      'isActive': isActive,
    };
  }

  List<String> toList() {
    return [
      partNumber,
      description,
      quantity.toString(),
      min.toString(),
      max.toString(),
      location,
      manufacter,
      mnfPartNumber,
      isActive.toString(),
    ];
  }
}
