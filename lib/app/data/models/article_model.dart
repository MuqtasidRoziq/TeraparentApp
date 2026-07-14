class ArticleModel {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime tanggalPublikasi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArticleModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.tanggalPublikasi,
    this.createdAt,
    this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      isi: json['isi']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      tanggalPublikasi: json['tanggalPublikasi'] != null
          ? DateTime.parse(json['tanggalPublikasi'].toString())
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'kategori': kategori,
      'tanggalPublikasi': tanggalPublikasi.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
