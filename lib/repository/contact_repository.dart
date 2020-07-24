import 'package:kevin_app/dao/contact_dao.dart';
import 'package:kevin_app/dao/contact_dao.dart';
import 'package:kevin_app/models/contact.dart';
import 'package:kevin_app/models/contact.dart';

class ContactRepository {
  final contactDao = ContactDao();

  Future getAllContacts({String query}) => contactDao.contacts();

  Future getContactId(Contact contact) => contactDao.getContactId(contact);

  Future insertContact(Contact contact) => contactDao.insertContact(contact);

  Future updateContact(Contact contact) => contactDao.updateContact(contact);

  Future deleteContactById(int id) => contactDao.deleteContact(id);

  Future deleteAllContacts() => contactDao.deleteAllContacts();
}
