class Contact {
  static int contactId = 0;
  int id;
  String name;
  String phone;
  String image;
  String email;
  String category;
  String birthday;
  String address;
  String organization;
  String website;
  String note;
  int favorite;

  Contact(
      {this.name,
      this.phone,
      this.image = "",
      this.id,
      this.email = "",
      this.category,
      this.birthday = "",
      this.address = "",
      this.organization = "",
      this.note = "",
      this.website = "",
      this.favorite = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'category': category,
      'birthday': birthday,
      'address': address,
      'organization': organization,
      'website': website,
      'note': note,
      'favorite': favorite
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone,email: $email, category: $category, birthday: $birthday, address: $address,organization: $organization, website: $website ,image: $image, favorite $favorite}';
  }
}
