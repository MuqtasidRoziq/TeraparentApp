import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/terapist.dart';

class AhliTerapisController extends GetxController {
  // State untuk Bottom Navigation Bar
  var currentNavIndex = 1.obs;

  // State untuk filter kategori yang sedang aktif
  var selectedCategory = "Semua".obs;

  // List data terapis reactive
  var therapists = <Therapist>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTherapists();
  }

  void fetchTherapists() {
    therapists.assignAll([
      Therapist(
        name: "Dr. Sarah Anindita",
        role: "Terapis Wicara Senior",
        location: "Jakarta Selatan (2.4 km)",
        rating: 4.9,
        description:
            "Berpengalaman 10 tahun menangani keterlambatan bicara dan terapi anak.",
        imageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300",
      ),
      Therapist(
        name: "Budi Santoso, M.Psi",
        role: "Psikolog Anak & Remaja",
        location: "Tangerang Selatan (5.1 km)",
        rating: 4.8,
        description:
            "Fokus pada pengembangan perilaku adaptif dan dukungan emosional.",
        imageUrl:
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300",
      ),
      Therapist(
        name: "Lina Wijaya, S.Ft",
        role: "Terapis Okupasi",
        location: "Jakarta Pusat (3.8 km)",
        rating: 5.0,
        description:
            "Spesialis terapi integrasi sensorik dan kemandirian harian.",
        imageUrl:
            "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300",
      ),
    ]);
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }
}