import 'package:flutter/material.dart';

Widget headerProfile() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          const Text(
            'Teraparent',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F6F5F),
            ),
          ),
        ],
      ),

      Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xffE6EFEA)),
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Color(0xFF2F6F5F),
            size: 22,
          ),
        ),
      ),
    ],
  );
}
