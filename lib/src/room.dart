import 'package:xml/xml.dart';

import 'event.dart';

class Room {
  final String name;
  final String slug;
  final List<Event>? events;

  const Room({
    required this.name,
    required this.slug,
    this.events,
  });

  // Factory constructor to parse XML element and create a Room instance
  factory Room.fromXml(XmlElement element) {
    final name = element.getAttribute('name');
    final slug = element.getAttribute('slug');

    if (name == null || slug == null) {
      throw ArgumentError('Room name and slug must not be null');
    }

    final events =
        element.findElements('event').map((e) => Event.fromXml(e)).toList();
    return Room(
      name: name,
      slug: slug,
      events: events,
    );
  }
}
