import 'package:flutter/material.dart';

Widget headerProfile() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              "https://imgs.search.brave.com/QBk-dd-Zhpn11Mn8VSx0TDNUZ8P5GCCSKACvYdEdoMA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/ZGFpbHlzaWEuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDIx/LzEyL0lyZmFuLUdo/YWZ1ci02NjB4NDAw/LmpwZw",
            ),
          ),

          const SizedBox(width: 12),

          const Text(
            'Teraparent',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F6F5F),
            ),
          ),
        ],
      ),

      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications_none, color: Color(0xFF2F6F5F)),
      ),
    ],
  );
}
