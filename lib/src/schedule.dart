import 'package:xml/xml.dart';

class Schedule {
  final String acronym;
  final String title;
  final String subtitle;
  final String venue;
  final String city;
  final String startDate;
  final String endDate;
  final int days;
  final String? dayChange;
  final String? timeSlotDuration;
  final Uri baseUrl;
  final String timeZone;
  static late Map<String, List<XmlNode>?> _rawNodes;

  const Schedule({
    required this.acronym,
    required this.title,
    this.subtitle = '',
    required this.venue,
    required this.city,
    required this.startDate,
    required this.endDate,
    this.days = 1,
    this.dayChange,
    this.timeSlotDuration,
    required this.baseUrl,
    this.timeZone = '',
  });

  factory Schedule.fromXml(XmlElement element) {
    // Helper function to get required attribute as string
    String getValue(String attributeName, {bool isRequired = true}) {
      final elements = element.getElement(attributeName);
      if (elements != null && elements.descendants.isNotEmpty) {
        return elements.innerText.trim();
      }
      if (isRequired) {
        throw ArgumentError('Missing required attribute: $attributeName');
      }
      return '';
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
    final baseUrl = Uri.parse(getValue('base_url'));

    // Optional attributes
    final subtitle = getValue('subtitle', isRequired: false);
    final days = getValue('days', isRequired: false);
    final dayChange = getValue('day_change', isRequired: false);
    final timeSlotDuration = getValue('timeslot_duration', isRequired: false);
    final timeZone = getValue('time_zone_name', isRequired: false);

    // Store lists of XmlNodes for all attributes
    _rawNodes = <String, List<XmlNode>?>{
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
      acronym: acronym,
      title: title,
      subtitle: subtitle,
      venue: venue,
      city: city,
      startDate: startDate,
      endDate: endDate,
      days: int.tryParse(days) ?? 1,
      dayChange: dayChange,
      timeSlotDuration: timeSlotDuration,
      baseUrl: baseUrl,
      timeZone: timeZone,
    );
  }

  List<XmlNode> getRawXmlNodes(String property) {
    return _rawNodes[property] ?? [];
  }
}
