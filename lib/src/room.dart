// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'package:xml/xml.dart';

import 'event.dart';
import 'track.dart';
import 'utils.dart';

class Room {
  final String name;
  final String? slug;
  final List<Event?> events;

  const Room({
    required this.name,
    this.slug,
    required this.events,
  });

  // Factory constructor to parse XML element and create a Room instance
  factory Room.fromXml(XmlElement element, List<Track>? tracks) {
    final name = getValue(
      element,
      'name',
      isRequired: true,
      valueType: ValueType.attribute,
    );

    final slug = getValue(
      element,
      'slug',
      valueType: ValueType.attribute,
    );

    final events = element
        .findElements('event')
        .map((e) => Event.fromXml(e, tracks))
        .toList();

    return Room(
      name: name,
      slug: slug,
      events: events,
    );
  }
}
