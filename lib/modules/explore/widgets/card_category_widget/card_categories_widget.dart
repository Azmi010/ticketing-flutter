import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/card_category_bloc.dart';
import 'card_category_success_widget.dart';

class CardCategoriesWidget extends StatelessWidget {
  const CardCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCategoryBloc, CardCategoryState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status.isError) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('Failed to load categories'),
            ),
          );
        }

        if (state.status.isSuccess) {
          return const CardCategorySuccessWidget();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
