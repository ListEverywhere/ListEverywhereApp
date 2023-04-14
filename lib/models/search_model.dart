class SearchModel {
  String search;
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
