import 'package:equatable/equatable.dart';

class SearchEventInput extends Equatable {
  final String? keyword;
  final String? location;
  final int? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;

  const SearchEventInput({
    this.keyword,
    this.location,
    this.categoryId,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (keyword != null && keyword!.isNotEmpty) {
      data['keyword'] = keyword;
    }
    if (location != null && location!.isNotEmpty) {
      data['location'] = location;
    }
    if (categoryId != null) {
      data['categoryId'] = categoryId;
    }
    if (startDate != null) {
      // Format: 2026-01-08T00:00:00Z (without milliseconds)
      data['startDate'] = '${startDate!.toUtc().toIso8601String().split('.').first}Z';
    }
    if (endDate != null) {
      // Format: 2026-01-08T23:59:59Z (end of day)
      final endOfDay = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
      data['endDate'] = '${endOfDay.toUtc().toIso8601String().split('.').first}Z';
    }
    
    return data;
  }

  SearchEventInput copyWith({
    String? keyword,
    String? location,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    bool clearKeyword = false,
    bool clearLocation = false,
    bool clearCategoryId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return SearchEventInput(
      keyword: clearKeyword ? null : (keyword ?? this.keyword),
      location: clearLocation ? null : (location ?? this.location),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  @override
  List<Object?> get props => [keyword, location, categoryId, startDate, endDate];
}
