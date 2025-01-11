// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'dart:io';
import 'dart:math';

import 'package:schedule_parser/schedule_parser.dart';
import 'package:test/test.dart';

void main() {
  group('ScheduleParser.fromUrl for Pentabarf', () {
    test('returns non-null schedule', () async {
      final schedule =
          await ScheduleParser.fromUrl("https://fosdem.org/2025/schedule/xml");
      expect(schedule, isNotNull);
    });

    test('parses schedule title correctly', () async {
      final schedule =
          await ScheduleParser.fromUrl("https://fosdem.org/2025/schedule/xml");
      expect(schedule.schedule.title, "FOSDEM 2025");
    });

    test('parses schedule tracks correctly', () async {
      final schedule =
          await ScheduleParser.fromUrl("https://fosdem.org/2025/schedule/xml");
      expect(schedule.tracks, isNotEmpty);
    });

    test('parses first track name correctly', () async {
      final schedule =
          await ScheduleParser.fromUrl("https://fosdem.org/2025/schedule/xml");
      expect(schedule.tracks[0].name, "Lightning Talks");
    });

    test('parses events correctly', () async {
      final schedule =
          await ScheduleParser.fromUrl("https://fosdem.org/2025/schedule/xml");
      expect(
        schedule.days.first.rooms.first?.events.isEmpty,
        true,
      );
      expect(
        schedule.days.first.rooms[2]?.events.first?.title,
        "A New Approach to Callee-Saved Registers in LLVM",
      );
      expect(
        schedule.days.first.rooms[2]?.events.first?.track?.name,
        "LLVM",
      );
    });

    test('fails with invalid URL', () async {
      expect(() async => await ScheduleParser.fromUrl(" invalid-url "),
          throwsA(isA<ArgumentError>()));
    });

    test('fails with non-XML content', () async {
      expect(
          () async => await ScheduleParser.fromUrl(
              "https://fosdem.org/2025/schedule/non-xml"),
          throwsA(isA<Exception>()));
    });
  });

  group('ScheduleParser.fromUrl for Frab', () {
    final url = "https://programm.froscon.org/2024/schedule.xml";
    test('returns non-null schedule', () async {
      final schedule = await ScheduleParser.fromUrl(url);
      expect(schedule, isNotNull);
    });

    test('parses schedule title correctly', () async {
      final schedule = await ScheduleParser.fromUrl(url);
      expect(schedule.schedule.title, "FrOSCon 2024");
    });

    test('parses schedule tracks correctly', () async {
      final schedule = await ScheduleParser.fromUrl(url);
      expect(schedule.tracks, isEmpty);
    });
    test('parses events correctly', () async {
      final schedule = await ScheduleParser.fromUrl(url);
      expect(
        schedule.days.first.rooms.first?.events.isEmpty,
        false,
      );
      expect(
        schedule.days.first.rooms.first?.events.first?.title,
        "init",
      );
      expect(
        schedule.days.first.rooms.first?.events.first?.track?.name,
        "",
      );
    });

    test('fails with invalid URL', () async {
      expect(() async => await ScheduleParser.fromUrl(" invalid-url "),
          throwsA(isA<ArgumentError>()));
    });

    test('fails with non-XML content', () async {
      expect(
          () async => await ScheduleParser.fromUrl(
              "https://fosdem.org/2025/schedule/non-xml"),
          throwsA(isA<Exception>()));
    });
  });
}
