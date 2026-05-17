import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/components/bottom_nav.dart';
import 'package:teraparent_mobile/app/components/card_daily_activity.dart';
import 'package:teraparent_mobile/app/components/colors.dart';
import '../controllers/activities_controller.dart';

class ActivitiesView extends GetView<ActivitiesController> {
  const ActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),

      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
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
                          'Aktivitas Hari Ini',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff202020),
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          '20 Mei 2025',
                          style: TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const SizedBox(height: 30),

              // ================= MOTORIK HALUS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.gesture, color: Color(0xff2F6F57)),

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

              DailyActivityCardSuccess(
                title: 'Menyusun Balok', 
                time: '09:00 WIB'),

              const SizedBox(height: 18),
              DailyActivityCardNone(
                label: 'Belum Dimulai',
                title: 'Mewarnai Pola',
                description: 'latihan mewarnai untuk melatih koordinasi mata dan tangan',
                time: '16.00',
                onStart: () {

                },
              ),
              const SizedBox(height: 32),

              // MOTORIK KASAR
              const Row(
                children: [
                  Icon(Icons.accessibility_new, color: Color(0xff2F6F57)),

                  SizedBox(width: 8),

                  Text(
                    'Motorik Kasar',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              DailyActivityCardSuccess(
                title: 'Bermain Bola', 
                time: '10:00 WIB'),
              const SizedBox(height: 18),
              DailyActivityCardNone(
                label: 'Belum Dimulai',
                title: 'Bersepeda',
                description: 'latihan bersepeda untuk melatih keseimbangan dan koordinasi',
                time: '15.00',
                onStart: () {

                },
              ),

              const SizedBox(height: 32),

              // KOMUNIKASI
              const Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: Color(0xff8B5E1A)),

                  SizedBox(width: 8),

                  Text(
                    'Komunikasi',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              DailyActivityCardNone(
                label: "Belum Dimulai", 
                title: "Mendongeng", 
                description: "latihan mendongeng untuk melatih kemampuan berbicara", 
                time: "14.00", 
                onStart: (){
                  
                }
                ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}