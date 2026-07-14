import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/psikolog_model.dart';
import 'package:teraparent_mobile/app/data/services/psikolog_service.dart';

class AhliTerapisController extends GetxController {
  final PsikologService _psikologService = Get.find<PsikologService>();

  // State untuk Bottom Navigation Bar
  var currentNavIndex = 1.obs;

  // State untuk filter kategori yang sedang aktif
  var selectedCategory = "Semua".obs;

  // List data terapis reactive dari API
  var therapists = <PsikologModel>[].obs;

  // Loading & Error states
  var isLoading = false.obs;
  var errorMessage = "".obs;

  // Search query
  var searchQuery = "".obs;

  // TextEditingController untuk search input
  final searchController = TextEditingController();

  final Map<String, String> categoryToType = {
    "Semua": "",
    "Psikolog": "PSYCHOLOGIST",
    "Psikiater": "PSYCHIATRIST",
    "Terapis": "THERAPIST",
  };

  @override
  void onInit() {
    super.onInit();
    fetchTherapists();
    
    // Auto fetch when search query changes (with 500ms debounce)
    debounce(searchQuery, (_) => fetchTherapists(), time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchTherapists() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final type = categoryToType[selectedCategory.value] ?? "";
      final response = await _psikologService.getAllPsikolog(
        search: searchQuery.value,
        type: type,
      );
      
      if (response.success && response.data != null) {
        therapists.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchTherapists();
  }

  void searchPsychologists(String query) {
    searchQuery.value = query;
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }
}