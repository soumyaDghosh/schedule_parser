// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'src/day.dart';
import 'src/schedule.dart';
import 'src/track.dart';

export 'src/day.dart';
export 'src/schedule.dart';
export 'src/track.dart';
export 'src/event.dart';

enum ScheduleProvider { pentabarf, frab, indigo, custom }

enum ScheduleFormat { xml, json }

class ScheduleParser {
  final String url;
  final ScheduleFormat format;
  final Schedule schedule;
  final List<Track> tracks;
  final List<Day> days;
  final String responsePath;

  ScheduleParser({
    required this.url,
    required this.format,
    required this.schedule,
    required this.tracks,
    required this.days,
    required this.responsePath,
  });

  /// Creates a [ScheduleParser] instance from the given XML string.
  ///
  /// Parses the XML to extract the conference schedule, tracks, and days.
  /// Throws an [Exception] if the `conference` element is missing.
  ///
  /// [xml] is the XML string containing the schedule data.
  /// [url] is the URL from which the XML was retrieved.
  static Future<ScheduleParser> fromXml(String xmlPath, String url) async {
    // Parse the XML document
    XmlDocument xmlDocument =
        XmlDocument.parse(await File(xmlPath).readAsString());

    // Extract the conference element
    final conferenceElement = xmlDocument.rootElement.getElement('conference');
    if (conferenceElement == null) {
      throw Exception('Missing <conference> element in schedule XML');
    }

    // Parse the schedule from the conference element
    final schedule = Schedule.fromXml(conferenceElement);

    // Extract and parse track elements
    final trackElements =
        xmlDocument.rootElement.getElement('tracks')?.childElements ?? [];
    final tracks = trackElements.map((track) => Track.fromXml(track)).toList();

    // Extract and parse day elements
    final dayElements = xmlDocument.rootElement.findElements('day');
    final days = dayElements.map((day) => Day.fromXml(day, tracks)).toList();

    // Add event tracks to the tracks list if they are not already present
    for (final day in days) {
      for (final room in day.rooms) {
        if (room == null) {
          continue;
        }
        for (final event in room.events) {
          if (event == null) {
            continue;
          }
          if (!tracks.contains(event.track) && event.track != null) {
            tracks.add(event.track!);
          }
        }
      }
    }

    // Define the schedule format
    final format = ScheduleFormat.xml;

    // Return a new instance of ScheduleParser with the parsed data
    return ScheduleParser(
      url: url,
      format: format,
      schedule: schedule,
      tracks: tracks,
      days: days,
      responsePath: xmlPath,
    );
  }

  /// Factory constructor to retrieve, parse, and initialize a [ScheduleParser] from a given URL.
  ///
  /// Fetches the schedule content from the provided [url] and parses it as XML.
  /// Throws an [Exception] if the HTTP request fails or if the XML parsing encounters an error.
  ///
  /// Returns a [ScheduleParser] instance initialized with the parsed data.
  static Future<ScheduleParser> fromUrl(String url) async {
    final uri = Uri.parse(url);
    // Fetch the content from the URL
    final response = await http.get(uri);
    // Check if the request was successful
    if (response.statusCode != 200) {
      throw Exception('Failed to load schedule from $url');
    }

    // Get the response content as bytes
    final content = response.bodyBytes;

    // Attempt to parse the content as an XML document
    try {
      XmlDocument.parse(String.fromCharCodes(content));
    } catch (e) {
      // Throw an exception if XML parsing fails
      throw Exception("Failed to parse XML from $url. Error: ${e.toString()}");
    }

    final directory = await getExternalStorageDirectory();
    print(directory?.path);
    late final String filePath;
    if (directory == null) {
      throw Exception("Failed to get external storage directory");
    }
    XmlDocument xmlDocument = XmlDocument.parse(String.fromCharCodes(content));
    final element = xmlDocument.rootElement.getElement('conference');
    if (element == null) {
      throw Exception('Missing <conference> element in schedule XML');
    }
    Schedule schedule = Schedule.fromXml(element);
    filePath = "${directory.path}"
        "/${schedule.acronym}.xml";
    final file = File(filePath);
    await file.writeAsBytes(content);

    // Create and return a ScheduleParser instance using the parsed XML
    return fromXml(filePath, url);
  }
}
