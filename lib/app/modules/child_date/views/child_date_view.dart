import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_date_controller.dart';

class ChildDataView extends GetView<ChildDataController> {
  const ChildDataView({super.key});

  final Color primaryColor = const Color(0xFF2F7D69);
  final Color secondaryColor = const Color(0xFFAED9C8);
  final Color bgColor = const Color(0xFFF4F6F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              header(),
              const SizedBox(height: 24),
              illustrationSection(),
              const SizedBox(height: 24),
              formCard(),
              const SizedBox(height: 18),
              securityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: primaryColor,
              ),
            ),
            Text(
              "Teraparent",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: secondaryColor,
              child: Icon(
                Icons.person_outline,
                color: primaryColor,
              ),
            )
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Langkah 2 dari 3",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "Data Personal",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: 0.66,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor:
                AlwaysStoppedAnimation(primaryColor),
          ),
        )
      ],
    );
  }

  Widget illustrationSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 85,
          backgroundColor:
              secondaryColor.withOpacity(0.4),
          child: Image.asset(
            "assets/images/child.png",
            width: 120,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          "Mari kenal lebih dekat",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "Data ini membantu kami memberikan\nrekomendasi aktivitas dan jadwal terapi\nyang paling sesuai untuk si Kecil.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.6,
          ),
        )
      ],
    );
  }

  Widget formCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          buildField(
            "Nama Lengkap Anak",
            "Contoh: Budi Pratama",
            controller.namaAnakC,
            Icons.badge_outlined,
          ),
          buildField(
            "Usia (Tahun)",
            "5",
            controller.usiaC,
            Icons.cake_outlined,
          ),

          genderField(),

          buildField(
            "Tinggi Badan (cm)",
            "110",
            controller.tinggiC,
            Icons.straighten,
          ),
          buildField(
            "Berat Badan (kg)",
            "18",
            controller.beratC,
            Icons.monitor_weight_outlined,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.lanjutkan,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Lanjutkan >",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () {},
            child: Text(
              "Simpan Draft & Selesaikan Nanti",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildField(
    String title,
    String hint,
    TextEditingController textController,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget genderField() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          "Jenis Kelamin",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: genderButton("Laki"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: genderButton("Perem"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget genderButton(String value) {
    bool selected =
        controller.gender.value == value;

    return GestureDetector(
      onTap: () => controller.selectGender(value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? secondaryColor
              : Colors.grey.shade100,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selected
                ? primaryColor
                : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget securityCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1F4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Keamanan data adalah prioritas kami. Informasi anak Anda dienkripsi secara medis dan tidak akan dibagikan tanpa izin.",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}