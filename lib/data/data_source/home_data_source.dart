import 'package:demo_base_riverpod_1/data/models/book_model.dart';

abstract class HomeDataSource {
  //TODO: add method

  Future<List<BookModel>>  getBook();
}