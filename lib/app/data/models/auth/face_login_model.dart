class FaceAuthRequestModel {
  final List<double> embedding;

  FaceAuthRequestModel({required this.embedding});

  Map<String, dynamic> toJson() => {"embedding": embedding};
}
