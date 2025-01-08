import 'package:schedule_parser/schedule_parser.dart';
import 'package:http/http.dart' as http;

import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

void main(List<String> arguments) async {
  var s = await http.get(Uri.parse("https://fosdem.org/2025/schedule/xml"));
  final schedule = XmlDocument.parse(String.fromCharCodes(s.bodyBytes));

  var conference = schedule.rootElement.getElement("conference");
  if (conference != null && conference.firstElementChild != null) {
    final schd = Schedule.fromXml(conference);
    print('Acronym: ${schd.acronym}');
    print('Time Zone: ${schd.timeZone}');
    print('Start Date: ${schd.startDate}');
    print('Day Change: ${schd.dayChange}');
    print('Time Slot: ${schd.timeSlotDuration}');
    print('Language: ${schd.getRawXmlNodes("start")}');
  }

  print('Tracks:');
  final tracks = schedule.rootElement.getElement("tracks")!.childElements;
  for (var track in tracks) {
    final tr = Track.fromXml(track);
    print('\t${tr.name}: ${tr.onlineQa}');
  }

  final days = schedule.rootElement.findElements("day");
  if (days.isNotEmpty) {
    //print(days.toList()[1].attributes);
    for (var day in days) {
      final d = Day.fromXml(day);
      print('${d.start}: ${d.rooms[2].events?[0].feedbackUrl}\n');
    }
  }
}
