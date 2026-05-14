import 'package:get/get.dart';

class ScreeningController extends GetxController {

  RxInt currentPage = 0.obs;

  // TAHAP 1
  List<String> tahap1Questions = [

    'Apakah anak menoleh atau memberikan respon saat namanya dipanggil?',

    'Apakah anak dapat mengucapkan setidaknya 3 kata bermakna (mama, papa, mau)?',

    'Apakah anak mengerti instruksi sederhana seperti “ambil bola itu”?',

    'Apakah anak menunjukkan ketertarikan untuk berkomunikasi dengan orang lain?',

    'Apakah anak sering menunjuk benda yang dia inginkan menggunakan jari?',
  ];

  // TAHAP 2
  List<String> tahap2Questions = [

    'Apakah anak tampak kesulitan menjaga keseimbangan saat berdiri atau berjalan?',

    'Apakah anak menunjukkan reaksi berlebihan terhadap suara keras?',

    'Apakah anak mengalami kesulitan memegang benda kecil menggunakan ibu jari dan telunjuk?',

    'Apakah anak tampak menghindari tekstur makanan tertentu?',

    'Apakah anak sering menabrak benda atau orang saat beraktivitas?',
  ];

  // TAHAP 3
  List<String> tahap3Questions = [

    'Apakah anak menunjukkan ketertarikan pada anak lain saat bermain?',

    'Apakah anak merespons saat namanya dipanggil oleh orang lain?',

    'Apakah anak suka berbagi mainan atau menunjukkan sesuatu kepada Anda?',

    'Apakah anak melakukan kontak mata saat berbicara atau berinteraksi?',

    'Apakah anak meniru tindakan sederhana seperti melambai atau bertepuk tangan?',
  ];

  void nextPage() {

    if (currentPage.value < 2) {
      currentPage.value++;
    }
  }

  void previousPage() {

    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
}