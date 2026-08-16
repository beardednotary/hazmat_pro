import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../data/placards_data.dart';
import '../data/un_numbers_data.dart';
import '../models/identification_result.dart';
import '../services/history_service.dart';
import '../services/review_service.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';

const _kExampleQueries = ['UN1203', 'Chlorine', 'Sulfuric acid', 'UN3480'];

// Set after Vercel deployment
const _kApiUrl = 'https://dahvio.com/api/hazmat-assistant';
const _kApiSecret = String.fromEnvironment('HAZMAT_API_SECRET', defaultValue: '');

enum _State { idle, recording, analyzing, results, error, unavailable }

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  final _speech = SpeechToText();

  _State _state = _State.idle;
  String _transcript = '';
  IdentificationResult? _result;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    HistoryService.instance.addListener(_rebuild);
  }

  @override
  void dispose() {
    HistoryService.instance.removeListener(_rebuild);
    _speech.stop();
    super.dispose();
  }

  void _rebuild() => setState(() {});

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

    // Try the local UN Numbers list first — works offline and covers most
    // real queries (a UN number or a known shipping name) without a
    // network round-trip. Only free-text queries fall through to the AI.
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      final localMatches = kUnNumbers.where((e) => e.matchesQuery(trimmed));
      if (localMatches.isNotEmpty) {
        final result = IdentificationResult.fromLocalMatch(localMatches.first);
        setState(() {
          _result = result;
          _state = _State.results;
        });
        await HistoryService.instance.add(result);
        ReviewService.instance.onIdentifySuccess();
        return;
      }
    }

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
        final result = IdentificationResult.fromApiJson(json);
        setState(() {
          _result = result;
          _state = _State.results;
        });
        await HistoryService.instance.add(result);
        ReviewService.instance.onIdentifySuccess();
      } else {
        setState(() {
          _errorMsg = 'Server error ${response.statusCode}. Try again.';
          _state = _State.error;
        });
      }
    } on TimeoutException {
      setState(() {
        _errorMsg = 'Request timed out. No connection, and "$trimmed" isn\'t '
            'in the local UN Numbers list — try a UN number or exact shipping name.';
        _state = _State.error;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Could not connect. Try a UN number or exact shipping name '
            'to search the local list without network.';
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

  void _openHistoryItem(IdentificationResult result) {
    HapticFeedback.selectionClick();
    setState(() {
      _result = result;
      _state = _State.results;
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
            Semantics(
              button: true,
              label: _state == _State.recording ? 'Release to identify' : 'Hold to speak',
              hint: 'Hold down and speak, or use the rotor actions to start '
                  'and stop recording',
              customSemanticsActions: _state == _State.recording
                  ? {
                      CustomSemanticsAction(label: 'Stop and identify'): _stopAndAnalyze,
                    }
                  : {
                      CustomSemanticsAction(label: 'Start recording'): _startRecording,
                    },
              child: GestureDetector(
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
                  : 'Hold the button and speak a UN number, placard, or material name — e.g. "UN 1203" or "gasoline tanker rollover." Exact UN numbers and shipping names work offline.',
              style: HMTextStyles.dimBody.copyWith(height: 1.6),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kExampleQueries
                  .map((q) => GestureDetector(
                        onTap: () {
                          setState(() => _transcript = q);
                          _analyze(q);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: HMColors.surface,
                            border: Border.all(color: HMColors.border),
                          ),
                          child: Text(q, style: HMTextStyles.dataMono.copyWith(fontSize: 12)),
                        ),
                      ))
                  .toList(),
            ),
            if (HistoryService.instance.items.isNotEmpty) ...[
              const SizedBox(height: 20),
              _HistorySection(
                items: HistoryService.instance.items,
                onTap: _openHistoryItem,
                onClear: () => HistoryService.instance.clear(),
              ),
            ],
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
  final IdentificationResult result;
  const _IdCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final placard = placardForDivision(result.hazardClass);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: HMColors.headerBg,
        border: Border(left: BorderSide(color: HMColors.hazardYellow, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (placard != null) ...[
            SizedBox(width: 48, height: 48, child: SvgPicture.asset(placard.assetPath)),
            const SizedBox(width: 12),
          ],
          Expanded(
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
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final List<IdentificationResult> items;
  final ValueChanged<IdentificationResult> onTap;
  final VoidCallback onClear;

  const _HistorySection({required this.items, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('RECENT', style: HMTextStyles.sectionHeader.copyWith(fontSize: 10)),
            const Spacer(),
            GestureDetector(
              onTap: onClear,
              child: Text(
                'CLEAR',
                style: HMTextStyles.sectionHeader.copyWith(
                  fontSize: 10,
                  color: HMColors.dimText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: HMColors.surface, border: Border.all(color: HMColors.divider)),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) Container(height: 1, color: HMColors.divider),
                _HistoryRow(result: items[i], onTap: () => onTap(items[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final IdentificationResult result;
  final VoidCallback onTap;
  const _HistoryRow({required this.result, required this.onTap});

  String get _relativeTime {
    final diff = DateTime.now().difference(result.queriedAt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final placard = placardForDivision(result.hazardClass);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            if (placard != null) ...[
              SizedBox(width: 28, height: 28, child: SvgPicture.asset(placard.assetPath)),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(result.material, style: HMTextStyles.bodyText, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            Text(_relativeTime, style: HMTextStyles.dataMono.copyWith(fontSize: 10)),
          ],
        ),
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
