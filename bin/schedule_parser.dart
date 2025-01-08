import 'package:schedule_parser/schedule_parser.dart' as schedule_parser;
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:xml/xml.dart';

void main(List<String> arguments) {
  http.get(Uri.parse("https://fosdem.org/2025/schedule/xml")).then((s) {
    File("schedule.xml").writeAsBytesSync(s.bodyBytes);
    final schedule = XmlDocument.parse(File("schedule.xml").readAsStringSync());
    var conference = schedule.rootElement.childElements.elementAt(1);
    final schd = schedule_parser.Schedule.fromXml(conference);
    print(schd.acronym);
    print(schd.timeZone);
    final tracks = schedule.rootElement.getElement("tracks")!.childElements;
    for (var track in tracks) {
      final tr = schedule_parser.Track.fromXml(track);
      print("${tr.name}: ${tr.onlineQa}");
    }
  });
}
