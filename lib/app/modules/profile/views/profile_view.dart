import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final String profileUrl;

  ProfileView({super.key, this.profileUrl = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: AppColors.background,

      bottomNavigationBar: BottomNavbar(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerProfile(),
                // PROFILE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(profileUrl),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        controller.userNameText,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Orang Tua • Jakarta, Indonesia',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // PROFILE ANAK
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profil Anak',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F6F5F),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "https://imgs.search.brave.com/_MIsjyd9RWg5F5GEt75YFmNHQUhH416mHJBZlIoocLA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pMC53/cC5jb20vd3d3LnJ1/a2l0YS5jby9zdG9y/aWVzL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDIyLzA0L2ZvdG8t/bHVjdS1idWF0LXBy/b2ZpbC0uLmpwZz93/PTYwMCZzc2w9MQ",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Arka, 5 thn',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    smallTag(
                                      text: 'ASD SUPPORT',
                                      color: const Color(0xFFEBCB8E),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    smallTag(
                                      text: 'SPEECH THERAPY',
                                      color: const Color(0xFFAEEACD),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const IconButton(
                            onPressed: null, 
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Divider(color: Colors.grey.shade300),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Kemajuan Bulan Ini:',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF8B6B35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // RIWAYAT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Riwayat Aktivitas & Sesi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F6F5F),
                      ),
                    ),

                    Text('Filter', style: TextStyle(color: Colors.black54)),
                  ],
                ),

                const SizedBox(height: 20),

                activityCard(
                  icon: Icons.medical_services_outlined,
                  title: 'Terapi Okupasi',
                  subtitle: 'Klinik Tumbuh Kembang...',
                  date: 'Hari ini, 09:00',
                  color: const Color(0xFFAEEACD),
                ),

                const SizedBox(height: 16),

                activityCard(
                  icon: Icons.extension_outlined,
                  title: 'Latihan Sensorik Mandiri',
                  subtitle: 'Aktivitas di rumah • Arka',
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.RIWAYAT),
                      child: const Text(
                      'Lihat Seluruh Riwayat',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),),
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
                  onTap: () {
                    Get.toNamed(Routes.INFO_PRIBADI);
                  },
                ),

                const SizedBox(height: 14),

                settingItem(
                  icon: Icons.security,
                  title: 'Keamanan & Password',
                  onTap: () {
                    Get.toNamed(Routes.SECURITY_PASSWORD);
                  },
                ),

                const SizedBox(height: 30),

                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      backgroundColor: const Color(0xFFFFF1F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(24),

                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ICON
                                Container(
                                  width: 80,
                                  height: 80,

                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE5E5),
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red,
                                    size: 38,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // TITLE
                                const Text(
                                  'Keluar dari Akun?',
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F6F5F),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // DESCRIPTION
                                const Text(
                                  'Anda akan keluar dari akun Teraparent.\nPastikan semua aktivitas telah tersimpan.',
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // BUTTONS
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },

                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),

                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),

                                        child: const Text(
                                          'Batal',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          controller.logout();
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          elevation: 0,

                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),

                                        child: const Text(
                                          'Keluar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },

                    icon: const Icon(Icons.logout_rounded, color: Colors.red),

                    label: const Text(
                      'Keluar',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTag({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget smallTag({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          Text(date, style: const TextStyle(color: Colors.black54)),
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
            Icon(icon, color: const Color(0xFF2F6F5F)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
