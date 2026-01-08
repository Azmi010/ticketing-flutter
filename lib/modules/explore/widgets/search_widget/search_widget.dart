import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticketing_flutter/modules/home/screen/event_detail_screen.dart';
import 'bloc/search_bloc.dart';
import 'search_filters_widget.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Column(
          children: [
            // Search Bar
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color(0xFF5F6368),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search events, venue...',
                        hintStyle: TextStyle(
                          color: Color(0xFF5F6368),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      onChanged: (value) {
                        context.read<SearchBloc>().add(SearchQueryChanged(query: value));
                      },
                    ),
                  ),
                  if (state.query.isNotEmpty || state.location.isNotEmpty || 
                      state.categoryId != null || state.startDate != null || state.endDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        context.read<SearchBloc>().add(ClearSearch());
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  const SizedBox(width: 8),
                  // Filter Button
                  Container(
                    decoration: BoxDecoration(
                      color: (state.location.isNotEmpty || 
                              state.categoryId != null || 
                              state.startDate != null || 
                              state.endDate != null)
                          ? const Color(0xFF1967D2)
                          : const Color(0xFF5F6368).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        size: 20,
                        color: (state.location.isNotEmpty || 
                                state.categoryId != null || 
                                state.startDate != null || 
                                state.endDate != null)
                            ? Colors.white
                            : const Color(0xFF5F6368),
                      ),
                      onPressed: () {
                        showSearchFilters(context);
                      },
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      tooltip: 'Search Filters',
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Results
            if (state.status.isSearching)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.status.isError)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    state.errorMessage ?? 'An error occurred',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (state.status.isSuccess)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Active Filters Chips
                  if (state.location.isNotEmpty || 
                      state.categoryId != null || 
                      state.startDate != null || 
                      state.endDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (state.location.isNotEmpty)
                            _FilterChip(
                              label: 'Location: ${state.location}',
                              onDeleted: () {
                                context.read<SearchBloc>().add(
                                      SearchLocationChanged(location: ''),
                                    );
                              },
                            ),
                          if (state.categoryId != null)
                            _FilterChip(
                              label: 'Category ID: ${state.categoryId}',
                              onDeleted: () {
                                context.read<SearchBloc>().add(
                                      SearchCategoryChanged(categoryId: null),
                                    );
                              },
                            ),
                          if (state.startDate != null || state.endDate != null)
                            _FilterChip(
                              label: 'Date: ${state.startDate != null ? DateFormat('MMM dd').format(state.startDate!) : ''} - ${state.endDate != null ? DateFormat('MMM dd, yyyy').format(state.endDate!) : ''}',
                              onDeleted: () {
                                context.read<SearchBloc>().add(
                                      SearchDateRangeChanged(
                                        startDate: null,
                                        endDate: null,
                                      ),
                                    );
                              },
                            ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '${state.results.length} ${state.results.length == 1 ? 'event' : 'events'} found',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5F6368),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.results.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final event = state.results[index];
                      return _SearchResultCard(event: event);
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _FilterChip({
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: const Color(0xFFE8F0FE),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final dynamic event;
  
  const _SearchResultCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to event detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(eventId: event.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202124),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (event.categoryName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.categoryName!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1967D2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5F6368),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Color(0xFF5F6368),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5F6368),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Color(0xFF5F6368),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(event.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
              if (event.organizerName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Color(0xFF5F6368),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'By ${event.organizerName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5F6368),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
