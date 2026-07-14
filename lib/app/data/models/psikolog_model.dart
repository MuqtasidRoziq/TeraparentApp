class PsikologModel {
  final String id;
  final String name;
  final String? title;
  final String type; // PSYCHOLOGIST, PSYCHIATRIST, THERAPIST
  final String? photo;
  final String specialization;
  final List<String> focusCategories;
  final List<String> serviceTypes;
  final String? experience; // e.g. "5 tahun"
  final String? education;
  final String? bio;
  final double rating;
  final String? practiceAddress;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? whatsappNumber;
  final String? instagramUrl;
  final String? websiteUrl;
  final bool isActive;

  PsikologModel({
    required this.id,
    required this.name,
    this.title,
    required this.type,
    this.photo,
    required this.specialization,
    required this.focusCategories,
    required this.serviceTypes,
    this.experience,
    this.education,
    this.bio,
    required this.rating,
    this.practiceAddress,
    this.city,
    this.latitude,
    this.longitude,
    this.whatsappNumber,
    this.instagramUrl,
    this.websiteUrl,
    required this.isActive,
  });

  factory PsikologModel.fromJson(Map<String, dynamic> json) {
    return PsikologModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      title: json['title']?.toString(),
      type: json['type']?.toString() ?? 'PSYCHOLOGIST',
      photo: json['photo']?.toString(),
      specialization: json['specialization']?.toString() ?? '',
      focusCategories: json['focusCategories'] != null
          ? List<String>.from(json['focusCategories'])
          : [],
      serviceTypes: json['serviceTypes'] != null
          ? List<String>.from(json['serviceTypes'])
          : [],
      experience: json['experience']?.toString(),
      education: json['education']?.toString(),
      bio: json['bio']?.toString(),
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      practiceAddress: json['practiceAddress']?.toString(),
      city: json['city']?.toString(),
      latitude: double.tryParse(json['latitude'].toString()),
      longitude: double.tryParse(json['longitude'].toString()),
      whatsappNumber: json['whatsappNumber']?.toString(),
      instagramUrl: json['instagramUrl']?.toString(),
      websiteUrl: json['websiteUrl']?.toString(),
      isActive: json['isActive'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'type': type,
      'photo': photo,
      'specialization': specialization,
      'focusCategories': focusCategories,
      'serviceTypes': serviceTypes,
      'experience': experience,
      'education': education,
      'bio': bio,
      'rating': rating,
      'practiceAddress': practiceAddress,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'whatsappNumber': whatsappNumber,
      'instagramUrl': instagramUrl,
      'websiteUrl': websiteUrl,
      'isActive': isActive,
    };
  }
}
