import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/activities_controller.dart';

class ActivitiesView extends GetView<ActivitiesController> {
  const ActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      //==== APP BAR ====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.shade200,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Teraparent',
              style: TextStyle(
                color: Color(0xff2F6F57),
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ],
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.notifications_none,
              color: Colors.black87,
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Rencana\nMingguan',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202020),
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        '20 - 26 Mei 2024',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    circleButton(Icons.chevron_left),
                    const SizedBox(width: 10),
                    circleButton(Icons.chevron_right),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ================= DATE LIST =================
            SizedBox(
              height: 110,

              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [

                  dateCard(
                    day: 'Sen',
                    date: '20',
                    active: false,
                  ),

                  const SizedBox(width: 14),

                  dateCard(
                    day: 'Sel',
                    date: '21',
                    active: true,
                  ),

                  const SizedBox(width: 14),

                  dateCard(
                    day: 'Rab',
                    date: '22',
                    active: false,
                  ),

                  const SizedBox(width: 14),

                  dateCard(
                    day: 'Kam',
                    date: '23',
                    active: false,
                  ),

                  const SizedBox(width: 14),

                  dateCard(
                    day: 'Jum',
                    date: '24',
                    active: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= MOTORIK HALUS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Row(
                  children: [

                    Icon(
                      Icons.gesture,
                      color: Color(0xff2F6F57),
                    ),

                    SizedBox(width: 8),

                    Text(
                      'Motorik Halus',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xffBDEAF0),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Text(
                    '2 Aktivitas',
                    style: TextStyle(
                      color: Color(0xff2F6F57),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // CARD 1
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Row(
                children: [

                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffB8EBCF),
                          Color(0xffA8DDE7),
                        ],
                      ),
                    ),

                    child: const Icon(
                      Icons.toys,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [

                        Text(
                          'Menyusun Balok',
                          style: TextStyle(
                            decoration:
                                TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          '10:00 - 10:30 WIB',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.check_circle,
                    color: Color(0xff2F6F57),
                    size: 28,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // CARD 2
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),

                border: Border.all(
                  color: const Color(0xffC8D6D1),
                  width: 2,
                ),
              ),

              child: Row(
                children: [

                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color: const Color(0xffBDEAF0),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Icon(
                      Icons.edit,
                      color: Color(0xff47616B),
                      size: 40,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [

                        Text(
                          'Mewarnai Pola',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          '14:00 - 14:45 WIB',
                          style: TextStyle(
                            color: Color(0xff355A60),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 10),

                        Row(
                          children: [

                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.black54,
                            ),

                            SizedBox(width: 4),

                            Text(
                              'Ruang Tengah',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // MOTORIK KASAR
            const Row(
              children: [

                Icon(
                  Icons.accessibility_new,
                  color: Color(0xff2F6F57),
                ),

                SizedBox(width: 8),

                Text(
                  'Motorik Kasar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // BIG CARD
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xffEDF5F2),
                borderRadius: BorderRadius.circular(30),

                border: Border.all(
                  color: const Color(0xffB7CBC6),
                  width: 2,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xff2F6F57),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),

                        child: const Text(
                          'SANGAT PENTING',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const Icon(Icons.more_vert),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Latihan Keseimbangan',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Latihan berjalan di garis lurus selama 15 menit dengan bantuan.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Divider(color: Colors.grey.shade300),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      const Row(
                        children: [

                          Icon(
                            Icons.access_time,
                            color: Color(0xff2F6F57),
                          ),

                          SizedBox(width: 8),

                          Text(
                            '16:00 WIB',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff2F6F57),

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                          ),

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),

                        onPressed: () {},

                        child: const Text(
                          'Mulai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // KOMUNIKASI
            const Row(
              children: [

                Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xff8B5E1A),
                ),

                SizedBox(width: 8),

                Text(
                  'Komunikasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Row(
                children: [

                  Container(
                    width: 70,
                    height: 70,

                    decoration: BoxDecoration(
                      color: const Color(0xffF8EEDC),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.record_voice_over,
                      color: Color(0xff8B5E1A),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [

                        Text(
                          'Flashcard Hewan',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Besok, 09:00 WIB',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      color: const Color(0xff2F6F57),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget dateCard({
    required String day,
    required String date,
    required bool active,
  }) {
    return Container(
      width: 84,

      decoration: BoxDecoration(
        color:
            active
                ? const Color(0xff2F6F57)
                : Colors.white,

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [

          Text(
            day,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color:
                  active
                      ? Colors.white
                      : Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            date,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color:
                  active
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget circleButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,

      decoration: const BoxDecoration(
        color: Color(0xffEDF3F1),
        shape: BoxShape.circle,
      ),

      child: Icon(
        icon,
        color: const Color(0xff4D6F67),
      ),
    );
  }
}