import 'package:flutter/material.dart';

import 'package:kevin_app/activity/contactEditHorizontal.dart';
import 'package:kevin_app/activity/contactEditVertical.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactDb.dart';

class ContactEdit extends StatefulWidget {
  final Contact contact;
  ContactEdit({@required this.contact});

  @override
  ContactEditState createState() {
    return ContactEditState();
  }
}

class ContactEditState extends State<ContactEdit> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContactDb db = ContactDb();

  Contact contact;

  @override
  void initState() {
    super.initState();
    this.contact = widget.contact;
  }

  // Widget _buildHorizontalLayout(){
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        var orientation = MediaQuery.of(context).orientation;
        return orientation == Orientation.portrait
            ? ContactEditVertical(contact: contact)
            : ContactEditHorizontal(
                contact: contact,
              );
      }),
    );
  }
}
