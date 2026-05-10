import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2F6F5F),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [

              navItem(
                icon: Icons.home,
                label: 'Home',
                index: 0,
              ),

              navItem(
                icon: Icons.extension_outlined,
                label: 'Activities',
                index: 1,
              ),

              navItem(
                icon: Icons.trending_up,
                label: 'Development',
                index: 2,
              ),

              navItem(
                icon: Icons.person_outline,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                // HEADER
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [

                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          'Teraparent',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xFF2F6F5F),
                          ),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF2F6F5F),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [

                          const Text(
                            'Hello, Mama!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFAEEACD),
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                            child: const Text(
                              'Age 4.2',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Leo’s Journey",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F6F5F),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal,
                        child: Row(
                          children: [

                            buildTag(
                              text:
                                  'Speech Therapy',
                              color: const Color(
                                  0xFFD5EEF6),
                            ),

                            buildTag(
                              text:
                                  'Sensory Support',
                              color: const Color(
                                  0xFFF5D79B),
                            ),

                            buildTag(
                              text:
                                  'Active Goals',
                              color: const Color(
                                  0xFFAEEACD),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // TODAY FOCUS
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Today's Focus",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(0xFF2F6F5F),
                        ),
                      ),

                      const SizedBox(height: 20),

                      focusItem(
                        icon:
                            Icons.menu_book_outlined,
                        text:
                            'Morning Reading',
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [

                          const Icon(
                            Icons.check_circle,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 12),

                          Text(
                            'Fine Motor Practice',
                            style: TextStyle(
                              decoration:
                                  TextDecoration
                                      .lineThrough,
                              color:
                                  Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      focusItem(
                        icon:
                            Icons.yard_outlined,
                        text:
                            'Outdoor Sensory Walk',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NAVBAR ITEM
  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
      },
      child: Obx(
        () {
          bool active =
              controller.selectedIndex.value ==
                  index;

          return Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFFAEEACD)
                  : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [

                Icon(
                  icon,
                  color: active
                      ? const Color(
                          0xFF2F6F5F)
                      : Colors.black54,
                ),

                const SizedBox(height: 4),

                Text(
                  label,
                  style: TextStyle(
                    color: active
                        ? const Color(
                            0xFF2F6F5F)
                        : Colors.black54,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // TAG
  Widget buildTag({
    required String text,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }

  // FOCUS ITEM
  Widget focusItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [

        Icon(icon),

        const SizedBox(width: 12),

        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}