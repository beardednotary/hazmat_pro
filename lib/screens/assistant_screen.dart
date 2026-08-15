import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../theme/hazmat_theme.dart';

// Set after Vercel deployment
const _kApiUrl = 'https://dahvio.com/api/hazmat-assistant';
const _kApiSecret = String.fromEnvironment('HAZMAT_API_SECRET', defaultValue: '');

enum _State { idle, recording, analyzing, results, error, unavailable }

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen>
    with SingleTickerProviderStateMixin {
  final _speech = SpeechToText();
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  _State _state = _State.idle;
  String _transcript = '';
  _Result? _result;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _initSpeech();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onError: (e) {
        if (mounted) setState(() => _state = _State.error);
      },
    );
    if (!available && mounted) {
      setState(() => _state = _State.unavailable);
    }
  }

  Future<void> _startRecording() async {
    if (_state == _State.recording || _state == _State.analyzing) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _state = _State.recording;
      _transcript = '';
      _result = null;
    });
    _speech.listen(
      onResult: (result) {
        if (mounted) setState(() => _transcript = result.recognizedWords);
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        localeId: 'en_US',
      ),
    );
  }

  Future<void> _stopAndAnalyze() async {
    if (_state != _State.recording) return;
    await _speech.stop();
    HapticFeedback.lightImpact();

    if (_transcript.trim().isEmpty) {
      setState(() => _state = _State.idle);
      return;
    }

    await _analyze(_transcript);
  }

  Future<void> _analyze(String query) async {
    setState(() => _state = _State.analyzing);

    try {
      final response = await http
          .post(
            Uri.parse(_kApiUrl),
            headers: {
              'Content-Type': 'application/json',
              'x-hazmat-key': _kApiSecret,
            },
            body: jsonEncode({'query': query}),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _result = _Result.fromJson(json);
          _state = _State.results;
        });
      } else {
        setState(() {
          _errorMsg = 'Server error ${response.statusCode}. Try again.';
          _state = _State.error;
        });
      }
    } on TimeoutException {
      setState(() {
        _errorMsg = 'Request timed out. Check your connection.';
        _state = _State.error;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Could not connect. Try again.';
        _state = _State.error;
      });
    }
  }

  void _reset() {
    setState(() {
      _state = _State.idle;
      _transcript = '';
      _result = null;
      _errorMsg = '';
    });
  }

  String get _statusLabel => switch (_state) {
        _State.idle => 'READY',
        _State.recording => 'LISTENING',
        _State.analyzing => 'IDENTIFYING',
        _State.results => 'COMPLETE',
        _State.error => 'ERROR',
        _State.unavailable => 'UNAVAILABLE',
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status panel ─────────────────────────────────────────
          Container(
            color: HMColors.panelBg,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('STATUS', style: HMTextStyles.sectionHeader),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _state == _State.recording
                            ? HMColors.dangerRed
                            : _state == _State.results
                                ? const Color(0xFF30D158)
                                : HMColors.hazardYellow.withAlpha(120),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _statusLabel,
                      style: HMTextStyles.placardDisplay(fontSize: 13).copyWith(
                        color: _state == _State.recording
                            ? HMColors.dangerRed
                            : HMColors.hazardYellow,
                      ),
                    ),
                  ],
                ),
                if (_transcript.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: HMColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: HMColors.panelBorder),
                    ),
                    child: Text(
                      '"$_transcript"',
                      style: const TextStyle(
                        fontSize: 12,
                        color: HMColors.secondaryText,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(height: 1, color: HMColors.divider),

          const SizedBox(height: 32),

          // ── Hold button ──────────────────────────────────────────
          if (_state != _State.results)
            Center(
              child: GestureDetector(
                onLongPressStart: (_) => _startRecording(),
                onLongPressEnd: (_) => _stopAndAnalyze(),
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) {
                    final isRecording = _state == _State.recording;
                    final scale = isRecording ? _pulse.value : 1.0;
                    final glowAlpha = isRecording
                        ? (80 * _pulse.value).round()
                        : 30;
                    final glowColor = isRecording
                        ? HMColors.dangerRed
                        : HMColors.hazardYellow;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRecording
                              ? HMColors.dangerRed.withAlpha(220)
                              : HMColors.surface,
                          border: Border.all(
                            color: isRecording
                                ? HMColors.dangerRed
                                : HMColors.hazardYellow,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withAlpha(glowAlpha),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isRecording ? Icons.mic : Icons.mic_none,
                              size: 36,
                              color: isRecording
                                  ? Colors.white
                                  : HMColors.hazardYellow,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isRecording ? 'RELEASE' : 'HOLD',
                              style: HMTextStyles.sectionHeader.copyWith(
                                color: isRecording
                                    ? Colors.white
                                    : HMColors.hazardYellow,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          if (_state == _State.analyzing) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                'IDENTIFYING MATERIAL...',
                style: HMTextStyles.sectionHeader.copyWith(
                  color: HMColors.secondaryText,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],

          if (_state == _State.idle || _state == _State.unavailable) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _state == _State.unavailable
                    ? 'Speech recognition is not available on this device.'
                    : 'Hold the button and speak a UN number, placard, or material name — e.g. "UN 1203" or "gasoline tanker rollover."',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: HMColors.secondaryText,
                  height: 1.6,
                ),
              ),
            ),
          ],

          if (_state == _State.error) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMsg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: HMColors.dangerRed,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: _OutlineButton(label: 'TRY AGAIN', onTap: _reset),
            ),
          ],

          // ── Results ──────────────────────────────────────────────
          if (_state == _State.results && _result != null) ...[
            _IdCard(result: _result!),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (_result!.isolationPpe.isNotEmpty)
                    _ResultCard(
                      icon: Icons.shield_outlined,
                      title: 'ISOLATION & PPE',
                      color: HMColors.hazardYellow,
                      items: _result!.isolationPpe,
                    ),
                  if (_result!.responseGuidance.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _ResultCard(
                      icon: Icons.local_fire_department_outlined,
                      title: 'RESPONSE GUIDANCE',
                      color: HMColors.dangerRed,
                      items: _result!.responseGuidance,
                    ),
                  ],
                  if (_result!.overall.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: HMColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: HMColors.divider),
                      ),
                      child: Text(
                        _result!.overall,
                        style: const TextStyle(
                          fontSize: 13,
                          color: HMColors.primaryText,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _OutlineButton(label: 'ASK AGAIN', onTap: _reset),
                ],
              ),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  final _Result result;
  const _IdCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HMColors.panelBg,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('IDENTIFIED', style: HMTextStyles.sectionHeader),
              const Spacer(),
              if (result.guideNumber.isNotEmpty)
                Text(
                  'GUIDE ${result.guideNumber}',
                  style: HMTextStyles.sectionHeader.copyWith(
                    color: HMColors.hazardYellow,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(result.material, style: HMTextStyles.placardDisplay(fontSize: 24)),
          if (result.unNumber.isNotEmpty || result.hazardClass.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              [result.unNumber, result.hazardClass].where((s) => s.isNotEmpty).join(' · '),
              style: HMTextStyles.dataMono,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<String> items;

  const _ResultCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HMColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: HMTextStyles.sectionHeader.copyWith(
                    color: color,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: color.withAlpha(40)),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 5, color: color.withAlpha(180)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: HMColors.primaryText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: HMColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: HMColors.border),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: HMTextStyles.sectionHeader.copyWith(
            color: HMColors.hazardYellow,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _Result {
  final String material;
  final String unNumber;
  final String hazardClass;
  final String guideNumber;
  final List<String> isolationPpe;
  final List<String> responseGuidance;
  final String overall;

  const _Result({
    required this.material,
    required this.unNumber,
    required this.hazardClass,
    required this.guideNumber,
    required this.isolationPpe,
    required this.responseGuidance,
    required this.overall,
  });

  factory _Result.fromJson(Map<String, dynamic> json) {
    return _Result(
      material: json['material'] as String? ?? 'Unknown material',
      unNumber: json['un_number'] as String? ?? '',
      hazardClass: json['hazard_class'] as String? ?? '',
      guideNumber: json['guide_number'] as String? ?? '',
      isolationPpe: List<String>.from(json['isolation_ppe'] as List? ?? []),
      responseGuidance: List<String>.from(json['response_guidance'] as List? ?? []),
      overall: json['overall'] as String? ?? '',
    );
  }
}
