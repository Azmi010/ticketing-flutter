import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/modules/explore/screen/explore_layout.dart';
import 'package:ticketing_flutter/modules/explore/widgets/card_category_widget/bloc/card_category_bloc.dart';
import 'package:ticketing_flutter/modules/explore/widgets/curated_collections_widget/bloc/curated_collections_bloc.dart';
import 'package:ticketing_flutter/modules/explore/widgets/search_widget/bloc/search_bloc.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(),
          ),
          BlocProvider<CardCategoryBloc>(
            create: (context) => CardCategoryBloc(
              eventRepository: context.read<EventRepository>(),
            )..add(GetBrowseCategories()),
          ),
          BlocProvider<CuratedCollectionsBloc>(
            create: (context) => CuratedCollectionsBloc(
              eventRepository: context.read<EventRepository>(),
            )..add(GetCuratedCollections()),
          ),
        ],
        child: const ExploreLayout(),
      ),
    );
  }
}
