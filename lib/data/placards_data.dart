// Cross-checked 2026-08-14 against ERG2024's Hazard Classification System
// (p.6) and Table of Markings, Labels and Placards (p.7-9): all 9 class
// names/division numbers and placard colors confirmed against the official
// guide, including the 5.2 Organic Peroxide placard (corrected from solid
// yellow to the actual red-over-yellow split design). commonUnNumbers and
// handlingNotes text are original scaffold content, not sourced from a
// specific CFR/ERG line — fine for a UI hint, not a substitute for the
// guide itself.

class Placard {
  final String hazardClass; // "1", "2", "3" ...
  final String division; // "1.1", "2.3", "3" (no sub-division)
  final String name;
  final String colorHex; // background color, e.g. "FFE5342A"
  final String symbolDescription;
  final List<String> commonUnNumbers;
  final String description;
  final String handlingNotes;

  const Placard({
    required this.hazardClass,
    required this.division,
    required this.name,
    required this.colorHex,
    required this.symbolDescription,
    required this.commonUnNumbers,
    required this.description,
    required this.handlingNotes,
  });

  // Public-domain DOT placard artwork (Wikimedia Commons), one per division.
  String get assetPath => 'assets/placards/$division.svg';

  bool matchesQuery(String q) {
    final lower = q.toLowerCase();
    return division.toLowerCase().contains(lower) ||
        name.toLowerCase().contains(lower) ||
        commonUnNumbers.any((u) => u.contains(lower));
  }
}

const List<Placard> kPlacards = [
  Placard(
    hazardClass: '1',
    division: '1.1',
    name: 'Mass Explosion Hazard',
    colorHex: 'FFFF6D00',
    symbolDescription: 'Exploding bomb symbol, black on orange',
    commonUnNumbers: ['0004', '0027', '0081'],
    description: 'Explosives with a mass explosion hazard — the entire load can detonate essentially instantaneously.',
    handlingNotes: 'Extreme fire/detonation risk. Maintain maximum isolation distance and evacuate downwind. No open flame, static, or impact near the load.',
  ),
  Placard(
    hazardClass: '1',
    division: '1.2',
    name: 'Projection Hazard',
    colorHex: 'FFFF6D00',
    symbolDescription: 'Exploding bomb symbol, black on orange',
    commonUnNumbers: ['0009', '0035', '0107'],
    description: 'Explosives with a projection hazard but not a mass explosion hazard.',
    handlingNotes: 'Fragments can travel significant distances. Keep personnel behind cover; do not approach from the fragment-throw direction.',
  ),
  Placard(
    hazardClass: '1',
    division: '1.3',
    name: 'Fire / Minor Blast Hazard',
    colorHex: 'FFFF6D00',
    symbolDescription: 'Exploding bomb symbol, black on orange',
    commonUnNumbers: ['0335', '0357'],
    description: 'Explosives with a fire hazard and either minor blast or minor projection hazard.',
    handlingNotes: 'Includes most display fireworks. Radiant heat or moderate explosion risk — keep ignition sources well away.',
  ),
  Placard(
    hazardClass: '1',
    division: '1.4',
    name: 'No Significant Blast Hazard',
    colorHex: 'FFFF6D00',
    symbolDescription: 'Orange background, black "1.4" — no bomb symbol',
    commonUnNumbers: ['0012', '0014', '0336'],
    description: 'Explosives presenting only a small hazard, effects largely confined to the package.',
    handlingNotes: 'Common for small arms ammunition and consumer fireworks. Lower risk class, but package integrity still matters.',
  ),
  Placard(
    hazardClass: '1',
    division: '1.5',
    name: 'Very Insensitive, Mass Explosion Hazard',
    colorHex: 'FFFF6D00',
    symbolDescription: 'Orange background, black "1.5" — no bomb symbol',
    commonUnNumbers: ['0331', '0332'],
    description: 'Very insensitive substances with a mass explosion hazard — low probability of initiation under normal transport conditions.',
    handlingNotes: 'Primarily blasting agents. Low initiation risk in transport, but mass-explosion consequence if it does occur.',
  ),
  Placard(
    hazardClass: '1',
    division: '1.6',
    name: 'Extremely Insensitive Articles',
    colorHex: 'FFFF6D00',
    symbolDescription: 'Orange background, black "1.6" — no bomb symbol',
    commonUnNumbers: ['0486'],
    description: 'Extremely insensitive articles with no mass explosion hazard.',
    handlingNotes: 'Lowest risk explosive division. Negligible probability of accidental initiation or propagation.',
  ),
  Placard(
    hazardClass: '2',
    division: '2.1',
    name: 'Flammable Gas',
    colorHex: 'FFE5342A',
    symbolDescription: 'Flame symbol, white on red',
    commonUnNumbers: ['1075', '1978', '1011', '1001'],
    description: 'Compressed or liquefied gases that ignite readily and burn rapidly, such as propane and acetylene.',
    handlingNotes: 'Eliminate ignition sources. Vapors are often heavier than air and can travel to an ignition source and flash back.',
  ),
  Placard(
    hazardClass: '2',
    division: '2.2',
    name: 'Non-Flammable, Non-Toxic Gas',
    colorHex: 'FF2E9E4F',
    symbolDescription: 'Gas cylinder symbol, white on green',
    commonUnNumbers: ['1066', '1046', '1013', '1006'],
    description: 'Gases that are neither flammable nor toxic, including compressed and refrigerated liquefied gases like nitrogen and oxygen.',
    handlingNotes: 'Primary risks are asphyxiation in confined spaces and extreme cold from cryogenic liquids. Oxygen variants also support combustion.',
  ),
  Placard(
    hazardClass: '2',
    division: '2.3',
    name: 'Toxic Gas',
    colorHex: 'FFEAEAEA',
    symbolDescription: 'Skull and crossbones, black on white',
    commonUnNumbers: ['1017', '1005', '1079'],
    description: 'Gases known to be so toxic or corrosive to humans that they pose a hazard to health during transport.',
    handlingNotes: 'Requires respiratory protection and full isolation of the area. Evacuate and approach only with proper SCBA and training.',
  ),
  Placard(
    hazardClass: '3',
    division: '3',
    name: 'Flammable Liquid',
    colorHex: 'FFE5342A',
    symbolDescription: 'Flame symbol, white on red',
    commonUnNumbers: ['1203', '1202', '1170', '1223', '1863'],
    description: 'Liquids with a flash point at or below 60°C (140°F), including gasoline, diesel, and most fuels.',
    handlingNotes: 'Vapors are typically heavier than air and pool in low areas. Keep away from ignition sources and use foam or dry chemical for fires.',
  ),
  Placard(
    hazardClass: '4',
    division: '4.1',
    name: 'Flammable Solid',
    colorHex: 'FFFFFFFF',
    symbolDescription: 'Flame symbol, black on white with red vertical stripes',
    commonUnNumbers: ['1331', '1944', '2448'],
    description: 'Solids that are readily combustible or may cause fire through friction, including matches and certain metal powders.',
    handlingNotes: 'Keep dry and away from friction or sparks. Some self-reactive substances in this class also require temperature control.',
  ),
  Placard(
    hazardClass: '4',
    division: '4.2',
    name: 'Spontaneously Combustible',
    colorHex: 'FFFFFFFF',
    symbolDescription: 'Flame symbol, black on white-over-red split background',
    commonUnNumbers: ['1381', '2846'],
    description: 'Solids or liquids liable to spontaneous heating and ignition under normal transport conditions.',
    handlingNotes: 'Can ignite on exposure to air with no external ignition source. Keep containers sealed and away from oxygen exposure.',
  ),
  Placard(
    hazardClass: '4',
    division: '4.3',
    name: 'Dangerous When Wet',
    colorHex: 'FF2E6DE5',
    symbolDescription: 'Flame symbol, white/black on blue',
    commonUnNumbers: ['1402', '1428', '1409'],
    description: 'Substances that react with water to emit flammable or toxic gas, such as sodium and calcium carbide.',
    handlingNotes: 'Never use water on these materials or their fires. Use dry sand, dry chemical, or a Class D extinguisher instead.',
  ),
  Placard(
    hazardClass: '5',
    division: '5.1',
    name: 'Oxidizer',
    colorHex: 'FFFFD400',
    symbolDescription: 'Flame-over-circle symbol, black on yellow',
    commonUnNumbers: ['1490', '2067', '1942'],
    description: 'Substances that readily yield oxygen, intensifying combustion of other materials — includes many fertilizers.',
    handlingNotes: 'Keep away from fuels, flammables, and organic material. Contamination can cause violent decomposition or explosion.',
  ),
  Placard(
    hazardClass: '5',
    division: '5.2',
    name: 'Organic Peroxide',
    colorHex: 'FFE5342A',
    symbolDescription: 'Flame symbol, black on red-over-yellow split background',
    commonUnNumbers: ['3105', '3106'],
    description: 'Thermally unstable substances that can undergo exothermic self-accelerating decomposition.',
    handlingNotes: 'Many require refrigeration in transport. Sensitive to heat, contamination, friction, and impact — handle with strict temperature control.',
  ),
  Placard(
    hazardClass: '6',
    division: '6.1',
    name: 'Poison / Toxic Substance',
    colorHex: 'FFFFFFFF',
    symbolDescription: 'Skull and crossbones, black on white',
    commonUnNumbers: ['2810', '1994', '3172'],
    description: 'Liquids or solids capable of causing death or serious injury through inhalation, skin contact, or ingestion.',
    handlingNotes: 'Full PPE and respiratory protection required for any breach. Do not assume a small spill is low risk — assess the specific substance.',
  ),
  Placard(
    hazardClass: '6',
    division: '6.2',
    name: 'Infectious Substance',
    colorHex: 'FFFFFFFF',
    symbolDescription: 'Biohazard symbol, black on white',
    commonUnNumbers: ['2814', '2900', '3291'],
    description: 'Materials known or reasonably expected to contain pathogens capable of causing disease in humans or animals.',
    handlingNotes: 'Treat any breached packaging as a biohazard exposure risk. Follow bloodborne pathogen / biohazard protocols and notify medical control.',
  ),
  Placard(
    hazardClass: '7',
    division: '7',
    name: 'Radioactive',
    colorHex: 'FFFFD400',
    symbolDescription: 'Trefoil symbol, black on yellow-over-white',
    commonUnNumbers: ['2915', '2908', '3332'],
    description: 'Materials emitting ionizing radiation above regulatory thresholds, labeled Category I, II, or III based on radiation level.',
    handlingNotes: 'Do not linger near a breached or damaged package. Time, distance, and shielding are the core controls — contact radiation safety personnel.',
  ),
  Placard(
    hazardClass: '8',
    division: '8',
    name: 'Corrosive',
    colorHex: 'FFFFFFFF',
    symbolDescription: 'Liquid dripping onto hand and metal, black on white-over-black',
    commonUnNumbers: ['1830', '1789', '1824', '1823'],
    description: 'Substances that cause visible destruction of skin tissue or severely corrode metal on contact, including strong acids and bases.',
    handlingNotes: 'Chemical-resistant PPE required. Flush exposed skin/eyes with copious water and seek medical attention immediately.',
  ),
  Placard(
    hazardClass: '9',
    division: '9',
    name: 'Miscellaneous Dangerous Goods',
    colorHex: 'FFFFFFFF',
    symbolDescription: 'Black vertical stripes on white, upper half',
    commonUnNumbers: ['3480', '3082', '3077', '1845'],
    description: 'Materials presenting a hazard during transport not covered by the other classes, including lithium batteries and dry ice.',
    handlingNotes: 'A broad catch-all class — check the specific UN number entry rather than assuming low risk from the placard alone.',
  ),
];

/// Finds the placard whose division exactly matches [hazardClass] (e.g. a
/// UN entry's "2.3" or "8"), or null if there's no exact match.
Placard? placardForDivision(String hazardClass) {
  for (final p in kPlacards) {
    if (p.division == hazardClass) return p;
  }
  return null;
}
