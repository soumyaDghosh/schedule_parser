// Copyright (C) 2024 Soumyadeep Ghosh
// This file is part of schedule_parser.
//
// shedule_parser is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License.
//
// schedule_parser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with schedule_parser. If not, see <https://www.gnu.org/licenses/>.

import 'package:xml/xml.dart';

enum ValueType { attribute, element }

String getValue(
  XmlElement element,
  String nameSpace, {
  ValueType valueType = ValueType.element,
  bool isRequired = false,
}) {
  switch (valueType) {
    case ValueType.attribute:
      final value = element.getAttribute(nameSpace);
      if (value != null) {
        return value.trim();
      }
      if (isRequired) {
        throw ArgumentError('Missing required attribute: $nameSpace');
      }
      return '';
    case ValueType.element:
      final elements = element.getElement(nameSpace);
      if (elements != null && elements.descendants.isNotEmpty) {
        return elements.innerText.trim();
      }
      if (isRequired) {
        throw ArgumentError('Missing required attribute: $nameSpace');
      }
      return '';
  }
}
