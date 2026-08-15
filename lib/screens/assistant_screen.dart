import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';

// Set after Vercel deployment
const _kApiUrl = 'https://dahvio.com/api/hazmat-assistant';
const _kApiSecret = String.fromEnvironment('HAZMAT_API_SECRET', defaultValue: '');

enum _State { idle, recording, analyzing, results, error, unavailable }

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _speech = SpeechToText();

  _State _state = _State.idle;
  String _transcript = '';
  _Result? _result;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
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

  Color get _statusColor => switch (_state) {
        _State.recording => HMColors.dangerRed,
        _State.results => const Color(0xFF30D158),
        _State.error => HMColors.dangerRed,
        _ => HMColors.hazardYellow,
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status row ───────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: _statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                _statusLabel,
                style: HMTextStyles.sectionHeader.copyWith(color: _statusColor, fontSize: 11),
              ),
            ],
          ),
          if (_transcript.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HMColors.surface,
                border: Border.all(color: HMColors.border),
              ),
              child: Text(
                '"$_transcript"',
                style: HMTextStyles.dimBody.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // ── Hold-to-speak button ─────────────────────────────────
          if (_state != _State.results)
            GestureDetector(
              onLongPressStart: (_) => _startRecording(),
              onLongPressEnd: (_) => _stopAndAnalyze(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: _state == _State.recording ? HMColors.dangerRed : HMColors.hazardYellow,
                  border: Border.all(
                    color: _state == _State.recording ? HMColors.dangerRed : HMColors.hazardYellow,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _state == _State.recording ? Icons.mic : Icons.mic_none,
                      size: 22,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _state == _State.recording ? 'RELEASE TO IDENTIFY' : 'HOLD TO SPEAK',
                      style: HMTextStyles.sectionHeader.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_state == _State.analyzing) ...[
            const SizedBox(height: 14),
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
            const SizedBox(height: 16),
            Text(
              _state == _State.unavailable
                  ? 'Speech recognition is not available on this device.'
                  : 'Hold the button and speak a UN number, placard, or material name — e.g. "UN 1203" or "gasoline tanker rollover."',
              style: HMTextStyles.dimBody.copyWith(height: 1.6),
            ),
          ],

          if (_state == _State.error) ...[
            const SizedBox(height: 14),
            Text(
              _errorMsg,
              style: HMTextStyles.dimBody.copyWith(color: HMColors.dangerRed),
            ),
            const SizedBox(height: 12),
            _OutlineButton(label: 'TRY AGAIN', onTap: _reset),
          ],

          // ── Results ──────────────────────────────────────────────
          if (_state == _State.results && _result != null) ...[
            const SizedBox(height: 4),
            _IdCard(result: _result!),
            const SizedBox(height: 12),
            if (_result!.isolationPpe.isNotEmpty)
              FieldCard(
                label: 'ISOLATION & PPE',
                icon: Icons.shield_outlined,
                accent: HMColors.hazardYellow,
                child: _BulletList(items: _result!.isolationPpe, color: HMColors.hazardYellow),
              ),
            if (_result!.responseGuidance.isNotEmpty) ...[
              const SizedBox(height: 10),
              FieldCard(
                label: 'RESPONSE GUIDANCE',
                icon: Icons.local_fire_department_outlined,
                accent: HMColors.dangerRed,
                child: _BulletList(items: _result!.responseGuidance, color: HMColors.dangerRed),
              ),
            ],
            if (_result!.overall.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: HMColors.surface,
                  border: Border.all(color: HMColors.divider),
                ),
                child: Text(
                  _result!.overall,
                  style: HMTextStyles.bodyText.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _OutlineButton(label: 'ASK AGAIN', onTap: _reset),
          ],
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
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: HMColors.headerBg,
        border: Border(left: BorderSide(color: HMColors.hazardYellow, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('IDENTIFIED', style: HMTextStyles.sectionHeader.copyWith(fontSize: 10)),
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
          Text(result.material, style: HMTextStyles.screenTitle(fontSize: 22)),
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

class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color color;
  const _BulletList({required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 5, color: color),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item, style: HMTextStyles.bodyText)),
                ],
              ),
            ),
          )
          .toList(),
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
          border: Border.all(color: HMColors.hazardYellow),
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
