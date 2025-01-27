import 'package:schedule_parser/schedule_parser.dart';

void main() async {
  final schedule = await ScheduleParser.fromUrl(
      "https://programm.froscon.org/2024/schedule.xml");
  print("${schedule.tracks[1].name} : ${schedule.tracks[1].onlineQa}");
  for (var event in schedule.days.first.rooms.first!.events) {
    print(event?.title);
    print(event?.track?.name);
  }
}
