class Contact {
  // static int contactId = 0;
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
  String facebook;
  String instagram;
  String linkedin;
  String twitter;
  int showNotification;
  int favorite;

  Contact({
    this.name,
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
    this.facebook = "",
    this.instagram = "",
    this.linkedin = "",
    this.twitter = "",
    this.favorite = 0,
    this.showNotification = 0,
  }) {
    // if (id == null) {
    //   this.id = Contact.contactId;
    //   Contact.contactId++;
    // } else {
    //   this.id = id;
    // }
  }
  factory Contact.fromJson(Map<String, dynamic> data) => Contact(
        id: data['id'],
        name: data['name'],
        phone: data['phone'],
        email: data['email'],
        image: data['image'],
        birthday: data['birthday'],
        address: data['address'],
        organization: data['organization'],
        website: data['website'],
        facebook: data['facebook'],
        instagram: data['instagram'],
        linkedin: data['linkedin'],
        twitter: data['twitter'],
        note: data['note'],
        favorite: data['favorite'],
        showNotification: data['showNotification'],
      );

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'category': category,
      'birthday': birthday,
      'address': address,
      'organization': organization,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'linkedin': linkedin,
      'twitter': twitter,
      'note': note,
      'favorite': favorite,
      'showNotification': showNotification,
    };
  }

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone,email: $email, category: $category, birthday: $birthday, address: $address,organization: $organization, website: $website ,facebook: $facebook, instagram: $instagram,linkedin: $linkedin, twitter: $twitter, image: $image, favorite $favorite, showNotification: $showNotification}';
  }
}
