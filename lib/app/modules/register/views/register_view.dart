import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/modules/login/views/login_view.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/logo.png',
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Teraparent',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F6F5F),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Teman terpercaya dalam perjalanan\n'
                  'tumbuh kembang si kecil yang\n'
                  'istimewa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Mulai langkah baru penuh harapan hari ini.',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      customField(
                        hint: 'John Doe',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Alamat Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      customField(
                        hint: 'nama@email.com',
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Kata Sandi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Obx(
                        () => TextField(
                          obscureText:
                              controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF4F4F4),
                            hintText: '••••••••',
                            prefixIcon:
                                const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed:
                                  controller.togglePassword,
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => Row(
                          children: [
                            Checkbox(
                              value:
                                  controller.isChecked.value,
                              onChanged:
                                  controller.toggleCheckbox,
                              activeColor:
                                  const Color(0xFF2F6F5F),
                            ),
                            const Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      'Saya setuju dengan ',
                                  children: [
                                    TextSpan(
                                      text:
                                          'Ketentuan & Kebijakan',
                                      style: TextStyle(
                                        color: Color(
                                            0xFF2F6F5F),
                                        decoration:
                                            TextDecoration
                                                .underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {Get.to(
                            () => LoginView
                          );
                          },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF2F6F5F),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

  Widget customField({
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}