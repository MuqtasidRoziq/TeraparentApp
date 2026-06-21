import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import '../controllers/child_date_controller.dart';

class ChildDataView extends GetView<ChildDataController> {
  const ChildDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              _buildIllustration(),
              const SizedBox(height: 24),
              _buildFormCard(),
              const SizedBox(height: 18),
              _buildSecurityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset("assets/images/child.png", width: 170),
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          "Mari kenal lebih dekat",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        const Text(
          "Data ini membantu kami memberikan\n"
          "rekomendasi aktivitas dan jadwal terapi\n"
          "yang paling sesuai untuk si Kecil.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _buildInputField(
            title: "Nama Lengkap Anak",
            hint: "Contoh: Budi Pratama",
            controllerText: controller.namaAnakC,
            icon: Icons.badge_outlined,
          ),

          _buildDateField(),

          _buildGenderField(),

          _buildInputField(
            title: "Tinggi Badan (cm)",
            hint: "110",
            controllerText: controller.tinggiC,
            icon: Icons.straighten,
            keyboardType: TextInputType.number,
          ),

          _buildInputField(
            title: "Berat Badan (kg)",
            hint: "18",
            controllerText: controller.beratC,
            icon: Icons.monitor_weight_outlined,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),

          _buildContinueButton(),

          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required String hint,
    required TextEditingController controllerText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 10),

        TextField(
          controller: controllerText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tanggal Lahir",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        Obx(
          () => GestureDetector(
            onTap: controller.selectDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.black54,
                  ),

                  const SizedBox(width: 12),

                  Text(
                    controller.selectedDate.value != null
                        ? "${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}"
                        : "Pilih Tanggal Lahir",
                    style: TextStyle(
                      color: controller.selectedDate.value != null
                          ? Colors.black87
                          : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGenderField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Jenis Kelamin",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),

      const SizedBox(height: 10),

      Obx(() {
        final selectedGender = controller.gender.value;

        return Row(
          children: [
            Expanded(
              child: _genderButton(
                value: "Laki-Laki",
                isSelected: selectedGender == "Laki-Laki",
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _genderButton(
                value: "Perempuan",
                isSelected: selectedGender == "Perempuan",
              ),
            ),
          ],
        );
      }),

      const SizedBox(height: 20),
    ],
  );
}

  Widget _genderButton({
  required String value,
  required bool isSelected,
}) {

  return GestureDetector(
    onTap: () {
      controller.selectGender(value);
      print("Gender sekarang: ${controller.gender.value}");
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 42, 107, 91) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color.fromARGB(255, 65, 151, 137) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildContinueButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.createChild,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(47, 125, 105, 1),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Lanjutkan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1F4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.security, color: AppColors.primary),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Keamanan data adalah prioritas kami. "
              "Informasi anak Anda dienkripsi secara medis "
              "dan tidak akan dibagikan tanpa izin.",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
