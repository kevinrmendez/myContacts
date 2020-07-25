import 'package:flutter/material.dart';
import 'package:kevin_app/activity/ContactListGroup.dart';
import 'package:kevin_app/bloc/group_service.dart';
import 'package:kevin_app/models/group.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:strings/strings.dart';

enum MenuActions { delete, edit }

class GroupActivity extends StatefulWidget {
  @override
  _GroupActivityState createState() {
    return _GroupActivityState();
  }
}

class _GroupActivityState extends State<GroupActivity> {
  // Future<List<Contact>> contacts;
  // List<String> category;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // category = <String>[
    //   translatedText("group_default", context),
    //   translatedText("group_family", context),
    //   translatedText("group_friend", context),
    //   translatedText("group_coworker", context),
    // ];
    return Scaffold(
      body: StreamBuilder(
        stream: groupService.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return Center(
                  child: WidgetUtils.emptyListText(
                      title: 'group list is empty',
                      description: 'add a group to your group list',
                      context: context),
                );
              }

            case ConnectionState.waiting:
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

            default:
              {
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Center(
                    child: WidgetUtils.emptyListText(
                        title: 'group list is empty',
                        description: 'add a group to your group list',
                        context: context),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Group group = snapshot.data[index];
                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              // leading:
                              title: Text(
                                '${capitalize(group.name)}',
                                style: TextStyle(fontSize: 22),
                              ),
                              trailing: PopupMenuButton<MenuActions>(
                                onSelected: (order) {
                                  switch (order) {
                                    case MenuActions.edit:
                                      {
                                        print('edit');
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                EditGroupDialog(group));
                                      }
                                      break;
                                    case MenuActions.delete:
                                      {
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DeleteGroupDialog(group));

                                        print('delete');

                                        // proteinListServices.orderFoodsDescending();
                                      }
                                      break;
                                    default:
                                  }
                                },
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (
                                  BuildContext context,
                                ) {
                                  return [
                                    PopupMenuItem<MenuActions>(
                                      child: Text('edit'),
                                      value: MenuActions.edit,
                                    ),
                                    PopupMenuItem<MenuActions>(
                                      child: Text('delete'),
                                      value: MenuActions.delete,
                                    ),
                                  ];
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ContactListGroup(group: group)),
                                );
                                // }));
                              },
                            ),
                          ),
                        ],
                      );
                    });
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => AddGroupDialog());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddGroupDialog extends StatefulWidget {
  @override
  _AddGroupDialogState createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final _dialogformKey = GlobalKey<FormState>();

  String groupName;
  final _groupNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .3,
        title: 'add group',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _dialogformKey,
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'group name', icon: Icon(Icons.group)),
                    keyboardType: TextInputType.text,
                    controller: _groupNameController,
                    onChanged: (value) {
                      setState(() {
                        groupName = value;
                      });
                    },
                    validator: (value) {
                      List<String> currentGroups = groupService.currentList
                          .map((group) => group.name)
                          .toList();
                      if (value == "") {
                        return "value empty";
                      }
                      if (currentGroups.contains(value))
                        return "group already exists";
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  WidgetUtils.textButton(
                      context: context,
                      title: "add",
                      onPress: () async {
                        if (_dialogformKey.currentState.validate()) {
                          Group group = Group(name: groupName);

                          groupService.add(group);

                          Navigator.pop(context);
                        } else {}
                      })
                ]),
              ),
            ],
          ),
        ));
  }
}

class EditGroupDialog extends StatefulWidget {
  final group;
  EditGroupDialog(this.group);
  @override
  _EditGroupDialogState createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  final _dialogformKey = GlobalKey<FormState>();

  String groupName;
  final _groupNameController = TextEditingController();
  @override
  void initState() {
    _groupNameController.text = widget.group.name;
    groupName = widget.group.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .37,
        title: 'edit group',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _dialogformKey,
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'group name', icon: Icon(Icons.group)),
                    keyboardType: TextInputType.text,
                    controller: _groupNameController,
                    onChanged: (value) {
                      setState(() {
                        groupName = value;
                      });
                    },
                    validator: (value) {
                      if (value == "") {
                        return "value empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  WidgetUtils.textButton(
                      context: context,
                      title: "add",
                      onPress: () async {
                        if (_dialogformKey.currentState.validate()) {
                          var groupId =
                              await groupService.getgroupId(widget.group);
                          Group group = Group(id: groupId, name: groupName);

                          groupService.update(group);

                          Navigator.pop(context);
                        } else {}
                      })
                ]),
              ),
            ],
          ),
        ));
  }
}

class DeleteGroupDialog extends StatefulWidget {
  final group;
  DeleteGroupDialog(this.group);
  @override
  _DeleteGroupDialogState createState() => _DeleteGroupDialogState();
}

class _DeleteGroupDialogState extends State<DeleteGroupDialog> {
  final _dialogformKey = GlobalKey<FormState>();

  String groupName;
  final _groupNameController = TextEditingController();
  @override
  void initState() {
    _groupNameController.text = widget.group.name;
    groupName = widget.group.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .32,
        title: 'delete group',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Are you sure you want to delete '${widget.group.name}'  group?",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Form(
                key: _dialogformKey,
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      WidgetUtils.textButton(
                          buttonWidth: 90,
                          context: context,
                          title: "delete",
                          onPress: () async {
                            if (_dialogformKey.currentState.validate()) {
                              var groupId =
                                  await groupService.getgroupId(widget.group);
                              Group group = Group(id: groupId, name: groupName);

                              groupService.remove(group.id);

                              Navigator.pop(context);
                            } else {}
                          }),
                      WidgetUtils.textButton(
                          buttonWidth: 90,
                          context: context,
                          title: "cancel",
                          onPress: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
