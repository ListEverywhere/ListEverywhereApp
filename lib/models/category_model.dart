class CategoryModel {
  int categoryId;
  String categoryName;

  CategoryModel({this.categoryId = -1, this.categoryName = ''});

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryId = json['categoryId'],
        categoryName = json['categoryName'];

  @override
  bool operator ==(Object other) =>
      other is CategoryModel && other.categoryId == categoryId;
}
