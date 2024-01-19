import 'package:advanc_task_10/models/ads_model.dart';
import 'package:advanc_task_10/utils/collections.utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class HomeProvider extends ChangeNotifier {
  List<Ads>? adList;

  void initHomeProvider() async {
    await getAds();
  }

  Future<void> getAds() async {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection(CollectionsUtils.ads.name)
        .get();
    adList =
        List<Ads>.from(result.docs.map((e) => Ads.fromJson(e.data(), e.id)));
    notifyListeners();
  }
}