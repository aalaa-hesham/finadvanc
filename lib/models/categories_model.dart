
class CategoryData {
  String? id;
  String? title;
  String? description;
  String? image;
  int? shadowColor;
  List<int>? colors;
  DateTime? createdAt;

  CategoryData();

  CategoryData.fromJson(Map<String, dynamic> json, [String? docId]) {
    id = docId;
    title = json['title'];
    description = json['description'];
    image = json['image'];
    shadowColor = json['shadowColor'];
    // to treat with list colors
    colors = json['colors'] != null
        ? List<int>.from(json['colors'].map((e) => e))
        : null;

// if it can't equal null
    createdAt = json['createdAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            json['createdAt'].millisecondsSinceEpoch)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['shadowColor'] = shadowColor;
    data['colors'] = colors;
    data['createdAt'] = createdAt;
    return data;
  }
}