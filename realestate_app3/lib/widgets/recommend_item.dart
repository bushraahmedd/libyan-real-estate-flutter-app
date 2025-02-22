import 'package:flutter/material.dart';
import 'package:realestate_app3/theme/color.dart';

import 'custom_image.dart';

class RecommendItem extends StatelessWidget {
  const RecommendItem({super.key, required this.data, required Null Function() onTap});
  // ignore: prefer_typing_uninitialized_variables
  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 130,
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          CustomImage(
            data["image"],
            radius: 20,
            width: double.infinity,
            height: double.infinity,
          ),
          _buildOverlay(),
          Positioned(
            bottom: 12,
            left: 10,
            child: _buildInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(.8),
            Colors.white.withOpacity(.01),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data["name"],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Icon(
              Icons.place_outlined,
              color: Colors.white,
              size: 13,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              data["location"],
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
