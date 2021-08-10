import 'package:flutter/material.dart';

import '../util.dart';

// ignore: must_be_immutable
class DatePickerWidget extends StatefulWidget {
  DateTime iniDate;
  final Function setDateFnc;
  DatePickerWidget({Key? key, required this.iniDate, required this.setDateFnc}) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  getText() {
    /* print(' => IniDate :' + Util.toDateFormat(widget.iniDate));
    //if (currenteData == null) currenteData = widget.iniDate;
    if (currenteData == null) {
      return "Seleciona uma data";
    } else {
      return Util.toDateFormat(currenteData!);
    }
 */
    return Util.toDateFormat(widget.iniDate);
  }

  @override
  Widget build(BuildContext context) => InkWell(
        child: Text(getText(), style: TextStyle(color: Colors.grey)),
        onTap: () => pickDate(context),
      );
  //}

  Future pickDate(BuildContext context) async {
    final initDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;

    setState(() {
      widget.iniDate = newDate;
      widget.setDateFnc(newDate);
    });
    //setState(() => currenteData = newDate);
  }
}
