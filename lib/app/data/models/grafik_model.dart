class WeeklyActivityStatsModel {
  final double progressPercent;
  final int completedActivity;
  final int totalActivity;

  WeeklyActivityStatsModel({
    required this.progressPercent,
    required this.completedActivity,
    required this.totalActivity,
  });

  factory WeeklyActivityStatsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyActivityStatsModel(
      progressPercent:
          double.tryParse(json['progressPercent']?.toString() ?? '0') ?? 0,
      completedActivity:
          int.tryParse(json['completedActivity']?.toString() ?? '0') ?? 0,
      totalActivity:
          int.tryParse(json['totalActivity']?.toString() ?? '0') ?? 0,
    );
  }

  static WeeklyActivityStatsModel empty() => WeeklyActivityStatsModel(
        progressPercent: 0,
        completedActivity: 0,
        totalActivity: 0,
      );
}

class ScreeningRadarModel {
  final List<String> labels;
  final List<double> values;

  ScreeningRadarModel({
    required this.labels,
    required this.values,
  });

  factory ScreeningRadarModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ScreeningRadarModel(labels: const [], values: const []);
    }

    final rawLabels = json['labels'];
    final rawValues = json['values'];

    final labels = rawLabels is List
        ? rawLabels.map((e) => e.toString()).toList()
        : <String>[];

    final values = rawValues is List
        ? rawValues
            .map((e) => double.tryParse(e.toString()) ?? 0.0)
            .toList()
        : <double>[];

    return ScreeningRadarModel(labels: labels, values: values);
  }

  bool get isEmpty => labels.isEmpty || values.isEmpty;
}

class ScreeningTrendPointModel {
  final String date; // format yyyy-MM-dd dari backend
  final double score;

  ScreeningTrendPointModel({
    required this.date,
    required this.score,
  });

  factory ScreeningTrendPointModel.fromJson(Map<String, dynamic> json) {
    return ScreeningTrendPointModel(
      date: json['date']?.toString() ?? '',
      score: double.tryParse(json['score']?.toString() ?? '0') ?? 0,
    );
  }

  /// Label tanggal singkat untuk sumbu-x chart, contoh: "01/07"
  String get shortLabel {
    final parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}';
    }
    return date;
  }
}
