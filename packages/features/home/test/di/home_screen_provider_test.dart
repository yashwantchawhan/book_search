import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/di/home_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:home/presenatation/bloc/book_bloc.dart';
import 'package:home/presenatation/widgets/home_screen.dart';
import 'package:local_db/local_data_source.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late MockLocalDataSource mockLocalDataSource;

  setUpAll(() {
    // Initialize sqflite for tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    mockLocalDataSource = MockLocalDataSource();
  });

  Widget createWidgetUnderTest() {
    return Provider<LocalDataSource>.value(
      value: mockLocalDataSource,
      child: const MaterialApp(
        home: HomeScreenProvider(),
      ),
    );
  }

  testWidgets(
      'renders HomeScreen and provides BookBloc when wrapped in LocalDataSource',
          (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // verify HomeScreen is present
        expect(find.byType(HomeScreen), findsOneWidget);

        // verify BookBloc is provided
        final bloc = BlocProvider.of<BookBloc>(
          tester.element(find.byType(HomeScreen)),
        );
        expect(bloc, isNotNull);
        expect(bloc, isA<BookBloc>());
      });
}
