import 'package:book_details/di/book_detail_provider.dart';
import 'package:book_details/presentation/widgets/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:remote/api_service.dart';

class MockApiService extends Mock implements ApiService {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late MockApiService mockApiService;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockApiService = MockApiService();
    mockLocalDataSource = MockLocalDataSource();
  });

  testWidgets('shows error screen when workKey is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BookDetailsProvider(workKey: null),
      ),
    );

    expect(find.text('Missing workKey'), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets(
      'provides BookDetailsBloc and renders BookDetailsScreen when workKey is not null',
          (tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<ApiService>.value(value: mockApiService),
              Provider<LocalDataSource>.value(value: mockLocalDataSource),
            ],
            child: const MaterialApp(
              home: BookDetailsProvider(
                workKey: 'work_123',
                coverUrl: 'cover.jpg',
                author: 'Author Name',
              ),
            ),
          ),
        );

        // Allow the widget tree to settle
        await tester.pumpAndSettle();

        expect(find.byType(BookDetailsScreen), findsOneWidget);

        final screen =
        tester.widget<BookDetailsScreen>(find.byType(BookDetailsScreen));
        expect(screen.workKey, 'work_123');
        expect(screen.coverUrl, 'cover.jpg');
        expect(screen.author, 'Author Name');
      });
}
