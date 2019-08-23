class Contact {
  int id;
  String name;
  int phone;
  String image;
  String email;

  Contact({this.name, this.phone, this.image = "", this.id, this.email = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone,email: $email, image: $image}';
  }
}
