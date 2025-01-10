import 'package:xml/xml.dart';

import 'room.dart';
import 'utils.dart';

class Day {
  final int? index;
  final DateTime date;
  final DateTime? start;
  final DateTime? end;
  final List<Room?> rooms;

  const Day({
    this.index,
    required this.date,
    this.start,
    this.end,
    required this.rooms,
  });
  // Factory constructor to create a Day instance from an XML element
  factory Day.fromXml(XmlElement element) {
    final index = int.tryParse(getValue(
      element,
      'index',
      valueType: ValueType.attribute,
    ));
    final date = DateTime.parse(getValue(
      element,
      'date',
      isRequired: true,
      valueType: ValueType.attribute,
    ));

    final start = DateTime.tryParse(getValue(
      element,
      'start',
      valueType: ValueType.attribute,
    ));

    final end = DateTime.tryParse(getValue(
      element,
      'end',
      valueType: ValueType.attribute,
    ));

    final rooms =
        element.findElements('room').map((e) => Room.fromXml(e)).toList();

    return Day(
      index: index,
      date: date,
      start: start,
      end: end,
      rooms: rooms,
    );
  }
}
