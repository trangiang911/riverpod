import 'package:demo_base_riverpod_1/data/data_source/home_data_source_imp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeDataSourceProvider =
    Provider<HomeDataSourceImp>((_) => HomeDataSourceImp());
