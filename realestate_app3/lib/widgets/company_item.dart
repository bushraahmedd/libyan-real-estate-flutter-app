import 'package:flutter/material.dart';
import 'package:realestate_app3/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';

class NearestItem extends StatelessWidget {
  const NearestItem({
    super.key,
    required this.data,
    this.bgColor = Colors.white,
    this.color = const Color.fromARGB(255, 12, 69, 255),
    this.selected = false,
    this.onTap,
  });

  final data;
  final Color bgColor;
  final Color color;
  final bool selected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 110,
          height: 110,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withOpacity(0.1),
                spreadRadius: .5,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(.3),
                ),
                child: Icon(data["icon"], color: color),
              ),
              const SizedBox(
                height: 8,
              ),
             SizedBox(height: 8),
          Text(
            data['name'],
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            data['location'],
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),)
    );
  }
}