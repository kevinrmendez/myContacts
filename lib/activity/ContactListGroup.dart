import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/utils.dart';
import 'dart:async';
import 'dart:io';

import '../apikeys.dart';
import '../contact.dart';
import 'contactDetails.dart';

import 'package:admob_flutter/admob_flutter.dart';

import 'contactDetailsParallax.dart';

int _counter = 0;
AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["detailsContact"];
}

void _showAd() {
  if (_counter % 6 == 0) {
    interstitialAd.show();
  }
  print("COUNTER: $_counter");
  _counter++;
}

class ContactListGroup extends StatefulWidget {
  final String category;
  final BuildContext context;
  ContactListGroup({this.context, this.category}) {
    interstitialAd.load();
  }
  @override
  _ContactListGroupState createState() {
    return _ContactListGroupState();
  }
}

class _ContactListGroupState extends State<ContactListGroup> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;

  int contactListLength;
  _ContactListGroupState() {
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

    var filteredList = tempList
        .where((contact) => contact.category == widget.category)
        .toList();

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
                      trailing: Icon(filteredNames[index].favorite == 0
                          ? Icons.keyboard_arrow_right
                          : Icons.star),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, '/contactDetails',
                        //     arguments: snapshot.data[index]);
                        _showAd();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          print('CONTACTS ${filteredNames[index]}');
                          // return ContactDetailsParallax(
                          //   contact: filteredNames[index],
                          //   // callback: callback
                          // );
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
                          translatedText("text_empty_list", context),
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
                              "text_empty_list_description", context),
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
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: TextField(
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
              controller: _filter,
              decoration: new InputDecoration(
                prefixIcon: new Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: translatedText("hintText_search", context),
                hintStyle: TextStyle(color: Theme.of(context).accentColor),
                // enabledBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(color: Theme.of(context).accentColor),
                // ),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide:
                //         BorderSide(color: Theme.of(context).accentColor)),
              ),
            ),
          ),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }
}
