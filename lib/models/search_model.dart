/// Represents a search query for recipes
class SearchModel {
  /// Search term
  String search;

  /// Type of search (contains, starts, ends)
  String searchType;

  SearchModel({
    required this.search,
    required this.searchType,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'searchType': searchType,
    };
  }
}
