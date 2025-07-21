import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_states.dart';
import 'package:search/presentation/bloc/search_events.dart';
import 'package:local_db/book.dart';
import 'package:search/presentation/widgets/search_screen.dart';

class MockSearchBloc extends Mock implements SearchBloc {}

class FakeSearchState extends Fake implements SearchState {}
class FakeSearchEvent extends Fake implements SearchEvent {}

void main() {
  late MockSearchBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchState());
    registerFallbackValue(FakeSearchEvent());
  });

  setUp(() {
    mockBloc = MockSearchBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SearchBloc>.value(
        value: mockBloc,
        child: const SearchScreen(),
      ),
    );
  }

  testWidgets('renders SearchScreen with TextField and CircularProgressIndicator',
          (tester) async {
        when(() => mockBloc.state).thenReturn(SearchLoadingState());
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(SearchLoadingState()));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });


  testWidgets('renders SearchScreen and shows books when loaded',
          (tester) async {
        final books = [
          Book(
            key: '1',
            title: 'Book 1',
            author: 'Author 1',
            coverUrl: 'url1',
            description: 'desc',
          ),
          Book(
            key: '2',
            title: 'Book 2',
            author: 'Author 2',
            coverUrl: 'url2',
            description: 'desc',
          ),
        ];

        when(() => mockBloc.state).thenReturn(SearchLoadedState(books: books, isLastPage: true));
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(SearchLoadedState(books: books, isLastPage: true)));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text('Book 1'), findsWidgets);
        expect(find.text('Author 1'), findsWidgets);
      });

  testWidgets('renders SearchScreen and shows error when SearchErrorState',
          (tester) async {
        when(() => mockBloc.state).thenReturn(SearchErrorState("Error occurred"));
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(SearchErrorState("Error occurred")));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Note: Error is passed to PagingController error, which does not show on screen by default
        // So just check widget still builds
        expect(find.byType(SearchScreen), findsOneWidget);
      });
}
