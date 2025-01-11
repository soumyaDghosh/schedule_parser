// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'src/day.dart';
import 'src/schedule.dart';
import 'src/track.dart';

enum ScheduleProvider { pentabarf, frab, indigo, custom }

enum ScheduleFormat { xml, json }

class ScheduleParser {
  final String url;
  final ScheduleFormat format;
  final Schedule schedule;
  final List<Track> tracks;
  final List<Day> days;

  ScheduleParser({
    required this.url,
    required this.format,
    required this.schedule,
    required this.tracks,
    required this.days,
  });

  /// Factory constructor to scrape, parse, and initialize fields
  static Future<ScheduleParser> fromUrl(String url) async {
    // Fetch the content from the URL
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load schedule from $url');
    }

    final content = response.bodyBytes;
    final xmlDocument = XmlDocument.parse(String.fromCharCodes(content));

    // Parse the schedule
    final conferenceElement = xmlDocument.rootElement.getElement('conference');
    if (conferenceElement == null) {
      throw Exception('Missing <conference> element in schedule XML');
    }
    final schedule = Schedule.fromXml(conferenceElement);

    // Parse tracks
    final trackElements =
        xmlDocument.rootElement.getElement('tracks')?.childElements ?? [];
    final tracks = trackElements.map((track) => Track.fromXml(track)).toList();

    // Parse days
    final dayElements = xmlDocument.rootElement.findElements('day');
    final days = dayElements.map((day) => Day.fromXml(day, tracks)).toList();

    final format = ScheduleFormat.xml;

    return ScheduleParser(
      url: url,
      format: format,
      schedule: schedule,
      tracks: tracks,
      days: days,
    );
  }
}
