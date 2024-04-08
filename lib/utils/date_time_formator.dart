import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeFormater{

  static String formatDataTime(String entryDate, String outputFormate) {
    initializeDateFormatting("pt_BR");
    // var formater = DateFormat.yMd("pt_BR");

    DateFormat formater;
    if (outputFormate == "D") {
      formater = DateFormat("d/MM/y");
    } else if (outputFormate == "H") {
      formater = DateFormat("HH:mm");
    } else {
      formater = DateFormat("d/MM/y - HH:mm:ss");
    }
    DateTime convertedDate = DateTime.parse(entryDate);
    String outputDate = formater.format(convertedDate);
    return outputDate;
  }
}