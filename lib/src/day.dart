import 'package:xml/xml.dart';

import 'room.dart';

class Day {
  final int index;
  final DateTime date;
  final DateTime start;
  final DateTime end;
  final List<Room> rooms;

  const Day({
    required this.index,
    required this.date,
    required this.start,
    required this.end,
    required this.rooms,
  });

  // Factory constructor to create a Day instance from an XML element
  factory Day.fromXml(XmlElement element) {
    final index = int.parse(element.getAttribute('index') ?? '');
    final date = DateTime.parse(element.getAttribute('date') ?? '');
    final start = DateTime.parse(element.getAttribute('start') ?? '');
    final end = DateTime.parse(element.getAttribute('end') ?? '');
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
