import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/services/user_services.dart';

Widget headerProfile() {
  final UserService userService = Get.find<UserService>();

  return Obx(() {
    final photoUrl = userService.userPhotoUrl.value;
    final hasPhoto = photoUrl.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xffD5F0E5),
              backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
              child: hasPhoto
                  ? null
                  : const Icon(
                      Icons.person,
                      color: Color(0xFF2F6F5F),
                    ),
            ),

            const SizedBox(width: 12),

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
            border: Border.all(
              color: const Color(0xffE6EFEA),
            ),
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
  });
}