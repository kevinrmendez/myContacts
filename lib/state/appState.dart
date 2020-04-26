import 'package:kevin_app/contact.dart';
import 'package:kevin_app/contactDb.dart';
import 'package:rxdart/rxdart.dart';
import '../main.dart';

class AppState {
  BehaviorSubject _contactList =
      BehaviorSubject.seeded([contactsfromDb] == null ? [] : contactsfromDb);

  BehaviorSubject _screenIndex = BehaviorSubject.seeded(0);
  Stream get streamIndex => _screenIndex.stream;
  Stream get stream => _contactList.stream;
  List get current => _contactList.value;
  int get currentIndex => _screenIndex.value;

  changeIndex(int index) {
    _screenIndex.add(index);
  }

  add(Contact contact) {
    _contactList.value.add(contact);
    _contactList.add(List.from(current));
  }

  update(String name, String phone, String email, int favorite, String category,
      Contact contact) {
    Contact updatedContact = Contact(
        name: name,
        phone: phone,
        email: email,
        favorite: favorite,
        category: category);
    int contactIndex = _contactList.value.indexOf(contact);
    _contactList.value.removeAt(contactIndex);
    _contactList.value.insert(contactIndex, updatedContact);

    _contactList.add(List.from(current));
  }

  updateAll(List contacts) {
    _contactList.add(List.from(contacts));
  }

  remove(Contact contact) {
    _contactList.value.remove(contact);
    _contactList.add(List.from(current));
  }

  removeAll() {
    _contactList.value = [];
    _contactList.add(List.from(current));
  }
}

AppState contactService = AppState();
