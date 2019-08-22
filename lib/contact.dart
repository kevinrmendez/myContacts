class Contact {
  int id;
  String name;
  int phone;
  String image;

  Contact({this.name, this.phone, this.image = "", this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone, image: $image}';
  }
}
