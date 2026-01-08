import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/models/category_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/modules/explore/widgets/search_widget/bloc/search_bloc.dart';

class SearchFiltersWidget extends StatefulWidget {
  const SearchFiltersWidget({super.key});

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  final TextEditingController _locationController = TextEditingController();
  List<Category> categories = [];
  bool isLoadingCategories = true;
  String? selectedLocation;
  int? selectedCategoryId;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    // Initialize from current state
    final state = context.read<SearchBloc>().state;
    _locationController.text = state.location;
    selectedLocation = state.location;
    selectedCategoryId = state.categoryId;
    selectedDateRange = (state.startDate != null && state.endDate != null)
        ? DateTimeRange(start: state.startDate!, end: state.endDate!)
        : null;
  }

  Future<void> _loadCategories() async {
    try {
      final eventRepository = EventRepository();
      final loadedCategories = await eventRepository.getCategories();
      setState(() {
        categories = loadedCategories;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Search Filters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Location Filter
          const Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location (e.g., Jakarta, Bali)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on),
              suffixIcon: _locationController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _locationController.clear();
                        setState(() => selectedLocation = '');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() => selectedLocation = value);
            },
          ),
          const SizedBox(height: 16),

          // Category Filter
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  hint: const Text('All Categories'),
                  value: selectedCategoryId,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCategoryId = value);
                  },
                ),
          const SizedBox(height: 16),

          // Date Range Filter
          const Text('Date Range', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: selectedDateRange,
              );
              
              if (picked != null) {
                setState(() => selectedDateRange = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDateRange == null
                          ? 'Select date range'
                          : '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}',
                    ),
                  ),
                  if (selectedDateRange != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() => selectedDateRange = null);
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _locationController.clear();
                      selectedLocation = null;
                      selectedCategoryId = null;
                      selectedDateRange = null;
                    });
                    context.read<SearchBloc>().add(ClearSearch());
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Apply all filters at once
                    if (selectedLocation != null && selectedLocation!.isNotEmpty) {
                      context.read<SearchBloc>().add(
                            SearchLocationChanged(location: selectedLocation!),
                          );
                    } else {
                      context.read<SearchBloc>().add(
                            SearchLocationChanged(location: ''),
                          );
                    }
                    
                    context.read<SearchBloc>().add(
                          SearchCategoryChanged(categoryId: selectedCategoryId),
                        );
                    
                    if (selectedDateRange != null) {
                      context.read<SearchBloc>().add(
                            SearchDateRangeChanged(
                              startDate: selectedDateRange!.start,
                              endDate: selectedDateRange!.end,
                            ),
                          );
                    }
                    
                    context.read<SearchBloc>().add(PerformSearch());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1967D2),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Helper function to show filter bottom sheet
void showSearchFilters(BuildContext context) {
  final searchBloc = context.read<SearchBloc>();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) => BlocProvider.value(
      value: searchBloc,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        child: const SearchFiltersWidget(),
      ),
    ),
  );
}
