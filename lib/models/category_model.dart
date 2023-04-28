/// A single category for recipes
class CategoryModel {
  /// ID number of the category
  int categoryId;

  /// Name of the category
  String categoryName;

  CategoryModel({this.categoryId = -1, this.categoryName = ''});

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryId = json['categoryId'],
        categoryName = json['categoryName'];

  @override
  bool operator ==(Object other) =>
      other is CategoryModel && other.categoryId == categoryId;
}
