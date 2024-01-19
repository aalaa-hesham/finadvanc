import 'package:advanc_task_10/models/categories_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CategoryProvider {
  Future<List<CategoryData>?> getCategories(BuildContext context,
      {int? limit}) async {
    try {
      QuerySnapshot<Map<String, dynamic>>? result;
      if (limit != null) {
        result = await FirebaseFirestore.instance
            .collection('categories')
            .limit(limit)
            .get();
      } else {
        result =
            await FirebaseFirestore.instance.collection('categories').get();
      }

      if (result.docs.isNotEmpty) {
        var categoriesList = List<CategoryData>.from(
                result.docs.map((e) => CategoryData.fromJson(e.data(), e.id)))
            .toList();

        return categoriesList;
      } else {
        return [];
      }
    } catch (e) {
      if (!context.mounted) return null;
      await QuickAlert.show(
          context: context, type: QuickAlertType.error, title: e.toString());
      return null;
    }
  }
}