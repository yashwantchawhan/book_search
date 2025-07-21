import 'package:flutter_test/flutter_test.dart';
import 'package:search/presentation/bloc/search_events.dart';

void main() {
  group('FetchBooksEvent', () {
    const query = 'flutter';
    const page = 1;
    const limit = 10;

    test('should hold correct properties', () {
      const event = FetchBooksEvent(query: query, page: page, limit: limit);

      expect(event.query, query);
      expect(event.page, page);
      expect(event.limit, limit);
    });

    test('toString returns expected format', () {
      const event = FetchBooksEvent(query: query, page: page, limit: limit);

      expect(
        event.toString(),
        contains('FetchBooksEvent'),
        reason: 'should have a meaningful toString output',
      );
    });

    test('two events with same props are equal (if equality is implemented)',
        () {
      const event1 = FetchBooksEvent(query: query, page: page, limit: limit);
      const event2 = FetchBooksEvent(query: query, page: page, limit: limit);

      expect(event1, event2);
    });
  });
}
