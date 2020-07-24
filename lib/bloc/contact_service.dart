import 'package:kevin_app/models/contact.dart';
import 'package:kevin_app/models/contact.dart';
import 'package:kevin_app/repository/contact_repository.dart';
import 'package:rxdart/rxdart.dart';

class ContactService {
  static List<Contact> dbContacts = [];
  BehaviorSubject<List<Contact>> _contactList =
      BehaviorSubject.seeded(<Contact>[]);

  Stream get stream => _contactList.stream;

  List<Contact> get currentList => _contactList.value;

  final ContactRepository _contactRepository = ContactRepository();

  ContactService() {
    _getContacts();
  }
  void _getContacts() async {
    dbContacts = await _contactRepository.getAllContacts();

    _contactList.add(dbContacts ?? []);
  }

  add(Contact contact) async {
    _contactList.value.add(contact);
    _contactList.add(List<Contact>.from(currentList));
    _contactRepository.insertContact(contact);
    _getContacts();
  }

  update(Contact contact) async {
    await _contactRepository.updateContact(contact);
    _getContacts();
  }

  remove(int id) async {
    _contactList.value.removeWhere((contact) => contact.id == id);
    _contactList.add(List<Contact>.from(currentList));
    await _contactRepository.deleteContactById(id);
    _getContacts();
  }

  getcontactId(Contact contact) async {
    int id = await _contactRepository.getContactId(contact);
    return id;
  }

  void orderContactsAscending() {
    List<Contact> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    _contactList.add(orderList);
  }

  void orderContactsDescending() {
    List<Contact> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    List<Contact> reversedList = orderList.reversed.toList();
    _contactList.add(reversedList);
  }
}

ContactService contactService = ContactService();
