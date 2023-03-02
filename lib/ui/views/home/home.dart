import 'package:demo_base_riverpod_1/data/models/book_model.dart';
import 'package:demo_base_riverpod_1/ui/views/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(homeViewModelProvider);

          return viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : Consumer(
                  builder: (context, ref, child) {
                    final viewModel = ref.watch(homeViewModelProvider);

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          color: Colors.red,
                          child: Text(viewModel.books[index].name),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: viewModel.books.length,
                    );
                  },
                );
        },
      ),
    );
  }
}
