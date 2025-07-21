import 'package:book_details/presentation/bloc/book_detail_bloc.dart';
import 'package:book_details/presentation/bloc/book_detail_event.dart';
import 'package:book_details/presentation/bloc/book_detail_state.dart';
import 'package:book_details/presentation/widgets/book_details_screen.dart';
import 'package:book_details/domain/book_detail_display_model.dart';
import 'package:local_db/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBookDetailsBloc extends Mock implements BookDetailsBloc {}

void main() {
  late MockBookDetailsBloc mockBloc;

  const workKey = 'work_123';
  const coverUrl = 'https://example.com/cover.jpg';
  const author = 'Author Name';

  final book = Book(
    key: workKey,
    title: 'Test Title',
    author: author,
    coverUrl: coverUrl,
    description: 'Test Description',
  );

  final bookDetails = BookDetailsDisplayModel(book: book, isSaved: false);

  setUpAll(() {
    registerFallbackValue(FetchBookDetailsEvent(
      key: workKey,
      coverUrl: coverUrl,
      author: author,
    ));
    registerFallbackValue(BookDetailsLoading());
  });

  setUp(() {
    mockBloc = MockBookDetailsBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<BookDetailsBloc>.value(
        value: mockBloc,
        child: const BookDetailsScreen(
          workKey: workKey,
          coverUrl: coverUrl,
          author: author,
        ),
      ),
    );
  }

  testWidgets('renders loading indicator when state is BookDetailsLoading', (tester) async {
    when(() => mockBloc.state).thenReturn(BookDetailsLoading());
    when(() => mockBloc.stream).thenAnswer((_) => const Stream<BookDetailsState>.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error text when state is BookDetailsError', (tester) async {
    when(() => mockBloc.state).thenReturn(BookDetailsError(message: 'Something went wrong'));
    when(() => mockBloc.stream).thenAnswer((_) => const Stream<BookDetailsState>.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });

  testWidgets('renders book details when state is BookDetailsLoaded', (tester) async {
    when(() => mockBloc.state).thenReturn(BookDetailsLoaded(bookDetail: bookDetails));
    when(() => mockBloc.stream).thenAnswer((_) => const Stream<BookDetailsState>.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('About This Book'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}
