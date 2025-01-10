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
