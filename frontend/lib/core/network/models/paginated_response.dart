/// Pagination metadata model.
class PaginationMeta {
  final int totalItems;
  final int itemCount;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  const PaginationMeta({
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalItems: json['totalItems'] as int? ?? 0,
      itemCount: json['itemCount'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
      currentPage: json['currentPage'] as int? ?? 1,
    );
  }
}

/// Paginated Collection Response Wrapper.
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginatedResponse({
    required this.items,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final itemsList = (json['items'] as List<dynamic>?)
            ?.map((item) => fromJsonT(item))
            .toList() ??
        [];
    final metaObj = json['meta'] != null
        ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
        : const PaginationMeta(
            totalItems: 0, itemCount: 0, itemsPerPage: 10, totalPages: 1, currentPage: 1);

    return PaginatedResponse<T>(items: itemsList, meta: metaObj);
  }
}
