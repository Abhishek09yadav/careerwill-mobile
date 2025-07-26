class KitItem {
  final String name, description, sId;

  KitItem({required this.name, required this.description, required this.sId});

  factory KitItem.fromJson(Map<String, dynamic> json) {
    return KitItem(
      sId: json['_id'],
      name: json['name'],
      description: json['description'],
    );
  }

  String toString() {
    return 'kitItem(name: $name, description: $description, sId: $sId)';
  }
}
