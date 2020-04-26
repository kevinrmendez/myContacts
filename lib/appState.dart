import 'package:kevin_app/contact.dart';
import 'package:kevin_app/contactDb.dart';
import 'package:rxdart/rxdart.dart';
import './main.dart';

class AppState {
  BehaviorSubject _contactList =
      BehaviorSubject.seeded([contactsfromDb] == null ? [] : contactsfromDb);

  BehaviorSubject _screenIndex = BehaviorSubject.seeded(0);
  Stream get streamIndex => _screenIndex.stream;
  Stream get stream => _contactList.stream;
  List<Contact> get current => _contactList.value;
  int get currentIndex => _screenIndex.value;

  changeIndex(int index) {
    _screenIndex.add(index);
  }

  add(Contact contact) {
    _contactList.value.add(contact);
    _contactList.add(List.from(current));
  }

  remove(Contact contact) {
    _contactList.value.remove(contact);
    _contactList.add(List.from(current));
  }
}

AppState contactService = AppState();
