import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:search/di/search_provider.dart';

import 'package:search/presentation/widgets/search_screen.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:remote/api_service.dart'; // adjust import to your project structure

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  Widget buildTestable() {
    return MaterialApp(
      home: Provider<ApiService>.value(
        value: mockApiService,
        child: const SearchProvider(),
      ),
    );
  }

  testWidgets(
      'renders SearchScreen and provides SearchBloc when wrapped in ApiService',
          (tester) async {
        await tester.pumpWidget(buildTestable());
        await tester.pump();

        // verify that SearchScreen is rendered
        expect(find.byType(SearchScreen), findsOneWidget);

        // optionally, verify that the bloc is available in the context
        final BuildContext context = tester.element(find.byType(SearchScreen));
        final searchBloc = BlocProvider.of<SearchBloc>(context);
        expect(searchBloc, isNotNull);
        expect(searchBloc, isA<SearchBloc>());
      });
}
