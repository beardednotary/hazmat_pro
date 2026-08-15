import 'dart:math';
import 'glossary_data.dart';
import 'placards_data.dart';
import 'un_numbers_data.dart';

enum QuizCategory { placards, unNumbers, glossary, mixed }

extension QuizCategoryLabel on QuizCategory {
  String get label => switch (this) {
        QuizCategory.placards => 'PLACARDS',
        QuizCategory.unNumbers => 'UN NUMBERS',
        QuizCategory.glossary => 'GLOSSARY',
        QuizCategory.mixed => 'MIXED',
      };
}

class QuizQuestion {
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  final QuizCategory category;
  final String? placardAsset;

  const QuizQuestion({
    required this.prompt,
    required this.choices,
    required this.correctIndex,
    required this.category,
    this.placardAsset,
  });

  String get correctAnswer => choices[correctIndex];
}

const int kQuizLength = 10;

/// Builds a shuffled session of [kQuizLength] questions (or fewer if the
/// category's underlying data can't support that many distinct questions).
List<QuizQuestion> buildQuizSession(QuizCategory category, {int? seed}) {
  final rng = seed == null ? Random() : Random(seed);
  final pool = switch (category) {
    QuizCategory.placards => _placardQuestions(rng),
    QuizCategory.unNumbers => _unNumberQuestions(rng),
    QuizCategory.glossary => _glossaryQuestions(rng),
    QuizCategory.mixed => [
        ..._placardQuestions(rng),
        ..._unNumberQuestions(rng),
        ..._glossaryQuestions(rng),
      ],
  };
  pool.shuffle(rng);
  return pool.take(kQuizLength).toList();
}

List<QuizQuestion> _placardQuestions(Random rng) {
  return kPlacards.map((p) {
    final distractors = (List<Placard>.from(kPlacards)..remove(p))..shuffle(rng);
    final choices = [p.name, ...distractors.take(3).map((d) => d.name)]..shuffle(rng);
    return QuizQuestion(
      prompt: 'What does this Class ${p.division} placard indicate?',
      choices: choices,
      correctIndex: choices.indexOf(p.name),
      category: QuizCategory.placards,
      placardAsset: p.assetPath,
    );
  }).toList();
}

List<QuizQuestion> _unNumberQuestions(Random rng) {
  final divisions = kPlacards.map((p) => p.name).toSet();
  return kUnNumbers.map((e) {
    final correctName = placardForDivision(e.hazardClass)?.name ?? 'Class ${e.hazardClass}';
    final distractors = (divisions.toList()..remove(correctName))..shuffle(rng);
    final choices = [correctName, ...distractors.take(3)]..shuffle(rng);
    return QuizQuestion(
      prompt: 'What hazard class is ${e.displayNumber} (${e.properShippingName})?',
      choices: choices,
      correctIndex: choices.indexOf(correctName),
      category: QuizCategory.unNumbers,
    );
  }).toList();
}

List<QuizQuestion> _glossaryQuestions(Random rng) {
  return kGlossary.map((entry) {
    final distractors = (List<GlossaryEntry>.from(kGlossary)..remove(entry))..shuffle(rng);
    final choices = [entry.definition, ...distractors.take(3).map((d) => d.definition)]
      ..shuffle(rng);
    return QuizQuestion(
      prompt: 'What does "${entry.term}" mean?',
      choices: choices,
      correctIndex: choices.indexOf(entry.definition),
      category: QuizCategory.glossary,
    );
  }).toList();
}
