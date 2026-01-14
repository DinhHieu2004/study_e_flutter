class PageResponse<T> {
  final int pageNo;
  final int pageSize;
  final int totalPage;
  final int totalItems;
  final bool isLast;
  final List<T> items;

  const PageResponse({
    required this.pageNo,
    required this.pageSize,
    required this.totalPage,
    required this.totalItems,
    required this.isLast,
    required this.items,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawItems = (json['items'] as List<dynamic>? ?? const []);
    return PageResponse<T>(
      pageNo: (json['pageNo'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? rawItems.length,
      totalPage: (json['totalPage'] as num?)?.toInt() ?? 0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? rawItems.length,
      isLast: json['isLast'] as bool? ?? true,
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(fromJsonT)
          .toList(),
    );
  }
}
