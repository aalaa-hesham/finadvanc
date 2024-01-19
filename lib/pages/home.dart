import 'package:advanc_task_10/pages/product.details.dart';
import 'package:advanc_task_10/providers/ads.provider.dart';
import 'package:advanc_task_10/providers/category.provider.dart';
import 'package:advanc_task_10/providers/app_auth.provider.dart';
import 'package:advanc_task_10/providers/product.provider.dart';
import 'package:advanc_task_10/widgets/carousel_slider_ex.dart';
import 'package:advanc_task_10/widgets/headline.widget.dart';
import 'package:advanc_task_10/widgets/home/category_row.home.widget.dart';
import 'package:advanc_task_10/widgets/product.widget.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            HeadlineWidget(title: 'Categories'),
            Consumer<CategoryProvider>(
              builder: (__, caegoryProvider, _) {
                return FutureBuilder(
                    future: caegoryProvider.getCategories(context, limit: 3),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error While Get Data');
                        } else if (snapshot.hasData) {
                          return CategoriesRowHome(
                            categories: snapshot.data ?? [],
                          );
                        } else {
                          return Text('No Data Found');
                        }
                      } else {
                        return Text(
                            'Connection Statue ${snapshot.connectionState}');
                      }
                    });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const HeadlineWidget(title: 'Latest'),
            const SizedBox(
              height: 10,
            ),
            Consumer<adsProvider>(
              builder: (__, adProvider, _) {
                return FutureBuilder(
                    future: adProvider.getads(context, limit: 3),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Error While Get Data');
                        } else if (snapshot.hasData) {
                          return CarouselSliderEx(
                            adsList: snapshot.data ?? [],
                            onBtnPressed: () {},
                          );
                        } else {
                          return const Text('No Data Found');
                        }
                      } else {
                        return Text(
                            'Connection Statue ${snapshot.connectionState}');
                      }
                    });
              },
            ),
            const HeadlineWidget(title: 'Products'),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Consumer<ProductProvider>(
                builder: (__, productProvider, _) {
                  return FutureBuilder(
                      future: productProvider.getProducts(context, limit: 3),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error While Get Data');
                          } else if (snapshot.hasData) {
                            return FlexibleGridView(
                              axisCount: GridLayoutEnum.threeElementsInRow,
                              shrinkWrap: true,
                              children: snapshot.data
                                      ?.map((e) => ProductWidget(
                                            product: e,
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ProductDetailsPage(
                                                            product: e,
                                                          )));
                                            },
                                          ))
                                      .toList() ??
                                  [],
                            );
                          } else {
                            return Text('No Data Found');
                          }
                        } else {
                          return Text(
                              'Connection Statue ${snapshot.connectionState}');
                        }
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
