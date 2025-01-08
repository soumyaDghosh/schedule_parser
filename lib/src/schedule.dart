import 'package:xml/xml.dart';

class Schedule {
  final String acronym;
  final String title;
  final String? subtitle;
  final String venue;
  final String city;
  final String startDate;
  final String endDate;
  final int? days;
  final String? dayChange;
  final String? timeSlotDuration;
  final Uri baseUrl;
  final String? timeZone;

  // Map to store lists of raw XmlNodes for each property
  final Map<String, List<XmlNode>?> rawNodes;

  const Schedule({
    required this.acronym,
    required this.title,
    this.subtitle,
    required this.venue,
    required this.city,
    required this.startDate,
    required this.endDate,
    this.days,
    this.dayChange,
    this.timeSlotDuration,
    required this.baseUrl,
    this.timeZone,
    required this.rawNodes,
  });

  factory Schedule.fromXml(XmlElement element) {
    // Helper function to get required attribute as string
    String? getValue(String attributeName, {bool isRequired = true}) {
      final elements = element.getElement(attributeName);
      if (elements == null || elements.descendants.isEmpty) {
        if (isRequired) {
          throw ArgumentError('Missing required attribute: $attributeName');
        }
        return null;
      }
      return elements.innerText.trim();
    }

    // Helper function to get all XmlNodes for a given property name
    List<XmlNode>? getAllNodes(String attributeName) {
      final attrNode = element.getElement(attributeName);
      return attrNode?.children.toList();
    }

    // Required attributes
    final acronym = getValue('acronym');
    final title = getValue('title');
    final venue = getValue('venue');
    final city = getValue('city');
    final startDate = getValue('start');
    final endDate = getValue('end');
    final baseUrlString = getValue('base_url');
    final baseUrl = Uri.parse(baseUrlString!);

    // Optional attributes
    final subtitle = getValue('subtitle', isRequired: false);
    final days = getValue('days', isRequired: false);
    final dayChange = getValue('day_change', isRequired: false);
    final timeSlotDuration = getValue('timeslot_duration', isRequired: false);
    final timeZone = getValue('time_zone_name', isRequired: false);

    // Store lists of XmlNodes for all attributes
    final rawNodes = <String, List<XmlNode>?>{
      'acronym': getAllNodes('acronym'),
      'title': getAllNodes('title'),
      'subtitle': getAllNodes('subtitle'),
      'venue': getAllNodes('venue'),
      'city': getAllNodes('city'),
      'startDate': getAllNodes('start'),
      'endDate': getAllNodes('end'),
      'baseUrl': getAllNodes('base_url'),
      'days': getAllNodes('days'),
      'dayChange': getAllNodes('day_change'),
      'timeSlotDuration': getAllNodes('timeslot_duration'),
      'timeZone': getAllNodes('time_zone_name'),
    };

    return Schedule(
      acronym: acronym!,
      title: title!,
      subtitle: subtitle,
      venue: venue!,
      city: city!,
      startDate: startDate!,
      endDate: endDate!,
      days: days != null ? int.parse(days) : null,
      dayChange: dayChange,
      timeSlotDuration: timeSlotDuration,
      baseUrl: baseUrl,
      timeZone: timeZone,
      rawNodes: rawNodes,
    );
  }

  // Method to get a property as a list of XmlNodes
  List<XmlNode>? getRawXmlNodes(String property) {
    return rawNodes[property];
  }
}
