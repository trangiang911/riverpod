import 'package:demo_base_riverpod_1/data/models/book_model.dart';

abstract class HomeRepository {
  //TODO: define method call api

  Future<List<BookModel>> getBook();
}
