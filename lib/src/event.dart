import 'package:xml/xml.dart';

import 'person.dart';
import 'utils.dart';

class Event {
  final String? guid;
  final int? id;
  final DateTime date;
  final String? start;
  final String duration;
  final String? slug;
  final Uri? url;
  final String title;
  final String? subtitle;
  final String? track;
  final String type;
  final String language;
  final String? abstractinnerText;
  final String? description;
  final Uri? feedbackUrl;
  final List<Person> persons;

  const Event({
    this.guid,
    this.id,
    required this.date,
    this.start,
    required this.duration,
    this.slug,
    this.url,
    required this.title,
    this.subtitle,
    this.track,
    required this.type,
    required this.language,
    this.abstractinnerText,
    this.description,
    this.feedbackUrl,
    required this.persons,
  });

  // Factory constructor to create an Event instance from an XML element
  factory Event.fromXml(XmlElement element) {
    final guid = getValue(element, 'guid', valueType: ValueType.attribute);
    final id =
        int.tryParse(getValue(element, 'id', valueType: ValueType.attribute));
    final date = DateTime.parse(getValue(element, 'date'));
    final start = getValue(element, 'start');
    final duration = getValue(element, 'duration');
    final slug = getValue(element, 'slug');
    final url = Uri.parse(getValue(element, 'url'));
    final title = getValue(element, 'title');
    final subtitle = getValue(element, 'subtitle');
    final track = getValue(element, 'track');
    final type = getValue(element, 'type');
    final language = getValue(element, 'language');
    final abstractinnerText = getValue(element, 'abstract');
    final description = getValue(element, 'description');
    final feedbackUrl = Uri.parse(getValue(element, 'feedback_url'));

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
