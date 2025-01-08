import 'package:xml/xml.dart';

import 'tracks.dart';
import 'person.dart';

class Event {
  final String guid;
  final int id;
  final DateTime date;
  final String start;
  final String duration;
  final String room;
  final String slug;
  final Uri url;
  final String title;
  final String? subtitle;
  final Track track;
  final String type;
  final String language;
  final String abstractinnerText;
  final String? description;
  final Uri feedbackUrl;
  final List<Person> persons;

  const Event({
    required this.guid,
    required this.id,
    required this.date,
    required this.start,
    required this.duration,
    required this.room,
    required this.slug,
    required this.url,
    required this.title,
    this.subtitle,
    required this.track,
    required this.type,
    required this.language,
    required this.abstractinnerText,
    this.description,
    required this.feedbackUrl,
    required this.persons,
  });

  // Factory constructor to create an Event instance from an XML element
  factory Event.fromXml(XmlElement element) {
    final guid = element.getAttribute('guid') ?? '';
    final id = int.parse(element.getAttribute('id') ?? '0');
    final date = DateTime.parse(element.getElement('date')?.innerText ?? '');
    final start = element.getElement('start')?.innerText ?? '';
    final duration = element.getElement('duration')?.innerText ?? '';
    final room = element.getElement('room')?.innerText ?? '';
    final slug = element.getElement('slug')?.innerText ?? '';
    final url = Uri.parse(element.getElement('url')?.innerText ?? '');
    final title = element.getElement('title')?.innerText ?? '';
    final subtitle = element.getElement('subtitle')?.innerText;
    final track = Track.fromXml(element.getElement('track')!);
    final type = element.getElement('type')?.innerText ?? '';
    final language = element.getElement('language')?.innerText ?? '';
    final abstractinnerText =
        element.getElement('abstract')?.innerText.trim() ?? '';
    final description = element.getElement('description')?.innerText;
    final feedbackUrl =
        Uri.parse(element.getElement('feedback_url')?.innerText ?? '');

    // Parse persons
    final personsElement = element.getElement('persons');
    final persons = personsElement != null
        ? personsElement.findElements('person').map((personElement) {
            return Person.fromXml(personElement);
          }).toList()
        : <Person>[];

    return Event(
      guid: guid,
      id: id,
      date: date,
      start: start,
      duration: duration,
      room: room,
      slug: slug,
      url: url,
      title: title,
      subtitle: subtitle,
      track: track,
      type: type,
      language: language,
      abstractinnerText: abstractinnerText,
      description: description,
      feedbackUrl: feedbackUrl,
      persons: persons,
    );
  }
}
