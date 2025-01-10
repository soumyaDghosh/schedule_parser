import 'package:xml/xml.dart';

import 'event.dart';
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
  factory Room.fromXml(XmlElement element) {
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

    final events =
        element.findElements('event').map((e) => Event.fromXml(e)).toList();
    return Room(
      name: name,
      slug: slug,
      events: events,
    );
  }
}
