import 'package:flutter_test/flutter_test.dart';
import 'package:home/presenatation/bloc/book_event.dart';

void main() {
  group('BookEvent', () {
    test('LoadBooksEvent props is empty', () {
      final event = LoadBooksEvent();

      expect(event.props, isEmpty);
    });

    test('Two LoadBooksEvent instances are equal', () {
      final event1 = LoadBooksEvent();
      final event2 = LoadBooksEvent();

      expect(event1, equals(event2));
    });

    test('LoadBooksEvent toString does not throw', () {
      final event = LoadBooksEvent();

      expect(() => event.toString(), returnsNormally);
    });
  });
}
