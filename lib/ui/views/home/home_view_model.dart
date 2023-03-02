import 'package:demo_base_riverpod_1/data/models/book_model.dart';
import 'package:demo_base_riverpod_1/data/providers/home_repository_provider.dart';
import 'package:demo_base_riverpod_1/data/repositorys/home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeViewModelProvider = ChangeNotifierProvider(
    (ref) => HomeViewModel(ref.read(homeRepositoryProvider)));

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._homeRepository) {
    getBooks();
  }

  final HomeRepository _homeRepository;

  final List<BookModel> books = [];

  bool isLoading = false;

  Future<void> getBooks() async {
    isLoading = true;
    final res = await _homeRepository.getBook();
    books.addAll(res);
    isLoading = false;
  }
}
