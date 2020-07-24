import 'package:flutter/material.dart';
import 'package:kevin_app/models/group.dart';
import 'package:strings/strings.dart';

import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:kevin_app/models/contact.dart';

import 'Settings.dart';

class ContactListGroup extends StatefulWidget {
  final Group group;
  ContactListGroup({this.group});
  @override
  _ContactListGroupState createState() {
    return _ContactListGroupState();
  }
}

class _ContactListGroupState extends State<ContactListGroup> {
  int contactListLength = 0;
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
  List<Contact> names = List<Contact>();
  List<Contact> filteredNames = List<Contact>();

  List<Contact> _getContacts() {
    List<Contact> tempList = List<Contact>();
    tempList = contactService.current;

    var filteredList = tempList
        .where((contact) => contact.category == widget.group.name)
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
      List<Contact> tempList = new List<Contact>();
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
                  WidgetUtils.contactListTile(
                      index, filteredNames[index], context)
                ],
              );
            } else {
              return SizedBox();
            }
          });
    } else {
      if (contactListLength == 0) {
        return WidgetUtils.emptyListText(
            title: translatedText("text_empty_list_group", context),
            context: context);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }
  }

  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(widget.group.name)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          contactListLength > 2
              ? WidgetUtils.contactSearchTextField(
                  context: context, filter: _filter)
              : SizedBox(),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }
}
