import 'package:args/args.dart';
import 'package:schedule_parser/schedule_parser.dart' as schedule_parser;

void main(List<String> arguments) async {
  // Set up argument parser
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'URL to the Frab-generated XML schedule file')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Display this help message');

  ArgResults argResults;

  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print('Error parsing arguments: $e');
    printUsage(parser);
    return;
  }

  // Display help if requested
  if (argResults['help'] || arguments.isEmpty) {
    printUsage(parser);
    return;
  }

  final input = argResults['input'] as String;

  try {
    // Parse the schedule from URL or file path
    final schedule = await schedule_parser.ScheduleParser.fromUrl(input);

    // Print schedule title
    print('Schedule Title: ${schedule.schedule.title}');

    // Iterate over the first day
    for (var day in schedule.days.take(1)) {
      print('Date: ${day.date}');
      // Iterate over the first room
      for (var roomEntry in day.rooms.take(1)) {
        final roomName = roomEntry?.name ?? 'Unknown Room';
        print('  Room: $roomName');
        if (roomEntry?.events.isEmpty ?? true) {
          print('    No events scheduled.');
          continue;
        }

        // Print up to 5 events
        for (var event in roomEntry!.events.take(5)) {
          print('    Event: ${event?.title ?? "Untitled"} '
              '(Start: ${event?.start ?? "N/A"}, Duration: ${event?.duration ?? "N/A"})');
        }
      }
    }
  } catch (e) {
    print('Error processing schedule: $e');
    print('Please ensure the input is a valid Frab-generated XML schedule file or URL.');
  }
}

void printUsage(ArgParser parser) {
  print('Usage: dart run bin/schedule_parser.dart [options]');
  print('Options:');
  print(parser.usage);
  print('Example: dart run bin/schedule_parser.dart https://fosdem.org/2025/schedule/xml');
}
