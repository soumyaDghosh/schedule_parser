// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'package:schedule_parser/src/utils.dart';
import 'package:xml/xml.dart';

class Track {
  final String name;
  final bool? onlineQa;

  const Track({
    required this.name,
    this.onlineQa,
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
