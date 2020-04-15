import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'dart:async';
import 'dart:io';

import '../apikeys.dart';
import '../contact.dart';
import 'contactDetails.dart';

import 'package:admob_flutter/admob_flutter.dart';

int _counter = 0;
AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["contactListAdd"];
  // return apikeys["addInterstellarTest"];
}

void _showAd() {
  if (_counter % 2 == 0) {
    interstitialAd.show();
  }
  print("COUNTER: $_counter");
  _counter++;
}

class ContactList extends StatefulWidget {
  ContactList() {
    interstitialAd.load();
  }
  @override
  _ContactListState createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;

  int contactListLength;
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

  List<Contact> names = new List(); // names we get from API
  List<Contact> filteredNames = new List();
  // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Contact');

  Future getContactList() async {
    return await contacts;
  }

  Future<List<Contact>> _getContacts() async {
    List<Contact> tempList = new List();
    tempList = await db.contacts();

    setState(() {
      names = tempList;
      filteredNames = names;
      contactListLength = names.length;
    });
    return tempList;
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: TextStyle(color: Colors.white, fontSize: 17),
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: 'Search...',
            hintStyle: TextStyle(color: Theme.of(context).accentColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            // border: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Colors.white))
          ),
        );
      } else {
        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.white,
        );
        this._appBarTitle = new Text('Search Contact');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: Container(
        child: new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<Contact> tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
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
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: names[index].image == "" ||
                                names[index].image == null
                            ? AssetImage('assets/person-icon-w-s3p.png')
                            : FileImage(File(filteredNames[index].image)),
                      ),
                      title: Text(
                        '${filteredNames[index].name}',
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, '/contactDetails',
                        //     arguments: snapshot.data[index]);
                        _showAd();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          print('CONTACTS ${filteredNames[index]}');
                          return ContactDetails(
                              contact: filteredNames[index],
                              callback: callback);
                        }));
                      },
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
                          'Your contact list is empty',
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
                          'go to the home screen  and add your contacts',
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

  @override
  void initState() {
    contacts = db.contacts();
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
    );
  }
}
