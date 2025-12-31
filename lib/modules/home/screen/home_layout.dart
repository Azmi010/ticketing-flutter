import 'package:flutter/material.dart';
import 'package:ticketing_flutter/modules/home/widgets/all_events_widget/all_events_widget.dart';
import 'package:ticketing_flutter/modules/home/widgets/category_widget/categories_widget.dart';
import 'package:ticketing_flutter/modules/home/widgets/events_by_category_widget/events_by_category_widget.dart';
import 'package:ticketing_flutter/modules/home/widgets/header_title/home_header.dart';
import 'package:ticketing_flutter/modules/home/widgets/header_title/section_header.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(),
              const SizedBox(height: 20),

              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoriesWidget(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    SectionHeader(title: "Popular Now"),
                    const SizedBox(height: 12),

                    const SizedBox(
                      height: 260,
                      child: EventsByCategoryWidget(),
                    ),

                    SectionHeader(title: "Upcoming Nearby"),
                    const SizedBox(height: 12),

                    const AllEventsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
