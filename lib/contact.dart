class Contact {
  int id;
  String name;
  String phone;
  String image;
  String email;
  String instagram;

  Contact(
      {this.name,
      this.phone,
      this.image = "",
      this.id,
      this.email = "",
      this.instagram = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'instagram': instagram
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone,email: $email, instagram: $instagram,image: $image}';
  }
}
