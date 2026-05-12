import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/bottom_nav.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: controller.selectedIndex,

        onTap: (index) {
          controller.changeIndex(index);
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            'assets/images/profile.png',
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
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF2F6F5F),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PROFILE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [

                      Stack(
                        children: [

                          const CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                              'assets/images/profile.png',
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2F6F5F),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Budi Santoso',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Orang Tua • Jakarta, Indonesia',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [

                          buildTag(
                            text: 'Premium Member',
                            color: const Color(0xFFC5EBF5),
                          ),

                          const SizedBox(width: 10),

                          buildTag(
                            text: 'Joined Mar 2023',
                            color: const Color(0xFFE8E8E8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // PROFILE ANAK
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children:[

                    Text(
                      'Profil Anak',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F6F5F),
                      ),
                    ),

                     GestureDetector(
                      onTap: () {},
                      child: Text(
                        '+ Tambah Anak',
                        style: TextStyle(
                          color: Color(0xFF2F6F5F),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // CHILD CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/profile.png',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  'Arka, 5 thn',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [

                                    smallTag(
                                      text: 'ASD SUPPORT',
                                      color: const Color(
                                          0xFFEBCB8E),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [

                                    smallTag(
                                      text:
                                          'SPEECH THERAPY',
                                      color: const Color(
                                          0xFFAEEACD),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.edit),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Divider(
                        color: Colors.grey.shade300,
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: const [

                          Text(
                            'Kemajuan Bulan Ini:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            '+12%',
                            style: TextStyle(
                              color: Color(0xFF2F6F5F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 10,
                          backgroundColor:
                              Colors.grey.shade300,
                          valueColor:
                              const AlwaysStoppedAnimation(
                            Color(0xFF8B6B35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ADD CHILD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: const [

                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFEFEFEF),
                        child: Icon(
                          Icons.group_add_outlined,
                          color: Color(0xFF2F6F5F),
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Daftarkan profil anak lainnya untuk\nmelacak perkembangan yang personal.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // RIWAYAT
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [

                    Text(
                      'Riwayat Aktivitas & Sesi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F6F5F),
                      ),
                    ),

                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                activityCard(
                  icon: Icons.medical_services_outlined,
                  title: 'Terapi Okupasi',
                  subtitle:
                      'Klinik Tumbuh Kembang...',
                  date: 'Hari ini, 09:00',
                  color: const Color(0xFFAEEACD),
                ),

                const SizedBox(height: 16),

                activityCard(
                  icon: Icons.extension_outlined,
                  title: 'Latihan Sensorik Mandiri',
                  subtitle:
                      'Aktivitas di rumah • Arka',
                  date: 'Kemarin, 16:30',
                  color: const Color(0xFFEBCB8E),
                ),

                const SizedBox(height: 16),

                activityCard(
                  icon: Icons.bar_chart,
                  title: 'Evaluasi Speech Monthly',
                  subtitle: 'Dr. Siska, Sp.A • Arka',
                  date: '15 Nov 2023',
                  color: const Color(0xFFC5EBF5),
                ),

                const SizedBox(height: 20),

                // BUTTON
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Lihat Seluruh Riwayat',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'PENGATURAN AKUN',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                settingItem(
                  icon: Icons.person_outline,
                  title: 'Informasi Pribadi',
                  onTap: () {},
                ),

                const SizedBox(height: 14),

                settingItem(
                  icon: Icons.security,
                  title: 'Keamanan & Password',
                  onTap: () {},
                ),

                const SizedBox(height: 14),

                settingItem(
                  icon: Icons.notifications_none,
                  title: 'Pengaturan Notifikasi',
                  onTap: () {},
                ),

                const SizedBox(height: 30),

                Center(
                  child: TextButton.icon(
                    onPressed: (){
                      Get.defaultDialog(
                        title: 'Konfirmasi Keluar',
                        middleText:
                            'Apakah Anda yakin ingin keluar dari akun ini?',
                        textCancel: 'Batal',
                        textConfirm: 'Keluar',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          // Logika untuk keluar akun
                          Get.back();
                        },
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Keluar',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {

    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
      },

      child: Obx(() {

        bool active =
            controller.selectedIndex.value == index;

        return Container(
          padding: const EdgeInsets.symmetric(
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
                    ? const Color(0xFF2F6F5F)
                    : Colors.black54,
              ),

              const SizedBox(height: 4),

              Text(
                label,
                style: TextStyle(
                  color: active
                      ? const Color(0xFF2F6F5F)
                      : Colors.black54,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildTag({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget smallTag({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget activityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Text(
            date,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget settingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2F6F5F),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}