import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  IconData icon;
  String text;
   InfoChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color:  Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFE53935),),
          SizedBox(width: 4,),
          Text(text, style: TextStyle(fontWeight: FontWeight.w500),)
        ],
      ),

    );
  }
}
