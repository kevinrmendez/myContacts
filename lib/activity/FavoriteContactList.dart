import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';
import 'dart:async';
import 'dart:io';

import '../contact.dart';
import 'contactDetails.dart';

import 'package:admob_flutter/admob_flutter.dart';

import 'contactEdit.dart';

class FavoriteContactList extends StatefulWidget {
  final BuildContext context;
  FavoriteContactList({this.context}) {}
  @override
  _FavoriteContactListState createState() {
    return _FavoriteContactListState();
  }
}

class _FavoriteContactListState extends State<FavoriteContactList> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;

  int contactListLength = 0;
  _ContactListState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";

  List<Contact> names = List(); // names we get from API
  List<Contact> filteredNames = List();

  Future getContactList() async {
    return await contacts;
  }

  Future<List<Contact>> _getContacts() async {
    List<Contact> tempList = new List();
    tempList = await db.contacts();

    var filteredList =
        tempList.where((contact) => contact.favorite == 1).toList();

    setState(() {
      names = filteredList;
      filteredNames = names;
      contactListLength = names.length;
    });
    return tempList;
  }

  Widget _buildList() {
    if ((_searchText.isNotEmpty)) {
      List<Contact> tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        print("FILTERED NAMES $filteredNames[i]");
        if (filteredNames[i].name != null) {
          if (filteredNames[i]
              .name
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
            tempList.add(filteredNames[i]);
          }
        }
      }
      filteredNames = tempList;
    }
    if (filteredNames.length > 0 || names.length > 0) {
      return ListView.builder(
          itemCount: names == null ? 0 : filteredNames.length,
          itemBuilder: (BuildContext context, int index) {
            if (filteredNames[index].name != null ||
                filteredNames[index].name == "") {
              return Column(
                children: <Widget>[
                  // index % 10 == 0 ? AdmobUtils.admobBanner() : SizedBox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (_, __, ___) => ContactEdit(
                            index: index,
                            context: context,
                            contact: filteredNames[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Hero(
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: names[index].image == "" ||
                                    names[index].image == null
                                ? AssetImage('assets/person-icon-w-s3p.png')
                                : FileImage(File(filteredNames[index].image)),
                          ),
                          tag: filteredNames[index].name + index.toString(),
                        ),
                        title: Text(
                          '${filteredNames[index].name}',
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Icon(filteredNames[index].favorite == 0
                            ? Icons.keyboard_arrow_right
                            : Icons.star),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox();
            }
          });
    } else {
      if (contactListLength == 0) {
        return Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        // margin: EdgeInsets.only(top: 40),
                        child: Text(
                          translatedText("text_empty_list_favorite", context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          translatedText(
                              "text_empty_list_favorite_description", context),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }
  }

  callback({contacts, names, filteredNames}) {
    setState(() {
      this.contacts = contacts;
      this.names = names;
      this.filteredNames = filteredNames;
      // this.contactListLength = contactListLength;
    });
  }

  void _menuSelected(choice) {
    switch (choice) {
      case 'settings':
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        }
        break;
    }
  }

  @override
  void initState() {
    contacts = db.contacts();
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translatedText("app_title_favorite", context),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              })
          // PopupMenuButton(
          //   icon: Icon(
          //     Icons.settings,
          //     size: 30,
          //   ),
          //   onSelected: _menuSelected,
          //   color: Colors.white,
          //   itemBuilder: (BuildContext context) {
          //     return [
          //       PopupMenuItem(
          //         value: 'settings',
          //         child: Container(
          //             child:
          //                 Text(translatedText("app_title_settings", context))),
          //       ),
          //     ];
          //   },
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          contactListLength > 0
              ? TextField(
                  style: TextStyle(color: GREY, fontSize: 17),
                  controller: _filter,
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    hintText: translatedText("hintText_search", context),
                    hintStyle: TextStyle(color: GREY),
                    // enabledBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: Theme.of(context).accentColor),
                    // ),
                    // focusedBorder: UnderlineInputBorder(
                    //     borderSide:
                    //         BorderSide(color: Theme.of(context).accentColor)),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }
}
