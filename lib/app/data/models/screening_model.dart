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
  final String riskCategory;
  final String? mainIndication;
  final int finalScore;
  final String? priorityDomain;
  final String? recommendation;

  ScreeningResultModel({
    required this.riskCategory,
    this.mainIndication,
    required this.finalScore,
    this.priorityDomain,
    this.recommendation,
  });

  factory ScreeningResultModel.fromJson(Map<String, dynamic> json) {
    return ScreeningResultModel(
      riskCategory: json['riskCategory']?.toString() ??
          json['category']?.toString() ??
          json['risk_category']?.toString() ??
          '',
      mainIndication: json['mainIndication']?.toString() ??
          json['main_indication']?.toString(),
      finalScore: int.tryParse(
            json['finalScore']?.toString() ??
                json['final_score']?.toString() ??
                json['score']?.toString() ??
                '0',
          ) ??
          0,
      priorityDomain: json['priorityDomain']?.toString() ??
          json['priority_domain']?.toString(),
      recommendation: json['recommendation']?.toString() ??
          json['generalRecommendation']?.toString() ??
          json['generalRecommendationText']?.toString() ??
          json['general_recommendation']?.toString(),
    );
  }

  @override
  String toString() {
    return 'ScreeningResultModel(riskCategory: $riskCategory, mainIndication: $mainIndication, finalScore: $finalScore, priorityDomain: $priorityDomain, recommendation: $recommendation)';
  }
}