class Contact {
  int id;
  String name;
  String phone;
  String image;
  String email;
  String group;
  int favorite;

  Contact(
      {this.name,
      this.phone,
      this.image = "",
      this.id,
      this.email = "",
      this.group,
      this.favorite = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'group': group,
      'favorite': favorite
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone,email: $email, group: $group,image: $image, favorite $favorite}';
  }
}
