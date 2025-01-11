// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'package:xml/xml.dart';

import 'room.dart';
import 'track.dart';
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
  factory Day.fromXml(XmlElement element, List<Track>? tracks) {
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

    final rooms = element
        .findElements('room')
        .map((e) => Room.fromXml(e, tracks))
        .toList();

    return Day(
      index: index,
      date: date,
      start: start,
      end: end,
      rooms: rooms,
    );
  }
}
