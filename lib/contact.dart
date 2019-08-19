class Contact {
  static int counter = 0;
  int id;
  final String name;
  final int phone;

  Contact({this.name, this.phone}) {
    Contact.counter++;
    this.id = counter;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone}';
  }
}
