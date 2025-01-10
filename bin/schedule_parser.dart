import 'package:schedule_parser/schedule_parser.dart';

void main() async {
  final schedule =
      await ScheduleParser.fromUrl('https://fosdem.org/2025/schedule/xml');
  for (var track in schedule.tracks) {
    print('Track: ${track.name} | Online QA? ${track.onlineQa}');
  }
}
