import 'package:local_db/book.dart';

class BookDetailsDisplayModel {
  final Book book;
  final bool isSaved;

  BookDetailsDisplayModel({required this.book,required this.isSaved});
}