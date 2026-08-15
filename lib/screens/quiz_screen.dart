import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/quiz_data.dart';
import '../services/quiz_service.dart';
import '../services/review_service.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/hazmat_header.dart';

enum _QuizState { selecting, active, results }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  _QuizState _state = _QuizState.selecting;
  QuizCategory? _category;
  List<QuizQuestion> _questions = [];
  int _index = 0;
  int _score = 0;
  int? _selectedChoice;

  void _start(QuizCategory category) {
    HapticFeedback.selectionClick();
    setState(() {
      _category = category;
      _questions = buildQuizSession(category);
      _index = 0;
      _score = 0;
      _selectedChoice = null;
      _state = _QuizState.active;
    });
  }

  void _selectChoice(int i) {
    if (_selectedChoice != null) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedChoice = i;
      if (i == _questions[_index].correctIndex) _score++;
    });
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _selectedChoice = null;
    });
  }

  Future<void> _finish() async {
    final category = _category!;
    await QuizService.instance.recordScore(category, _score);
    if (_score / _questions.length >= 0.7) {
      ReviewService.instance.onQuizStrongScore();
    }
    setState(() => _state = _QuizState.results);
  }

  void _backToCategories() {
    setState(() {
      _state = _QuizState.selecting;
      _category = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HMColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HazmatHeader(
              title: 'QUIZ',
              subtitle: 'CDL HAZMAT PRACTICE',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: switch (_state) {
                _QuizState.selecting => _CategoryPicker(onPick: _start),
                _QuizState.active => _QuizSession(
                    question: _questions[_index],
                    index: _index,
                    total: _questions.length,
                    selected: _selectedChoice,
                    onSelect: _selectChoice,
                    onNext: _next,
                  ),
                _QuizState.results => _Results(
                    category: _category!,
                    score: _score,
                    total: _questions.length,
                    onRetry: () => _start(_category!),
                    onChooseCategory: _backToCategories,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatefulWidget {
  final ValueChanged<QuizCategory> onPick;
  const _CategoryPicker({required this.onPick});

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  @override
  void initState() {
    super.initState();
    QuizService.instance.addListener(_rebuild);
  }

  @override
  void dispose() {
    QuizService.instance.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  static const _categories = [
    (QuizCategory.mixed, Icons.shuffle, 'A bit of everything'),
    (QuizCategory.placards, Icons.crop_square, 'Identify placards by class'),
    (QuizCategory.unNumbers, Icons.tag, 'Match UN numbers to hazard class'),
    (QuizCategory.glossary, Icons.menu_book_outlined, 'GHS/DOT terminology'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '10 questions, pulled from the app\'s own reference data.',
          style: HMTextStyles.dimBody.copyWith(height: 1.5),
        ),
        const SizedBox(height: 16),
        for (final (category, icon, blurb) in _categories) ...[
          _CategoryCard(
            category: category,
            icon: icon,
            blurb: blurb,
            bestScore: QuizService.instance.bestScoreFor(category),
            onTap: () => widget.onPick(category),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final IconData icon;
  final String blurb;
  final int bestScore;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.blurb,
    required this.bestScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: HMColors.surface,
          border: Border(left: BorderSide(color: HMColors.hazardYellow, width: 4)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: HMColors.hazardYellow),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.label, style: HMTextStyles.termLabel.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(blurb, style: HMTextStyles.dimBody),
                ],
              ),
            ),
            if (bestScore > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('BEST', style: HMTextStyles.sectionHeader.copyWith(fontSize: 8)),
                  Text(
                    '$bestScore/$kQuizLength',
                    style: HMTextStyles.dataMono.copyWith(color: HMColors.hazardYellow),
                  ),
                ],
              )
            else
              const Icon(Icons.chevron_right, size: 20, color: HMColors.dimText),
          ],
        ),
      ),
    );
  }
}

class _QuizSession extends StatelessWidget {
  final QuizQuestion question;
  final int index;
  final int total;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  const _QuizSession({
    required this.question,
    required this.index,
    required this.total,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selected != null;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'QUESTION ${index + 1} OF $total',
            style: HMTextStyles.sectionHeader.copyWith(fontSize: 10, color: HMColors.hazardYellow),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: LinearProgressIndicator(
              value: (index + (answered ? 1 : 0)) / total,
              minHeight: 3,
              backgroundColor: HMColors.divider,
              valueColor: const AlwaysStoppedAnimation(HMColors.hazardYellow),
            ),
          ),
          const SizedBox(height: 20),
          if (question.placardAsset != null)
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: SvgPicture.asset(question.placardAsset!, fit: BoxFit.contain),
              ),
            ),
          if (question.placardAsset != null) const SizedBox(height: 16),
          Text(question.prompt, style: HMTextStyles.screenTitle(fontSize: 18)),
          const SizedBox(height: 20),
          for (int i = 0; i < question.choices.length; i++) ...[
            _ChoiceButton(
              label: question.choices[i],
              state: !answered
                  ? _ChoiceState.neutral
                  : i == question.correctIndex
                      ? _ChoiceState.correct
                      : i == selected
                          ? _ChoiceState.incorrect
                          : _ChoiceState.disabled,
              onTap: () => onSelect(i),
            ),
            const SizedBox(height: 8),
          ],
          if (answered) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onNext,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: HMColors.hazardYellow,
                child: Center(
                  child: Text(
                    index + 1 >= total ? 'SEE RESULTS' : 'NEXT',
                    style: HMTextStyles.sectionHeader.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _ChoiceState { neutral, correct, incorrect, disabled }

class _ChoiceButton extends StatelessWidget {
  final String label;
  final _ChoiceState state;
  final VoidCallback onTap;

  const _ChoiceButton({required this.label, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (bg, border, text) = switch (state) {
      _ChoiceState.neutral => (HMColors.surface, HMColors.border, HMColors.primaryText),
      _ChoiceState.correct => (const Color(0xFF1B3B24), const Color(0xFF30D158), const Color(0xFF30D158)),
      _ChoiceState.incorrect => (const Color(0xFF3A1414), HMColors.dangerRed, HMColors.dangerRed),
      _ChoiceState.disabled => (HMColors.surface, HMColors.divider, HMColors.dimText),
    };
    return GestureDetector(
      onTap: state == _ChoiceState.neutral ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: bg, border: Border.all(color: border)),
        child: Text(label, style: HMTextStyles.bodyText.copyWith(color: text)),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final QuizCategory category;
  final int score;
  final int total;
  final VoidCallback onRetry;
  final VoidCallback onChooseCategory;

  const _Results({
    required this.category,
    required this.score,
    required this.total,
    required this.onRetry,
    required this.onChooseCategory,
  });

  String get _verdict {
    final pct = score / total;
    if (pct >= 0.9) return 'FIELD READY';
    if (pct >= 0.7) return 'SOLID';
    if (pct >= 0.5) return 'KEEP STUDYING';
    return 'REVIEW THE BASICS';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.label, style: HMTextStyles.sectionHeader.copyWith(color: HMColors.hazardYellow)),
            const SizedBox(height: 10),
            Text('$score/$total', style: HMTextStyles.screenTitle(fontSize: 48)),
            const SizedBox(height: 6),
            Text(_verdict, style: HMTextStyles.sectionHeader.copyWith(fontSize: 12, letterSpacing: 2)),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: HMColors.hazardYellow,
                child: Center(
                  child: Text(
                    'RETRY',
                    style: HMTextStyles.sectionHeader.copyWith(color: Colors.black, fontSize: 12, letterSpacing: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onChooseCategory,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: HMColors.surface, border: Border.all(color: HMColors.border)),
                child: Center(
                  child: Text(
                    'CHOOSE CATEGORY',
                    style: HMTextStyles.sectionHeader.copyWith(color: HMColors.hazardYellow, fontSize: 12, letterSpacing: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
