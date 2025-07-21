import 'package:design_system/book_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/book_display_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:home/presenatation/bloc/book_bloc.dart';
import 'package:home/presenatation/bloc/book_state.dart';
import 'package:home/presenatation/bloc/book_event.dart';
import 'package:home/presenatation/widgets/home_screen.dart';
import 'package:design_system/design_system.dart';
import 'package:local_db/local_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockBookBloc extends Mock implements BookBloc {}

void main() {
  late MockBookBloc mockBookBloc;

  setUpAll(() async {
    registerFallbackValue(LoadBooksEvent());
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // just init it once
    await LocalDatabase.init();
  });

  setUp(() {
    mockBookBloc = MockBookBloc();
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<BookBloc>.value(
        value: mockBookBloc,
        child: child,
      ),
    );
  }

  testWidgets('shows shimmer when state is BooksLoading', (tester) async {
    when(() => mockBookBloc.state).thenReturn(BooksLoading());
    when(() => mockBookBloc.stream).thenAnswer((_) => Stream.value(BooksLoading()));
    when(() => mockBookBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(buildTestable(const HomeScreen()));
    await tester.pump();

    expect(find.byType(BookCardShimmer), findsWidgets);
  });

  testWidgets('shows book cards when state is BooksLoaded', (tester) async {
    when(() => mockBookBloc.state).thenReturn(BooksLoaded([
      BookDisplayModel(url: 'url', title: 'title', author: 'author', key: 'key')
    ]));
    when(() => mockBookBloc.stream).thenAnswer((_) => Stream.value(mockBookBloc.state));
    when(() => mockBookBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(buildTestable(const HomeScreen()));
    await tester.pump();

    expect(find.byType(BookCard), findsOneWidget);
    expect(find.text('title'), findsOneWidget);
    expect(find.text('author'), findsOneWidget);
  });

  testWidgets('shows "No books found in DB" when BooksLoaded is empty', (tester) async {
    when(() => mockBookBloc.state).thenReturn(const BooksLoaded([]));
    when(() => mockBookBloc.stream).thenAnswer((_) => Stream.value(mockBookBloc.state));
    when(() => mockBookBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(buildTestable(const HomeScreen()));
    await tester.pump();

    expect(find.text('No books found in DB'), findsOneWidget);
  });

  testWidgets('shows error message when state is BooksError', (tester) async {
    when(() => mockBookBloc.state).thenReturn(const BooksError('error occurred'));
    when(() => mockBookBloc.stream).thenAnswer((_) => Stream.value(mockBookBloc.state));
    when(() => mockBookBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(buildTestable(const HomeScreen()));
    await tester.pump();

    expect(find.text('error occurred'), findsOneWidget);
  });
}
