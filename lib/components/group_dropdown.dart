import 'package:flutter/material.dart';
import 'package:kevin_app/bloc/group_service.dart';
import 'package:kevin_app/models/group.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';

class GroupDropDown extends StatefulWidget {
  final Function callback;
  final String dropDownValue;
  GroupDropDown({this.dropDownValue, this.callback});

  @override
  _GroupDropDownState createState() => _GroupDropDownState();
}

class _GroupDropDownState extends State<GroupDropDown> {
  Widget _dropDown() {
    return StreamBuilder<List<Group>>(
        stream: groupService.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return SizedBox(
              height: 15,
            );
          }
          List<Group> _groupList = snapshot.data;
          List<String> _groupListName = _groupList.map((e) => e.name).toList();
          return DropdownButton<String>(
            value: widget.dropDownValue,
            icon: Icon(Icons.arrow_drop_down),
            items: _groupListName.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: GREY),
                ),
              );
            }).toList(),
            onChanged: (String value) {
              widget.callback(value);
              // setState(() {
              //   dropdownValue = value;
              // });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Group>>(
        stream: groupService.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return SizedBox(
              height: 15,
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.group,
                color: DarkGreyColor,
                size: 25,
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                translatedText(
                  "hintText_group",
                  context,
                ),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: DarkGreyColor,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              _dropDown()
            ],
          );
        });
  }
}
