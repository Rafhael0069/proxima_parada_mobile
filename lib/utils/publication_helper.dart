import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PublicationHelper {
  // Converte data e hora (strings) para Timestamp
  static Timestamp converterDataHoraParaTimestamp(String dataString, String hourString) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateFormat timeFormat = DateFormat("hh:mm a");

    DateTime data = dateFormat.parse(dataString);
    DateTime hora = timeFormat.parse(hourString);

    DateTime dataHoraCombined = DateTime(
      data.year,
      data.month,
      data.day,
      hora.hour,
      hora.minute,
    );

    return Timestamp.fromDate(dataHoraCombined);
  }
}