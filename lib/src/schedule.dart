import 'package:xml/xml.dart';

import 'utils.dart';

class Schedule {
  final String acronym;
  final String title;
  final String? subtitle;
  final String? venue;
  final String? city;
  final String? startDate;
  final String? endDate;
  final int? days;
  final String? dayChange;
  final String? timeSlotDuration;
  final Uri baseUrl;
  final String? timeZone;

  const Schedule({
    required this.acronym,
    required this.title,
    this.subtitle = '',
    this.venue,
    this.city,
    this.startDate,
    this.endDate,
    this.days = 1,
    this.dayChange,
    this.timeSlotDuration,
    required this.baseUrl,
    this.timeZone = '',
  });

  factory Schedule.fromXml(XmlElement element) {
    // Required attributes
    final acronym = getValue(element, 'acronym', isRequired: true);
    final title = getValue(element, 'title', isRequired: true);
    final baseUrl = Uri.parse(getValue(element, 'base_url', isRequired: true));

    // Optional attributes
    final venue = getValue(element, 'venue');
    final city = getValue(element, 'city');
    final startDate = getValue(element, 'start');
    final endDate = getValue(element, 'end');
    final subtitle = getValue(element, 'subtitle');
    final days = getValue(element, 'days');
    final dayChange = getValue(element, 'day_change');
    final timeSlotDuration = getValue(element, 'timeslot_duration');
    final timeZone = getValue(element, 'time_zone_name');

    return Schedule(
      acronym: acronym,
      title: title,
      subtitle: subtitle,
      venue: venue,
      city: city,
      startDate: startDate,
      endDate: endDate,
      days: int.tryParse(days),
      dayChange: dayChange,
      timeSlotDuration: timeSlotDuration,
      baseUrl: baseUrl,
      timeZone: timeZone,
    );
  }
}
