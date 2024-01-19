import 'package:advanc_task_10/models/ads_model.dart';
import 'package:advanc_task_10/widgets/custom_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselSliderEx extends StatefulWidget {
  final List<Ads> adsList; // List of Ads objects
  final void Function() onBtnPressed;

  const CarouselSliderEx({
    required this.adsList,
    required this.onBtnPressed,
    Key? key,
  }) : super(key: key);

  @override
  _CarouselSliderExState createState() => _CarouselSliderExState();
}

class _CarouselSliderExState extends State<CarouselSliderEx> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.adsList.length,
          itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
              buildSliderImage(index),
          options: CarouselOptions(
            height: 200,
            viewportFraction: .9,
            padEnds: false,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            onPageChanged: (index, _) {
              setState(() {
                this.index = index; // Update the index
              });
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        AnimatedSmoothIndicator(
          activeIndex: index,
          count: widget.adsList.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: Colors.brown,
          ),
        ),
      ],
    );
  }

  Widget buildSliderImage(int index) {
    Ads ad = widget.adsList[index]; // Get the Ads object at the current index
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.black)
        ),
        child: Stack(
          children: [
            Image.network(
              ad.picture ?? '', // Access the picture property of the Ads object
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Positioned(
              left: 20,
              top: 40,
              child: Text(
                'New Offers',
                style: TextStyle(
                  color: Color.fromARGB(255, 64, 203, 213),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: CustomButton(
                text: "SEE MORE",
                onBtnPressed: widget.onBtnPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}