import 'package:demo_base_riverpod_1/data/data_source/home_data_source.dart';
import 'package:demo_base_riverpod_1/data/dio/data_source.dart';
import 'package:demo_base_riverpod_1/data/models/book_model.dart';

class HomeDataSourceImp extends DataSource implements HomeDataSource {
  @override
  Future<List<BookModel>> getBook() async {
    await Future.delayed(
      Duration(milliseconds: 500),
    );

    return [
      BookModel(id: 1, name: 'Book 1', author: "Author 1"),
      BookModel(id: 2, name: 'Book 2', author: "Author 2"),
      BookModel(id: 3, name: 'Book 3', author: "Author 3"),
      BookModel(id: 4, name: 'Book 4', author: "Author 4"),
      BookModel(id: 5, name: 'Book 5', author: "Author 5"),
    ];
  }
}
