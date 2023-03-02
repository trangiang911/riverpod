import 'package:demo_base_riverpod_1/data/data_source/home_data_source.dart';
import 'package:demo_base_riverpod_1/data/data_source/home_data_source_imp.dart';
import 'package:demo_base_riverpod_1/data/models/book_model.dart';
import 'package:demo_base_riverpod_1/data/repositorys/home_repository.dart';

class HomeRepositoryImp implements HomeRepository {
  HomeRepositoryImp({required HomeDataSourceImp homeDataSource})
      : _homeDataSource = homeDataSource;

  final HomeDataSource _homeDataSource;

  @override
  Future<List<BookModel>> getBook() async {
    return await _homeDataSource.getBook();
  }
}
