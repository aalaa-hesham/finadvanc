import 'package:advanc_task_10/models/ads_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class adsProvider {
  Future<List<Ads>?> getads(BuildContext context, {int? limit}) async {
    try {
      QuerySnapshot<Map<String, dynamic>>? result;
      if (limit != null) {
        result = await FirebaseFirestore.instance
            .collection('ads')
            .limit(limit)
            .get();
      } else {
        result = await FirebaseFirestore.instance.collection('ads').get();
      }

      if (result.docs.isNotEmpty) {
        var adsList = List<Ads>.from(
            result.docs.map((e) => Ads.fromJson(e.data(),e.id ))).toList();

        return adsList;
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