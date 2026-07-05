class ScreeningQuestionModel {
  final String id;
  final String question;
  final String domain;
  final List<ScreeningOptionModel> options;

  ScreeningQuestionModel({
    required this.id,
    required this.question,
    required this.domain,
    required this.options,
  });

  factory ScreeningQuestionModel.fromJson(Map<String, dynamic> json) {
    return ScreeningQuestionModel(
      id: json['id'].toString(),
      question: json['question']?.toString() ??
          json['questionText']?.toString() ??
          '',
      domain: json['domain']?.toString() ?? '',
      options: json['options'] is List
          ? (json['options'] as List)
              .map(
                (item) => ScreeningOptionModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }
}

class ScreeningOptionModel {
  final String id;
  final String label;
  final String value;
  final int score;

  ScreeningOptionModel({
    required this.id,
    required this.label,
    required this.value,
    required this.score,
  });

  factory ScreeningOptionModel.fromJson(Map<String, dynamic> json) {
    return ScreeningOptionModel(
      id: json['id'].toString(),
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      score: int.tryParse(json['score'].toString()) ?? 0,
    );
  }
}

class StartScreeningModel {
  final String sessionId;

  StartScreeningModel({
    required this.sessionId,
  });

  factory StartScreeningModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawSessionId = json['sessionId'] ??
        json['id'] ??
        json['session']?['id'] ??
        json['screeningSession']?['id'];

    return StartScreeningModel(
      sessionId: rawSessionId.toString(),
    );
  }
}

class ScreeningAnswerRequestModel {
  final String questionId;
  final String optionId;

  ScreeningAnswerRequestModel({
    required this.questionId,
    required this.optionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'optionId': optionId,
    };
  }
}

class SubmitScreeningRequestModel {
  final List<ScreeningAnswerRequestModel> answers;

  SubmitScreeningRequestModel({
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'answers': answers.map((item) => item.toJson()).toList(),
    };
  }
}

class ScreeningResultModel {
  final String id;
  final String childId;
  final String status;
  final int finalScore;
  final String mainIndication;
  final String riskCategory;
  final String priorityDomain;
  final String indicationSummary;
  final String resultDescription;
  final String recommendationText;
  final String disclaimerText;
  final int communicationSpeechScore;
  final int physicalMotorScore;
  final int cognitiveProblemSolvingScore;
  final int socialEmotionalScore;
  final DateTime? completedAt;

  ScreeningResultModel({
    required this.id,
    required this.childId,
    required this.status,
    required this.finalScore,
    required this.mainIndication,
    required this.riskCategory,
    required this.priorityDomain,
    required this.indicationSummary,
    required this.resultDescription,
    required this.recommendationText,
    required this.disclaimerText,
    required this.communicationSpeechScore,
    required this.physicalMotorScore,
    required this.cognitiveProblemSolvingScore,
    required this.socialEmotionalScore,
    this.completedAt,
  });

  factory ScreeningResultModel.fromJson(Map<String, dynamic> json) {
    final finalScore = int.tryParse(json['finalScore']?.toString() ?? '0') ?? 0;

    final communicationScore =
        int.tryParse(json['communicationSpeechScore']?.toString() ?? '0') ?? 0;
    final physicalScore =
        int.tryParse(json['physicalMotorScore']?.toString() ?? '0') ?? 0;
    final cognitiveScore =
        int.tryParse(json['cognitiveProblemSolvingScore']?.toString() ?? '0') ??
            0;
    final socialScore =
        int.tryParse(json['socialEmotionalScore']?.toString() ?? '0') ?? 0;

    final communicationPercentage = _percentageOrFallback(
      json['communicationSpeechPercentage'],
      communicationScore,
    );

    final physicalPercentage = _percentageOrFallback(
      json['physicalMotorPercentage'],
      physicalScore,
    );

    final cognitivePercentage = _percentageOrFallback(
      json['cognitiveProblemSolvingPercentage'],
      cognitiveScore,
    );

    final socialPercentage = _percentageOrFallback(
      json['socialEmotionalPercentage'],
      socialScore,
    );

    return ScreeningResultModel(
      id: json['id']?.toString() ?? '',
      childId: json['childId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      finalScore: finalScore,
      mainIndication: json['mainIndication']?.toString() ?? '',
      riskCategory: json['riskCategory']?.toString() ??
          _getRiskCategory(finalScore),
      priorityDomain: json['priorityDomain']?.toString() ??
          _getPriorityDomain(
            communicationPercentage: communicationPercentage,
            physicalPercentage: physicalPercentage,
            cognitivePercentage: cognitivePercentage,
            socialPercentage: socialPercentage,
          ),
      indicationSummary: json['indicationSummary']?.toString() ?? '',
      resultDescription: json['resultDescription']?.toString() ?? '',
      recommendationText: json['recommendationText']?.toString() ??
          json['recommendation']?.toString() ??
          '',
      disclaimerText: json['disclaimerText']?.toString() ??
          'Hasil screening ini bukan diagnosis final dan tidak menggantikan pemeriksaan profesional.',
      communicationSpeechScore: communicationScore,
      physicalMotorScore: physicalScore,
      cognitiveProblemSolvingScore: cognitiveScore,
      socialEmotionalScore: socialScore,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString())
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null),
    );
  }

  static int _percentageOrFallback(dynamic percentageValue, int score) {
    final percentage = int.tryParse(percentageValue?.toString() ?? '0') ?? 0;

    if (percentage > 0) {
      return percentage;
    }

    return (score * 10).clamp(0, 100);
  }

  static String _getRiskCategory(int finalScore) {
    if (finalScore <= 40) {
      return 'Risiko Rendah';
    }

    if (finalScore <= 70) {
      return 'Risiko Sedang';
    }

    return 'Risiko Tinggi';
  }

  static String _getPriorityDomain({
    required int communicationPercentage,
    required int physicalPercentage,
    required int cognitivePercentage,
    required int socialPercentage,
  }) {
    final scores = {
      'COMMUNICATION_SPEECH': communicationPercentage,
      'PHYSICAL_MOTOR': physicalPercentage,
      'COGNITIVE_PROBLEM_SOLVING': cognitivePercentage,
      'SOCIAL_EMOTIONAL': socialPercentage,
    };

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  @override
  String toString() {
    return 'ScreeningResultModel(finalScore: $finalScore, mainIndication: $mainIndication, riskCategory: $riskCategory, priorityDomain: $priorityDomain, recommendationText: $recommendationText)';
  }
}