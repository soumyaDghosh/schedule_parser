import 'package:schedule_parser/src/utils.dart';
import 'package:xml/xml.dart';

class Person {
  final int? id;
  final String name;

  const Person({
    required this.id,
    required this.name,
  });

  // Factory constructor to create a Person instance from an XML element
  factory Person.fromXml(XmlElement element) {
    final id =
        int.tryParse(getValue(element, 'id', valueType: ValueType.attribute));
    final name = element.innerText.trim();

    return Person(
      id: id,
      name: name,
    );
  }
}
