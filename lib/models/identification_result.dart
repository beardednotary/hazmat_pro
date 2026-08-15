import '../data/un_numbers_data.dart';

class IdentificationResult {
  final String material;
  final String unNumber;
  final String hazardClass;
  final String guideNumber;
  final List<String> isolationPpe;
  final List<String> responseGuidance;
  final String overall;
  final DateTime queriedAt;

  const IdentificationResult({
    required this.material,
    required this.unNumber,
    required this.hazardClass,
    required this.guideNumber,
    required this.isolationPpe,
    required this.responseGuidance,
    required this.overall,
    required this.queriedAt,
  });

  /// Built entirely from the local UN Numbers list — no network needed.
  /// Used so Identify still works for known materials while offline, and
  /// so the feature is testable before the AI backend exists.
  factory IdentificationResult.fromLocalMatch(UnEntry entry) {
    return IdentificationResult(
      material: entry.properShippingName,
      unNumber: entry.displayNumber,
      hazardClass: entry.hazardClass,
      guideNumber: entry.ergGuideNumber,
      isolationPpe: [
        'Consult ERG Guide ${entry.ergGuideNumber} for full isolation distances and PPE requirements.',
      ],
      responseGuidance: [entry.notes],
      overall: 'Matched from the local UN Numbers list — works offline, no network needed.',
      queriedAt: DateTime.now(),
    );
  }

  factory IdentificationResult.fromApiJson(Map<String, dynamic> json) {
    return IdentificationResult(
      material: json['material'] as String? ?? 'Unknown material',
      unNumber: json['un_number'] as String? ?? '',
      hazardClass: json['hazard_class'] as String? ?? '',
      guideNumber: json['guide_number'] as String? ?? '',
      isolationPpe: List<String>.from(json['isolation_ppe'] as List? ?? []),
      responseGuidance: List<String>.from(json['response_guidance'] as List? ?? []),
      overall: json['overall'] as String? ?? '',
      queriedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'material': material,
        'un_number': unNumber,
        'hazard_class': hazardClass,
        'guide_number': guideNumber,
        'isolation_ppe': isolationPpe,
        'response_guidance': responseGuidance,
        'overall': overall,
        'queried_at': queriedAt.toIso8601String(),
      };

  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    return IdentificationResult(
      material: json['material'] as String? ?? 'Unknown material',
      unNumber: json['un_number'] as String? ?? '',
      hazardClass: json['hazard_class'] as String? ?? '',
      guideNumber: json['guide_number'] as String? ?? '',
      isolationPpe: List<String>.from(json['isolation_ppe'] as List? ?? []),
      responseGuidance: List<String>.from(json['response_guidance'] as List? ?? []),
      overall: json['overall'] as String? ?? '',
      queriedAt: DateTime.tryParse(json['queried_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
