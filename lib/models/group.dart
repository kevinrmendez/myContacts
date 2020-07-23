class Group {
  int id;
  String name;

  Group({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Contact{id: $id, name:}';
  }
}
