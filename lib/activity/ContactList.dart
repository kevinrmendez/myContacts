import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
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
  if (_counter % 4 == 0) {
    interstitialAd.load();
    interstitialAd.show();
  }
  _counter++;
}

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;
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

  void _getContacts() async {
    List<Contact> tempList = new List();
    tempList = await db.contacts();

    setState(() {
      names = tempList;
      filteredNames = names;
    });
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
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        // return  ListTile(
        //   title: Text(filteredNames[index].name),
        //   onTap: () => print(filteredNames[index].name),
        // );
        // print(filteredNames.length);
        if (filteredNames.length > 0) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: filteredNames[index].image == "" ||
                        filteredNames[index].image == null
                    ? AssetImage('assets/person-icon-w-s3p.png')
                    : FileImage(File(filteredNames[index].image)),
              ),
              // : Container()),
              title: Text(
                '${filteredNames[index].name}',
                style: TextStyle(fontSize: 20),
              ),
              // subtitle: Text(
              //     'phone: ${snapshot.data[index].phone.toString()}'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Navigator.pushNamed(
                //     context, '/contactDetails',
                //     arguments: snapshot.data[index]);
                _showAd();

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  // Contact contact = new Contact(
                  //   name: snapshot.data[index].name,
                  //   phone: snapshot.data[index].phone,
                  //   image: snapshot.data[index].image,
                  // );
                  // contact.id = snapshot.data[index].id;
                  print('CONTACTS ${filteredNames[index]}');
                  return ContactDetails(
                      contact: filteredNames[index], callback: callback);
                }));
              },
            ),
          );
        } else {
          return Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
          );
        }
      },
    );
  }

  callback(value) {
    setState(() {
      contacts = value;
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

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('MyContacts List'),
    //     ),

    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           FutureBuilder(
    //             builder: (BuildContext context, AsyncSnapshot snapshot) {
    //               // print(snapshot.data);
    //               switch (snapshot.connectionState) {
    //                 case ConnectionState.waiting:
    //                   return CircularProgressIndicator();
    //                 default:
    //                   if (snapshot.data.length > 0) {
    //                     return Expanded(
    //                       child: ListView.builder(
    //                         itemCount: snapshot.data.length,
    //                         itemBuilder: (context, int index) {
    //                           return Card(
    //                             child: ListTile(
    //                               leading: CircleAvatar(
    //                                 backgroundColor:
    //                                     Theme.of(context).primaryColor,
    //                                 backgroundImage:
    //                                     snapshot.data[index].image == "" ||
    //                                             snapshot.data[index].image == null
    //                                         ? AssetImage(
    //                                             'assets/person-icon-w-s3p.png')
    //                                         : FileImage(
    //                                             File(snapshot.data[index].image)),
    //                               ),
    //                               // : Container()),
    //                               title: Text(
    //                                 '${snapshot.data[index].name}',
    //                                 style: TextStyle(fontSize: 20),
    //                               ),
    //                               // subtitle: Text(
    //                               //     'phone: ${snapshot.data[index].phone.toString()}'),
    //                               trailing: Icon(Icons.keyboard_arrow_right),
    //                               onTap: () {
    //                                 // Navigator.pushNamed(
    //                                 //     context, '/contactDetails',
    //                                 //     arguments: snapshot.data[index]);
    //                                 _showAd();

    //                                 Navigator.push(context,
    //                                     MaterialPageRoute(builder: (context) {
    //                                   // Contact contact = new Contact(
    //                                   //   name: snapshot.data[index].name,
    //                                   //   phone: snapshot.data[index].phone,
    //                                   //   image: snapshot.data[index].image,
    //                                   // );
    //                                   // contact.id = snapshot.data[index].id;
    //                                   print('CONTACTS ${snapshot.data[index]}');
    //                                   return ContactDetails(
    //                                       contact: snapshot.data[index],
    //                                       callback: callback);
    //                                 }));
    //                               },
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                     );
    //                   } else {
    //                     return Expanded(
    //                       child: Container(
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Container(
    //                               width: 200,
    //                               // margin: EdgeInsets.only(top: 40),
    //                               child: Text(
    //                                 'Your contact list is empty',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.bold,
    //                                     fontSize: 25,
    //                                     color: Theme.of(context).accentColor),
    //                               ),
    //                             ),
    //                             Container(
    //                               constraints: BoxConstraints(
    //                                   maxWidth:
    //                                       MediaQuery.of(context).size.width *
    //                                           0.7),
    //                               margin: EdgeInsets.only(top: 20),
    //                               child: Text(
    //                                 'go to the home screen  and add your contacts',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(fontSize: 17),
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     );
    //                   }
    //               }
    //             },
    //             future: getContactList(),
    //           ),
    //           // ListView(children: db.contacts() as List<Widget>)
    //         ],
    //       ),
    //     ),
    //   );
  }
}
