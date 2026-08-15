import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';

class QuickRefScreen extends StatelessWidget {
  const QuickRefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        const _EmergencyContactCard(),
        const SizedBox(height: 16),
        const _RefSection(
          icon: Icons.crop_square,
          title: 'RESPONSE ZONES',
          accentColor: HMColors.dangerRed,
          items: [
            _RefItem(label: 'Hot Zone', detail: 'Contamination area — full PPE and SCBA required, entry/exit controlled'),
            _RefItem(label: 'Warm Zone', detail: 'Decon and staging area for entry teams — reduced contamination risk'),
            _RefItem(label: 'Cold Zone', detail: 'Safe area for command post, staging, and uncontaminated personnel'),
            _RefItem(label: 'Isolation Distance', detail: 'Minimum distance to keep the public back — see the ERG guide page for the specific material'),
            _RefItem(label: 'Protective Action Distance', detail: 'Downwind distance to consider evacuation or shelter-in-place'),
          ],
        ),
        SizedBox(height: 16),
        const _RefSection(
          icon: Icons.checklist_rtl,
          title: 'PACKING GROUPS',
          accentColor: HMColors.hazardYellow,
          items: [
            _RefItem(label: 'Packing Group I', detail: 'Great danger — highest risk substances within a hazard class'),
            _RefItem(label: 'Packing Group II', detail: 'Medium danger'),
            _RefItem(label: 'Packing Group III', detail: 'Minor danger — lowest risk substances within a hazard class'),
            _RefItem(label: 'Not all classes', detail: 'Classes 1, 2, 7, and some of 6.2/9 do not use packing groups'),
          ],
        ),
        SizedBox(height: 16),
        const _RefSection(
          icon: Icons.shield_outlined,
          title: 'PPE LEVELS (EPA)',
          accentColor: Color(0xFF5E9EFF),
          items: [
            _RefItem(label: 'Level A', detail: 'Fully encapsulated suit with SCBA — highest skin/respiratory protection'),
            _RefItem(label: 'Level B', detail: 'SCBA with chemical-resistant clothing — highest respiratory, lesser skin protection'),
            _RefItem(label: 'Level C', detail: 'Air-purifying respirator with chemical-resistant clothing — hazard must be known and within filter limits'),
            _RefItem(label: 'Level D', detail: 'Work uniform only — minimal or no respiratory/skin protection, no atmospheric hazard'),
          ],
        ),
        SizedBox(height: 16),
        const _RefSection(
          icon: Icons.grid_view,
          title: 'GHS PICTOGRAMS',
          accentColor: Color(0xFF30D158),
          items: [
            _RefItem(label: 'Flame', detail: 'Flammable, self-reactive, pyrophoric, or self-heating', asset: 'assets/ghs/flame.svg'),
            _RefItem(label: 'Flame Over Circle', detail: 'Oxidizer', asset: 'assets/ghs/flame_over_circle.svg'),
            _RefItem(label: 'Exploding Bomb', detail: 'Explosive or self-reactive substance', asset: 'assets/ghs/exploding_bomb.svg'),
            _RefItem(label: 'Gas Cylinder', detail: 'Gas under pressure — compressed, liquefied, or dissolved', asset: 'assets/ghs/gas_cylinder.svg'),
            _RefItem(label: 'Corrosion', detail: 'Corrosive to metal, skin, or eyes', asset: 'assets/ghs/corrosion.svg'),
            _RefItem(label: 'Skull & Crossbones', detail: 'Acute toxicity — can be fatal or cause harm at low doses', asset: 'assets/ghs/skull_crossbones.svg'),
            _RefItem(label: 'Health Hazard', detail: 'Carcinogen, respiratory sensitizer, reproductive toxicity, or organ toxicity', asset: 'assets/ghs/health_hazard.svg'),
            _RefItem(label: 'Exclamation Mark', detail: 'Irritant, skin sensitizer, or narcotic effects — lower acute hazard', asset: 'assets/ghs/exclamation_mark.svg'),
            _RefItem(label: 'Environment', detail: 'Hazardous to the aquatic environment (not required by OSHA, but common)', asset: 'assets/ghs/environment.svg'),
          ],
        ),
        SizedBox(height: 16),
        const _RefSection(
          icon: Icons.description_outlined,
          title: 'SDS 16 SECTIONS',
          accentColor: Color(0xFFFF9F0A),
          items: [
            _RefItem(label: '1–3', detail: 'Identification · Hazard(s) identification · Composition/ingredients'),
            _RefItem(label: '4–6', detail: 'First-aid measures · Fire-fighting measures · Accidental release measures'),
            _RefItem(label: '7–9', detail: 'Handling and storage · Exposure controls/PPE · Physical and chemical properties'),
            _RefItem(label: '10–12', detail: 'Stability and reactivity · Toxicological info · Ecological info'),
            _RefItem(label: '13–15', detail: 'Disposal considerations · Transport information · Regulatory information'),
            _RefItem(label: '16', detail: 'Other information, including the SDS revision date'),
          ],
        ),
        SizedBox(height: 16),
        const _RefSection(
          icon: Icons.local_shipping_outlined,
          title: 'PLACARDING & TRANSPORT',
          accentColor: Color(0xFFBF5AF2),
          items: [
            _RefItem(label: '1,001 lb Rule', detail: 'Table 2 materials generally require placarding above an aggregate 1,001 lbs on one vehicle'),
            _RefItem(label: 'Table 1 Materials', detail: 'Placarded at any quantity — includes Class 1.1–1.3, Division 2.3, and Class 7 highway route-controlled'),
            _RefItem(label: 'Shipping Papers', detail: 'Must list proper shipping name, hazard class, UN number, packing group, and quantity'),
            _RefItem(label: 'Emergency Contact', detail: 'A 24-hour number (e.g. CHEMTREC) must be reachable from shipping papers'),
          ],
        ),
        SizedBox(height: 16),
        const _RefSection(
          icon: Icons.warning_amber_rounded,
          title: 'USING THE ERG',
          accentColor: HMColors.hazardOrange,
          items: [
            _RefItem(label: 'Step 1', detail: 'ID the material by name, UN number, or placard'),
            _RefItem(label: 'Step 2', detail: 'Look up its 3-digit orange guide number'),
            _RefItem(label: 'Step 3', detail: 'Turn to that guide for isolation distances, fire/spill response, and first aid'),
            _RefItem(label: 'Step 4', detail: 'Check the Table of Initial Isolation & Protective Action Distances for a TIH release'),
          ],
        ),
      ],
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard();

  static const _chemtrecNumber = '18004249300';
  static const _chemtrecDisplay = '1-800-424-9300';

  Future<void> _call() => launchUrl(Uri(scheme: 'tel', path: _chemtrecNumber));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _call,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: HMColors.headerBg,
          border: Border(left: BorderSide(color: HMColors.dangerRed, width: 4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.phone_forwarded_outlined, size: 22, color: HMColors.dangerRed),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CALL CHEMTREC',
                    style: HMTextStyles.sectionHeader.copyWith(
                      color: HMColors.dangerRed,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(_chemtrecDisplay, style: HMTextStyles.bodyText),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: HMColors.dimText),
          ],
        ),
      ),
    );
  }
}

class _RefSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;
  final List<_RefItem> items;

  const _RefSection({
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return FieldCard(
      label: title,
      icon: icon,
      accent: accentColor,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) Container(height: 1, color: HMColors.divider),
            items[i]._build(accentColor),
          ],
        ],
      ),
    );
  }
}

class _RefItem {
  final String label;
  final String detail;
  final String? asset;

  const _RefItem({required this.label, required this.detail, this.asset});

  Widget _build(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (asset != null) ...[
            SizedBox(width: 26, height: 26, child: SvgPicture.asset(asset!)),
            const SizedBox(width: 10),
          ],
          SizedBox(
            width: asset != null ? 104 : 130,
            child: Text(
              label,
              style: HMTextStyles.codeLabel.copyWith(
                color: accent,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(detail, style: HMTextStyles.bodyText),
          ),
        ],
      ),
    );
  }
}
