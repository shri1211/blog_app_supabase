import 'package:intl/intl.dart';

String formatDateBydMMYYYY(DateTime datetime) {
  return DateFormat("d MM,YYYY").format(datetime);
}
