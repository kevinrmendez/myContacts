import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:kevin_app/main.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';

class ColorSettings extends StatefulWidget {
  @override
  _ColorSettingsState createState() => _ColorSettingsState();
}

class _ColorSettingsState extends State<ColorSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.settingsTile(
        icon: Icons.color_lens,
        title: translatedText("settings_theme", context),
        onTap: () async {
          showDialog(context: context, builder: (_) => ColorPickerDialog());
        });
  }
}

class ColorPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
      title: translatedText("settings_export_contacts", context),
      context: context,
      height: MediaQuery.of(context).size.height * .6,
      child: ColorPicker(),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final List<String> filepaths = [];
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppSettings appSettings = AppSettings.of(context);

    return Container(
        child: Expanded(
      child: MaterialColorPicker(
        allowShades: false,
        onMainColorChange: (Color color) {
          appSettings.callback(color: color);
          prefs.setInt('color', color.value);
        },
        selectedColor: appSettings.color,
      ),
    ));
  }
}
