import 'package:demo_base_riverpod_1/data/providers/home_data_source_provider.dart';
import 'package:demo_base_riverpod_1/data/repositorys/home_repository_imp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeRepositoryProvider = Provider<HomeRepositoryImp>((ref) =>
    HomeRepositoryImp(homeDataSource: ref.read(homeDataSourceProvider)));
