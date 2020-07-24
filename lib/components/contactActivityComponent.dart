// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:kevin_app/activity/Settings.dart';
// import 'package:kevin_app/activity/cameraActivity.dart';
// import 'package:kevin_app/bloc/group_service.dart';
// import 'package:kevin_app/components/contactImage.dart';
// import 'package:kevin_app/components/contactImage.dart';
// import 'package:kevin_app/components/contactImage.dart';
// import 'dart:async';
// import 'package:kevin_app/components/contact_form.dart';
// import 'package:flutter/services.dart';
// import 'package:kevin_app/models/contact.dart';
// import 'package:kevin_app/models/group.dart';

// import 'package:kevin_app/state/appState.dart';
// import 'package:kevin_app/utils/admobUtils.dart';
// import 'package:kevin_app/utils/colors.dart';
// import 'package:kevin_app/utils/utils.dart';
// import 'package:kevin_app/utils/widgetUitls.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../app_localizations.dart';
// import '../main.dart';

// class ContactActivityComponent extends StatefulWidget {
//   final _formKey = GlobalKey<FormState>();
//   final BuildContext context;

//   ContactActivityComponent(BuildContext this.context);

//   @override
//   ContactActivityComponentState createState() =>
//       ContactActivityComponentState();
// }

// class ContactActivityComponentState extends State<ContactActivityComponent>
//     with WidgetsBindingObserver {
//   String image = "";
//   AppLifecycleState appState;
//   AppLifecycleState appLifecycleState;

//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();

//   List<String> category;

//   String action = "save";
//   String name;
//   String phone;
//   String email;
//   int contactId;
//   Group dropdownValue;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);

//     super.initState();
//     // category = <String>[
//     //   translatedText("group_default", widget.context),
//     //   translatedText("group_family", widget.context),
//     //   translatedText("group_friend", widget.context),
//     //   translatedText("group_coworker", widget.context),
//     // ];
//     // dropdownValue = category[0];
//     contactId = 0;
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);

//     super.dispose();
//   }

//   void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
//     appState = appLifecycleState;
//     print(appLifecycleState);
//   }

// }
