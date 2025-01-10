import 'package:schedule_parser/src/utils.dart';
import 'package:xml/xml.dart';

class Track {
  final String name;
  final bool? onlineQa;

  const Track({
    required this.name,
    required this.onlineQa,
  });

  // Factory constructor to parse XML element and create a Track instance
  factory Track.fromXml(XmlElement element) {
    final name = element.innerText.trim();
    final onlineQa = bool.tryParse(
      getValue(element, 'online_qa', valueType: ValueType.attribute),
    );

    return Track(
      name: name,
      onlineQa: onlineQa,
    );
  }
}
