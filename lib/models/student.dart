import 'package:careerwill/models/kit.dart';

class Student {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String? imageUrl;
  final List<KitItem> kit;
  final String? feeId;

  Student({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.imageUrl,
    required this.kit,
    this.feeId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      imageUrl: json['image']?['url'],
      kit: (json['kit'] as List).map((item) => KitItem.fromJson(item)).toList(),
      feeId: json['fee'], // fee is just an ID string
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, address: $address, phone: $phone, imageUrl: $imageUrl, kit: $kit, feeid: $feeId)';
  }
}
