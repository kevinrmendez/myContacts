import 'package:flutter/material.dart';
import 'package:kevin_app/app_localizations.dart';

String translatedText(text, BuildContext context) {
  return AppLocalizations.of(context).translate(text);
}
