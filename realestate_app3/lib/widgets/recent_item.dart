import 'package:flutter/material.dart';
import 'package:realestate_app3/theme/color.dart';

import 'custom_image.dart';

class RecentItem extends StatelessWidget {
  const RecentItem({super.key, required this.data});
  // ignore: prefer_typing_uninitialized_variables
  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Row(
        children: [
          CustomImage(
            data["image"],
            radius: 20,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: _buildInfo(),
          )
        ],
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.place_outlined,
              size: 13,
            ),
            const SizedBox(
              width: 3,
            ),
            Expanded(
              child: Text(
                data["location"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data["price"],
          style: const TextStyle(
            fontSize: 13,
            color: AppColor.primary,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
