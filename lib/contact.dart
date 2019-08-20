class Contact {
  static int counter = 0;
  int id;
  final String name;
  final int phone;
  final String image;

  Contact({this.name, this.phone, this.image = ""}) {
    Contact.counter++;
    this.id = counter;
  }

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
