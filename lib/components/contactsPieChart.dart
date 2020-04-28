import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/utils.dart';

import '../contact.dart';

class ContactsPieChart extends StatefulWidget {
  // final List<charts.Series> seriesList;
  final bool animate;
  final BuildContext context;
  List<ContactCategory> data = <ContactCategory>[];
  ContactsPieChart(this.context, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  // factory ContactsPieChart.withSampleData(BuildContext context) {
  //   return ContactsPieChart(
  //     context,
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  _ContactsPieChartState createState() => _ContactsPieChartState();
}

class _ContactsPieChartState extends State<ContactsPieChart> {
  List<Contact> contactList;
  List<ContactCategory> data;

  @override
  void initState() {
    super.initState();
    contactList = contactService.current;
    _getPieChartData();
  }

  _getCategoryContactsQuantity(String category) {
    int counter = 0;
    contactList.forEach((contact) {
      if (contact.category == category) {
        counter++;
      }
    });
    return counter;
  }

  _getPieChartData() {
    int generalQuantity = _getCategoryContactsQuantity(
        translatedText("group_default", widget.context));
    int familyQuantity = _getCategoryContactsQuantity(
        translatedText("group_family", widget.context));
    int friendQuantity = _getCategoryContactsQuantity(
        translatedText("group_friend", widget.context));
    int coworkerQuantity = _getCategoryContactsQuantity(
        translatedText("group_coworker", widget.context));
    data = [
      new ContactCategory("general", 0, generalQuantity),
      new ContactCategory("family", 1, familyQuantity),
      new ContactCategory("friends", 2, friendQuantity),
      new ContactCategory("coworker", 3, coworkerQuantity),
    ];
  }

  List<charts.Series<ContactCategory, int>> _createSampleData() {
    return [
      charts.Series<ContactCategory, int>(
        id: 'sales',
        domainFn: (ContactCategory sales, _) => sales.order,
        measureFn: (ContactCategory sales, _) => sales.amount,
        data: data,
        labelAccessorFn: (ContactCategory row, _) =>
            '${row.name}: ${row.amount}',
        colorFn: (_, __) => charts.MaterialPalette.gray.shade400,
        fillColorFn: (_, __) => charts.MaterialPalette.gray.shade400,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      _createSampleData(),
      animate: widget.animate,
      animationDuration: Duration(seconds: 3),
      defaultRenderer:
          new charts.ArcRendererConfig(arcWidth: 120, arcRendererDecorators: [
        charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
      ]),
    );
  }
}

class ContactCategory {
  final String name;
  final int order;
  final int amount;

  ContactCategory(this.name, this.order, this.amount);
}
