import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/modules/home/widgets/category_widget/bloc/category_bloc.dart';
import 'package:ticketing_flutter/modules/home/widgets/category_widget/category_item.dart';
import 'package:ticketing_flutter/modules/home/widgets/events_by_category_widget/bloc/event_by_category_bloc.dart';

class CategoriesSuccessWidget extends StatelessWidget {
  const CategoriesSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .15,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return CategoryItem(
                title: category.name,
                isActive: category.id == state.idSelected,
                onTap: () {
                  context.read<CategoryBloc>().add(SelectCategory(idSelected: category.id));
                  context.read<EventByCategoryBloc>().add(GetEventsByCategory(category.id));
                },
              );
            },
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, _) => SizedBox(
              width: 16.0,
            ),
            itemCount: state.categories.length,
          ),
        );
      },
    );
  }
}