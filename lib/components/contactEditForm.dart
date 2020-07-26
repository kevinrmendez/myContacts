import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kevin_app/activity/ContactList2.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/activity/cameraActivity.dart';
import 'package:kevin_app/activity/homeActivity.dart';
import 'package:kevin_app/bloc/group_service.dart';
import 'package:kevin_app/components/group_dropdown.dart';
import 'package:kevin_app/db/contactDb.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/models/group.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scidart/numdart.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:share/share.dart';

import 'package:kevin_app/models/contact.dart';

import 'package:kevin_app/utils/admobUtils.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class ContactEditForm extends StatefulWidget {
  final BuildContext context;
  final ScrollController scrollController;
  final Contact contact;
  final int index;
  // final List<String> category = <String>[
  //   "general",
  //   "family",
  //   "friend",
  //   "coworker"
  // ];
  final _formKey = GlobalKey<FormState>();

  ContactEditForm(
      {@required this.contact,
      this.context,
      this.index,
      this.scrollController});

  @override
  ContactEditFormState createState() {
    return ContactEditFormState();
  }
}

class ContactEditFormState extends State<ContactEditForm>
    with SingleTickerProviderStateMixin {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  // List<String> category;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final organizationController = TextEditingController();
  final websiteController = TextEditingController();
  final noteController = TextEditingController();

  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final linkedinController = TextEditingController();
  final twitterController = TextEditingController();

  TabController _tabController;
  int _tabIndex = 0;

  String name;
  String phone;
  String email;
  Contact contact;
  String image;
  int favorite;
  int showNotification;
  Future<List<Contact>> contacts;
  String birthday;
  String address;
  String organization;
  String website;
  String note;
  String facebook;
  String instagram;
  String linkedin;
  String twitter;
  DateTime pickedDate;

  int sendedNotification;

  Group dropdownValue;
  // bool isBirthdayNotificationEnable;
  bool showDetails;

  // Widget _dropDown() {
  //   return DropdownButton(
  //     value: dropdownValue,
  //     icon: Icon(Icons.arrow_drop_down),
  //     items: category.map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(
  //           value,
  //           style: TextStyle(color: GREY),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (String value) {
  //       setState(() {
  //         dropdownValue = value;
  //       });
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    //TODO: GET INITIAL STATE OF DROPDOWN FROM CONTACT
    getDropdownValue();
    this.contact = widget.contact;
    // this.dropdownValue = widget.contact.category;

    this.name = widget.contact.name;
    this.phone = widget.contact.phone.toString();
    this.email = widget.contact.email;
    this.image = widget.contact.image;
    this.favorite = widget.contact.favorite;
    this.showNotification = widget.contact.showNotification;
    this.birthday = widget.contact.birthday;
    this.address = widget.contact.address;
    this.organization = widget.contact.organization;
    this.website = widget.contact.website;
    this.note = widget.contact.note;

    this.facebook = widget.contact.facebook;
    this.instagram = widget.contact.instagram;
    this.linkedin = widget.contact.linkedin;
    this.twitter = widget.contact.twitter;

    this.nameController.text = this.name;
    this.phoneController.text = this.phone;
    this.emailController.text = this.email;
    this.birthdayController.text = this.birthday;
    this.addressController.text = this.address;
    this.organizationController.text = this.organization;
    this.websiteController.text = this.website;
    this.noteController.text = this.note;

    this.facebookController.text = this.facebook;
    this.instagramController.text = this.instagram;
    this.linkedinController.text = this.linkedin;
    this.twitterController.text = this.twitter;

    // category = <String>[
    //   translatedText("group_default", widget.context),
    //   translatedText("group_family", widget.context),
    //   translatedText("group_friend", widget.context),
    //   translatedText("group_coworker", widget.context),
    // ];
    // dropdownValue = contact.category;

    // isBirthdayNotificationEnable = false;
    showDetails = false;

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  getDropdownValue() async {
    this.dropdownValue = await getGroupFromDb();
  }

  Future<Group> getGroupFromDb() async {
    Group group = Group(name: widget.contact.category);
    int groupId = groupService.getgroupId(group);

    var result = groupService.getgroupById(groupId);

    return result;
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = phoneController.text;
    contact.email = emailController.text;
    contact.image = this.image;
    contact.favorite = this.favorite;
    contact.showNotification = this.showNotification;
    contact.category = this.dropdownValue.name;
    contact.birthday = this.birthday;
    contact.address = this.address;
    contact.organization = this.organization;
    contact.website = this.website;
    contact.note = this.note;

    contact.facebook = this.facebook;
    contact.instagram = this.instagram;
    contact.linkedin = this.linkedin;
    contact.twitter = this.twitter;

    // print('after update id');
    // print(contact);
    await db.updateContact(contact);

    contacts = db.contacts();
    // List contactsDb = await db.contacts();

    contactService.update(contact);
    _showMessage(translatedText("message_dialog_change_contact", context));
  }

  Future<void> _deleteContact(Contact contact) async {
    List<Contact> contactList;
    AppSettings appState = AppSettings.of(context);
    await db.deleteContact(contact.id);
    // List<Contact> contacts = await db.contacts();
    // print('Contacts AFTER DELETE $contacts');
    contacts = db.contacts();
    contactList = await contacts;
    contactService.remove(contact);
    int contactsLength = contactList.length;

    _showMessage(translatedText("message_dialog_contact_deleted", context));
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    translatedText("button_close", context),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1980),
        firstDate: DateTime(1980),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null) {
      var formatter = DateFormat('dd/MM/yyyy');
      var formattedDate = formatter.format(picked);
      setState(() {
        pickedDate = picked;
        birthday = formattedDate.toString();
      });
      birthdayController.text = formattedDate.toString();
    }
  }

  callbackDropDown(value) {
    setState(() {
      dropdownValue = value;
    });
  }

  // Widget _buildForm() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Form(
  //           key: widget._formKey,
  //           child: Container(
  //             width: 280,
  //             child: Column(
  //               children: <Widget>[
  //                 TextFormField(
  //                   onChanged: (value) {
  //                     this.name = value;
  //                     setState(() {
  //                       this.name = value;
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                       hintText: translatedText("hintText_name", context),
  //                       icon: Icon(Icons.person)),
  //                   controller: nameController,
  //                   validator: (value) {
  //                     if (value.isEmpty) {
  //                       return translatedText(
  //                           "hintText_name_verification", context);
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   onChanged: (value) {
  //                     setState(() {
  //                       this.phone = value;
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                       hintText: translatedText("hintText_phone", context),
  //                       icon: Icon(Icons.phone)),
  //                   validator: (value) {
  //                     if (value.isEmpty) {
  //                       return translatedText(
  //                           "hintText_phone_verification", context);
  //                     }
  //                     return null;
  //                   },
  //                   keyboardType: TextInputType.phone,
  //                   controller: phoneController,
  //                 ),
  //                 TextFormField(
  //                   onChanged: (value) {
  //                     setState(() {
  //                       this.email = value;
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                       hintText: translatedText("hintText_email", context),
  //                       icon: Icon(Icons.email)),
  //                   keyboardType: TextInputType.emailAddress,
  //                   controller: emailController,
  //                 ),
  //                 GroupDropDown(
  //                   dropDownValue: dropdownValue,
  //                   callback: callbackDropDown,
  //                 ),

  //                 Container(
  //                   height: 20,
  //                   child: Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.star,
  //                         color: Colors.grey,
  //                       ),
  //                       SizedBox(
  //                         width: 20,
  //                       ),
  //                       Text(
  //                         translatedText("hintText_favorite", context),
  //                         style: TextStyle(color: Colors.grey),
  //                       ),
  //                       Switch(
  //                         onChanged: (bool value) {
  //                           setState(() {
  //                             this.favorite = boolToInt(value);
  //                           });
  //                         },
  //                         value: intToBool(this.favorite),
  //                         // value: false,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.only(top: 4),
  //                   child: RaisedButton(
  //                     color: Theme.of(context).accentColor,
  //                     child: Text(
  //                       translatedText("button_contact_details", context),
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     onPressed: () {
  //                       setState(() {
  //                         showDetails = !showDetails;
  //                       });
  //                       if (showDetails) {
  //                         widget.scrollController.animateTo(
  //                             MediaQuery.of(context).size.height,
  //                             duration: Duration(seconds: 1),
  //                             curve: Curves.easeOut);
  //                       } else {
  //                         widget.scrollController.animateTo(0.0,
  //                             duration: Duration(seconds: 1),
  //                             curve: Curves.easeOut);
  //                       }
  //                     },
  //                   ),
  //                 ),
  //                 showDetails
  //                     ? Column(
  //                         children: <Widget>[
  //                           TextFormField(
  //                             onTap: () async {
  //                               FocusScope.of(context)
  //                                   .requestFocus(new FocusNode());

  //                               await _selectDate();
  //                             },
  //                             decoration: InputDecoration(
  //                                 hintText: translatedText(
  //                                     "hintText_birthday", context),
  //                                 icon: Icon(Icons.calendar_today)),
  //                             // keyboardType: TextInputType.datetime,
  //                             controller: birthdayController,
  //                           ),
  //                           birthday.length > 900000000000 //hide notification
  //                               // birthday.length > 0 //ORIGINAL notification
  //                               ? Column(
  //                                   children: <Widget>[
  //                                     Row(
  //                                       children: <Widget>[
  //                                         Icon(
  //                                           Icons.notifications_active,
  //                                           color: Colors.grey,
  //                                         ),
  //                                         SizedBox(
  //                                           width: 20,
  //                                         ),
  //                                         Text(
  //                                           // translatedText("hintText_favorite", context),
  //                                           translatedText(
  //                                               "hintText_birthday_notification",
  //                                               context),
  //                                           style:
  //                                               TextStyle(color: Colors.grey),
  //                                         ),
  //                                         Switch(
  //                                           onChanged: (bool value) async {
  //                                             setState(() {
  //                                               this.showNotification =
  //                                                   boolToInt(value);
  //                                               // this.isBirthdayNotificationEnable = value;
  //                                             });
  //                                             print(
  //                                                 "SHOWNOTIFICATION: ${this.showNotification}");
  //                                             if (showNotification == 1) {
  //                                               await _sendBirthdayNotification(
  //                                                   title: translatedText(
  //                                                       "notification_birthday_title",
  //                                                       context),
  //                                                   description: translatedText(
  //                                                       "notification_birthday_description",
  //                                                       context),
  //                                                   payload: translatedText(
  //                                                       "notification_birthday_payload",
  //                                                       context));
  //                                               // flutterLocalNotificationsPlugin
  //                                               //     .cancel(contact.id);
  //                                             } else {
  //                                               print("CONTACTID: $contact.id");
  //                                               flutterLocalNotificationsPlugin
  //                                                   .cancel(contact.id);
  //                                             }
  //                                           },
  //                                           value: intToBool(
  //                                               this.showNotification),
  //                                           // value: false,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 )
  //                               : SizedBox(),
  //                           TextFormField(
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 this.address = value;
  //                               });
  //                             },
  //                             decoration: InputDecoration(
  //                                 hintText: translatedText(
  //                                     "hintText_address", context),
  //                                 icon: Icon(Icons.location_city)),
  //                             keyboardType: TextInputType.text,
  //                             controller: addressController,
  //                           ),
  //                           TextFormField(
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 this.organization = value;
  //                               });
  //                             },
  //                             decoration: InputDecoration(
  //                                 hintText: translatedText(
  //                                     "hintText_organization", context),
  //                                 icon: Icon(Icons.store)),
  //                             keyboardType: TextInputType.text,
  //                             controller: organizationController,
  //                           ),
  //                           TextFormField(
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 this.website = value;
  //                               });
  //                             },
  //                             decoration: InputDecoration(
  //                                 hintText: translatedText(
  //                                     "hintText_website", context),
  //                                 icon: Icon(Icons.web)),
  //                             keyboardType: TextInputType.text,
  //                             controller: websiteController,
  //                           ),
  //                           Container(
  //                             padding: EdgeInsets.only(bottom: 10),
  //                             child: TextFormField(
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   this.note = value;
  //                                 });
  //                               },
  //                               decoration: InputDecoration(
  //                                   hintText: translatedText(
  //                                       "hintText_note", context),
  //                                   icon: Icon(Icons.description)),
  //                               keyboardType: TextInputType.multiline,
  //                               maxLines: null,
  //                               controller: noteController,
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     : SizedBox(),
  //                 // SizedBox(
  //                 //   height: 20,
  //                 // ),
  //                 _buildFormButtons(),
  //               ],
  //             ),
  //           ) // Build this out in the next steps.
  //           ),
  //     ],
  //   );
  // }

  Future _sendBirthdayNotification(
      {String title, String description, String payload}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'notification_channel_id_birthday',
        'channelBirthday',
        'channel for sending notifications for birthdays remindings',
        importance: Importance.Max,
        priority: Priority.High);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin.show(
    //     0, 'birthday', 'it is your birthday', platformChannelSpecifics,
    //     payload: 'birthday');
    var birth_day = pickedDate.day;
    var birth_month = pickedDate.month;
    var notificationTime =
        DateTime(DateTime.now().year, birth_month, birth_day);
    // var notificationDate =
    //     DateTime.now().add(Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(
        contact.id, // notification id,
        "$title ${contact.name}",
        '$description $pickedDate',
        // notificationDate,
        notificationTime,
        platformChannelSpecifics,
        payload: "${contact.id} $payload ${contact.name}!");
  }

  Widget _buildFormButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetUtils.textButton(
            context: context,
            title: translatedText("button_save", context),
            onPress: () async {
              await _updateContact(contact);
            }),
        // RaisedButton(
        //   color: Theme.of(context).primaryColor,
        //   onPressed: () async {
        //     _updateContact(contact);
        //   },
        //   child: Text(
        //     translatedText("button_save", context),
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        SizedBox(
          width: 20,
        ),
        WidgetUtils.textButton(
            context: context,
            title: translatedText("button_delete", context),
            onPress: () async {
              await _deleteContact(contact);
            })
        // Container(
        //   width: 120,
        //   child: RaisedButton(
        //     color: Theme.of(context).primaryColor,
        //     child: Container(
        //       width: 100,
        //       child: Text(
        //         translatedText("button_delete", context),
        //         textAlign: TextAlign.center,
        //         style: TextStyle(color: Colors.white),
        //       ),
        //     ),
        //     onPressed: () async {
        //       await _deleteContact(contact);
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFavoriteIcon() {
    return Container(
      height: 40,
      width: 40,
      child: this.favorite == 1
          ? Icon(
              Icons.star,
              color: this.image == null || this.image == ""
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              // : Colors.white,
              size: 40,
            )
          : SizedBox(),
    );
  }

  Widget _buildPreviewText() {
    return _buildBoldText(this.name);
  }

  Widget _buildBoldText(String text) {
    return Container(
      color: contact.image == null || contact.image == ""
          ? Colors.transparent
          : Colors.transparent,
      // : Theme.of(context).primaryColor,
      // padding: EdgeInsets.symmetric(vertical: 4),
      // width: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width * .75,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            // width: MediaQuery.of(context).size.width * .75,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: contact.image == null || contact.image == ""
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor),
              // : Colors.white),
            ),
          ),
          this.favorite == 1
              ? SizedBox(
                  width: 5,
                )
              : SizedBox(),
          SizedBox(
            height: 35,
            width: 35,
            child: this.favorite == 1
                ? Icon(
                    Icons.star,
                    color: contact.image == null || contact.image == ""
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor,
                    // : Colors.white,
                    size: 35,
                  )
                : SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _buildFormContainer(Widget child) {
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      width: MediaQuery.of(context).size.width * .85,
      child: child,
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: 90,
      height: 35,
      padding: EdgeInsets.fromLTRB(
        10,
        2,
        10,
        2,
      ),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.share,
          size: 20,
          color: Colors.white,
        ),
        onPressed: () {
          Share.share(
              "${translatedText("app_title_contactDetails", context)}: ${translatedText("hintText_name", context)} ${contact.name}, ${translatedText("hintText_phone", context)}: ${contact.phone}, ${translatedText("hintText_email", context)}: ${contact.email}");
        },
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        _buildContactButtons(),
        _buildFormContainer(Column(
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                this.name = value;
                setState(() {
                  this.name = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_name", context),
                  icon: Icon(Icons.person)),
              controller: nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return translatedText("hintText_name_verification", context);
                }
                return null;
              },
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  this.phone = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_phone", context),
                  icon: Icon(Icons.phone)),
              validator: (value) {
                if (value.isEmpty) {
                  return translatedText("hintText_phone_verification", context);
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              controller: phoneController,
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  this.email = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_email", context),
                  icon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),
            GroupDropDown(
              dropDownValue: dropdownValue,
              callback: callbackDropDown,
            ),
            Container(
              height: 20,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    translatedText("hintText_favorite", context),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Switch(
                    onChanged: (bool value) {
                      setState(() {
                        this.favorite = boolToInt(value);
                      });
                    },
                    value: intToBool(this.favorite),
                    // value: false,
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildSocialMediaButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        this.facebook != ""
            ? WidgetUtils.urlButtons(
                url: "https://www.facebook.com/${contact.facebook}",
                icon: FontAwesomeIcons.facebook,
                context: context)
            : SizedBox(),
        this.instagram != ""
            ? WidgetUtils.urlButtons(
                url: "https://www.instagram.com/${contact.instagram}",
                icon: FontAwesomeIcons.instagram,
                context: context)
            : SizedBox(),
        this.linkedin != ""
            ? WidgetUtils.urlButtons(
                url: "https://www.linkedin.com/in/${contact.linkedin}",
                icon: FontAwesomeIcons.linkedinIn,
                context: context)
            : SizedBox(),
        this.twitter != ""
            ? WidgetUtils.urlButtons(
                url: "https://twitter.com/${contact.twitter}",
                icon: FontAwesomeIcons.twitter,
                context: context)
            : SizedBox(),
      ],
    );
  }

  Widget _buildContactButtons() {
    return Container(
      // height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          this.phone != ""
              ? WidgetUtils.urlButtons(
                  url: "tel:${contact.phone.toString()}",
                  icon: Icons.phone,
                  context: context)
              : const SizedBox(),
          this.email != ""
              ? WidgetUtils.urlButtons(
                  url: 'mailto:${contact.email}',
                  icon: Icons.email,
                  context: context)
              : const SizedBox(),
          _buildShareButton()
        ],
      ),
    );
  }

  Widget _buildSocialMediaForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        _buildSocialMediaButtons(),
        _buildFormContainer(Column(
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                this.facebook = value;
                setState(() {
                  this.facebook = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_facebook", context),
                  icon: Icon(FontAwesomeIcons.facebook)),
              controller: facebookController,
            ),
            TextFormField(
              onChanged: (value) {
                this.instagram = value;
                setState(() {
                  this.instagram = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_instagram", context),
                  icon: Icon(FontAwesomeIcons.instagram)),
              controller: instagramController,
            ),
            TextFormField(
              onChanged: (value) {
                this.linkedin = value;
                setState(() {
                  this.linkedin = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_linkedin", context),
                  icon: Icon(FontAwesomeIcons.linkedinIn)),
              controller: linkedinController,
            ),
            TextFormField(
              onChanged: (value) {
                this.twitter = value;
                setState(() {
                  this.twitter = value;
                });
              },
              decoration: InputDecoration(
                  hintText: translatedText("hintText_twitter", context),
                  icon: Icon(FontAwesomeIcons.twitter)),
              controller: twitterController,
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildDetailForm() {
    return Column(
      children: <Widget>[
        _buildFormContainer(
          Column(
            children: <Widget>[
              TextFormField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  await _selectDate();
                },
                decoration: InputDecoration(
                    hintText: translatedText("hintText_birthday", context),
                    icon: Icon(Icons.calendar_today)),
                // keyboardType: TextInputType.datetime,
                controller: birthdayController,
              ),
              birthday.length > 900000000000 //hide notification
                  // birthday.length > 0 //ORIGINAL notification
                  ? Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.notifications_active,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              // translatedText("hintText_favorite", context),
                              translatedText(
                                  "hintText_birthday_notification", context),
                              style: TextStyle(color: Colors.grey),
                            ),
                            Switch(
                              onChanged: (bool value) async {
                                setState(() {
                                  this.showNotification = boolToInt(value);
                                  // this.isBirthdayNotificationEnable = value;
                                });
                                print(
                                    "SHOWNOTIFICATION: ${this.showNotification}");
                                if (showNotification == 1) {
                                  await _sendBirthdayNotification(
                                      title: translatedText(
                                          "notification_birthday_title",
                                          context),
                                      description: translatedText(
                                          "notification_birthday_description",
                                          context),
                                      payload: translatedText(
                                          "notification_birthday_payload",
                                          context));
                                  // flutterLocalNotificationsPlugin
                                  //     .cancel(contact.id);
                                } else {
                                  print("CONTACTID: $contact.id");
                                  flutterLocalNotificationsPlugin
                                      .cancel(contact.id);
                                }
                              },
                              value: intToBool(this.showNotification),
                              // value: false,
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    this.address = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: translatedText("hintText_address", context),
                    icon: Icon(Icons.location_city)),
                keyboardType: TextInputType.text,
                controller: addressController,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    this.organization = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: translatedText("hintText_organization", context),
                    icon: Icon(Icons.store)),
                keyboardType: TextInputType.text,
                controller: organizationController,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    this.website = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: translatedText("hintText_website", context),
                    icon: Icon(Icons.web)),
                keyboardType: TextInputType.text,
                controller: websiteController,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      this.note = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: translatedText("hintText_note", context),
                      icon: Icon(Icons.description)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: noteController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  callback(value) {
    setState(() {
      image = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: ContactImage(
                      context: context,
                      image: this.image,
                    ),
                  ),
                  Positioned(
                      top: 25,
                      left: -2,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: this.image == null || this.image == ""
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  Positioned(
                      bottom: 5,
                      child: WidgetUtils.buildCamera(image, context, callback)),
                  Positioned(top: 50, right: 20, child: _buildFavoriteIcon())
                ],
              ),
              // _buildPreviewText(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: GREY,
                  tabs: [
                    Tab(
                        icon: Icon(
                      Icons.person,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.assignment,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.thumb_up,
                    )),
                  ],
                ),
                Center(
                  child: [
                    _buildContactForm(),
                    _buildDetailForm(),
                    _buildSocialMediaForm()
                  ][_tabIndex],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _buildFormButtons(),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
