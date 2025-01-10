import 'package:xml/xml.dart';

class Track {
  final String name;
  final bool onlineQa;

  const Track({
    required this.name,
    required this.onlineQa,
  });

  // Factory constructor to parse XML element and create a Track instance
  factory Track.fromXml(XmlElement node) {
    final name = node.innerText.trim();
    final onlineQa =
        bool.tryParse(node.getAttribute('online_qa') ?? '') ?? false;

    return Track(
      name: name,
      onlineQa: onlineQa,
    );
  }
}
