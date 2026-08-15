import 'dart:math';

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
/// category's underlying pool is smaller than that).
List<QuizQuestion> buildQuizSession(QuizCategory category, {int? seed}) {
  final rng = seed == null ? Random() : Random(seed);
  final pool = switch (category) {
    QuizCategory.placards => List<QuizQuestion>.from(kPlacardQuestions),
    QuizCategory.unNumbers => List<QuizQuestion>.from(kUnNumberQuestions),
    QuizCategory.glossary => List<QuizQuestion>.from(kGlossaryQuestions),
    QuizCategory.mixed => List<QuizQuestion>.from(kQuizQuestions),
  };
  pool.shuffle(rng);
  return pool.take(kQuizLength).toList();
}

// Hand-authored question pool for HazMat Pro quiz mode (written by Opus,
// 2026-08-15, from a content brief anchored to this app's own placard/UN
// number/glossary data — see project memory for the review that replaced
// the original auto-generated pool).
//
// Authoring rules applied throughout:
//   * No answer-in-the-prompt giveaways (acronyms are never "defined" back).
//   * Distractors are plausible near-misses drawn from adjacent divisions,
//     classes, or confusable terms — never unrelated hazard types.
//   * Scenario/application framing wherever the content supports it.
//   * Every fact is anchored to the app's own placard / UN / glossary data.
//     No invented numeric detail (isolation distances, thresholds, etc.).

// ---------------------------------------------------------------------------
// PLACARDS (20)
// ---------------------------------------------------------------------------

const List<QuizQuestion> kPlacardQuestions = [
  QuizQuestion(
    prompt:
        'A load of blasting agents is placarded Division 1.5. Compared with Division 1.1, what does that tell a responder?',
    choices: [
      'Neither a mass explosion nor a projection hazard applies to this load.',
      'The explosion consequence is comparable, but initiation is far less likely under normal transport conditions.',
      'Any effects would stay largely confined to the individual package.',
      'The explosion consequence is lower, but the material initiates more readily.',
    ],
    correctIndex: 1,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/1.5.svg',
  ),
  QuizQuestion(
    prompt:
        "A trailer placarded Division 1.2 is involved in a fire. Which tactic follows directly from that division's hazard?",
    choices: [
      'Keep personnel behind cover and avoid approaching from the fragment-throw direction.',
      'Use dry sand or a Class D extinguisher rather than water.',
      'Approach from upwind with SCBA and treat the area as a toxic atmosphere.',
      'Apply a foam blanket to suppress pooling vapor.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/1.2.svg',
  ),
  QuizQuestion(
    prompt:
        'Consumer fireworks and small arms ammunition commonly ship under this placard. What does the division indicate?',
    choices: [
      'The entire load may detonate essentially instantaneously.',
      'Fragments may be projected significant distances.',
      'Effects of an explosion are expected to stay largely confined to the package.',
      'The articles are extremely insensitive, with no mass explosion hazard.',
    ],
    correctIndex: 2,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/1.4.svg',
  ),
  QuizQuestion(
    prompt:
        'Two explosive loads are placarded 1.4 and 1.6. Which statement distinguishes them correctly?',
    choices: [
      'Both indicate a projection hazard and differ only by quantity.',
      '1.6 covers extremely insensitive articles; 1.4 covers a small hazard largely confined to the package.',
      '1.4 is the extremely insensitive division; 1.6 adds a projection hazard.',
      '1.6 carries a mass explosion hazard that 1.4 does not.',
    ],
    correctIndex: 1,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/1.6.svg',
  ),
  QuizQuestion(
    prompt:
        'Display fireworks most often ship under this placard. What hazard combination does it indicate?',
    choices: [
      'A mass explosion hazard affecting the entire load.',
      'A projection hazard with no associated fire hazard.',
      'A fire hazard with either minor blast or minor projection hazard.',
      'No significant blast hazard of any kind.',
    ],
    correctIndex: 2,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/1.3.svg',
  ),
  QuizQuestion(
    prompt:
        'A propane cargo tank is venting. Why does guidance for this class stress eliminating ignition sources well beyond the leak itself?',
    choices: [
      'The gas is toxic at low concentrations, so the isolation area must be large.',
      'The vapors are often heavier than air and can travel to a distant ignition source and flash back.',
      'The material reacts with atmospheric moisture to generate a second flammable gas.',
      'The gas yields oxygen that intensifies any combustion already underway.',
    ],
    correctIndex: 1,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/2.1.svg',
  ),
  QuizQuestion(
    prompt:
        'This placard covers nitrogen, argon, and similar compressed and refrigerated gases. What are its primary risks?',
    choices: [
      'Asphyxiation in confined spaces, and extreme cold from cryogenic liquids.',
      'Flash fire from vapors pooling at ground level.',
      'Toxicity severe enough to require SCBA and full area isolation.',
      'Violent reaction with water producing a flammable gas.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/2.2.svg',
  ),
  QuizQuestion(
    prompt:
        'A cargo tank of refrigerated liquid oxygen carries the non-flammable gas placard. Why is a nearby fire still a serious problem?',
    choices: [
      'Oxygen becomes flammable below its critical temperature.',
      'The placard also covers flammable gases above a threshold quantity.',
      'Cryogenic oxygen releases hydrogen as it warms.',
      'Oxygen does not burn itself but vigorously supports the combustion of other materials.',
    ],
    correctIndex: 3,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/2.2.svg',
  ),
  QuizQuestion(
    prompt:
        'A rail tank car placarded with this class is leaking beside a highway. What does the class itself dictate about approach?',
    choices: [
      'Approach from downwind so vapors move away from the entry team.',
      'Full isolation of the area, with approach only under SCBA by trained personnel.',
      'Water spray from a distance to knock down the release before any entry.',
      'Structural firefighting gear is adequate for a brief reconnaissance entry.',
    ],
    correctIndex: 1,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/2.3.svg',
  ),
  QuizQuestion(
    prompt: 'What defines the materials covered by this placard?',
    choices: [
      'Liquids with a flash point at or below 60°C (140°F).',
      'Liquids that ignite spontaneously on contact with air.',
      'Solids that may ignite through friction.',
      'Liquids that release a flammable gas on contact with water.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/3.svg',
  ),
  QuizQuestion(
    prompt:
        'Gasoline from an overturned tanker has run into a roadside drainage ditch. Which property of this class drives the immediate concern?',
    choices: [
      'The liquid reacts exothermically with standing water.',
      'Contact with organic material can trigger violent decomposition.',
      'Vapors are typically heavier than air and pool in low areas.',
      'The material sublimates directly into an asphyxiating gas.',
    ],
    correctIndex: 2,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/3.svg',
  ),
  QuizQuestion(
    prompt:
        'Beyond ready combustibility, what additional control do some materials under this placard require?',
    choices: [
      'Temperature control, because certain self-reactive substances are included.',
      'Inert gas blanketing to exclude oxygen from the container.',
      'Immersion in oil to prevent any contact with air.',
      'Continuous radiation monitoring of the package surface.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/4.1.svg',
  ),
  QuizQuestion(
    prompt:
        'This placard differs from the Division 4.1 placard in one key respect. What is it?',
    choices: [
      'The material can ignite on exposure to air with no external ignition source.',
      'The material ignites only through friction or sparks.',
      'The material must contact water before it becomes hazardous.',
      'The material yields oxygen that accelerates nearby fires.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/4.2.svg',
  ),
  QuizQuestion(
    prompt:
        'A truck carrying sodium metal under this placard has a cargo fire. What extinguishing approach does the class require?',
    choices: [
      'Water fog applied from the maximum practical distance.',
      'A foam blanket to suppress vapor production.',
      'Carbon dioxide flooding of the enclosed cargo space.',
      'Dry sand, dry chemical, or a Class D extinguisher — never water.',
    ],
    correctIndex: 3,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/4.3.svg',
  ),
  QuizQuestion(
    prompt:
        'Why does handling guidance for this class stress keeping the material away from fuels and organic material?',
    choices: [
      'Contamination can cause violent decomposition or explosion.',
      'The material absorbs hydrocarbons and turns corrosive.',
      'Organic material catalyzes the release of a toxic gas.',
      'The mixture becomes water-reactive.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/5.1.svg',
  ),
  QuizQuestion(
    prompt:
        'Many materials under this placard require refrigeration in transport. What drives that requirement?',
    choices: [
      'They sublimate at ambient temperature and over-pressurize the container.',
      'They are thermally unstable and can undergo exothermic self-accelerating decomposition.',
      'They separate into incompatible phases when warm.',
      'They lose oxygen content and destabilize when cold.',
    ],
    correctIndex: 1,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/5.2.svg',
  ),
  QuizQuestion(
    prompt: 'What distinguishes this placard from the Division 6.1 placard?',
    choices: [
      'It signals a higher concentration of the same toxic substances.',
      'It applies to solids, while 6.1 applies to liquids.',
      'It signals material containing pathogens, rather than chemical toxicity.',
      'It covers toxicity by ingestion only, while 6.1 covers inhalation.',
    ],
    correctIndex: 2,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/6.2.svg',
  ),
  QuizQuestion(
    prompt:
        'A package under this placard has been damaged in a collision. Which set of controls forms the core of responder protection?',
    choices: [
      'Ventilation, absorption, and neutralization.',
      'Isolation, decontamination, and foam application.',
      'Cooling, venting, and pressure relief.',
      'Time, distance, and shielding.',
    ],
    correctIndex: 3,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/7.svg',
  ),
  QuizQuestion(
    prompt:
        "A drum under this placard has splashed a worker's forearm. What does the handling guidance direct?",
    choices: [
      'Flush with copious water and seek medical attention immediately.',
      'Neutralize the residue with a weak base before flushing.',
      'Cover the area and keep it away from water entirely.',
      'Apply a dry absorbent and monitor for delayed symptoms.',
    ],
    correctIndex: 0,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/8.svg',
  ),
  QuizQuestion(
    prompt:
        'A trailer displays the Class 9 placard. Why is that placard a poor basis for estimating risk on its own?',
    choices: [
      'Class 9 is applied only when the shipper is unsure of the correct class.',
      'Class 9 placards are optional and applied inconsistently.',
      'Class 9 always indicates an environmental rather than an acute hazard.',
      'Class 9 is a catch-all, so the specific UN number has to be checked.',
    ],
    correctIndex: 3,
    category: QuizCategory.placards,
    placardAsset: 'assets/placards/9.svg',
  ),
];

// ---------------------------------------------------------------------------
// UN NUMBERS (24)
// ---------------------------------------------------------------------------

const List<QuizQuestion> kUnNumberQuestions = [
  QuizQuestion(
    prompt:
        'Shipping papers list UN1203 on one tanker and UN1202 on another. Which difference is reflected in their packing groups?',
    choices: [
      'UN1202 is PG II while UN1203 is PG III.',
      "UN1203 is PG II and UN1202 is PG III, reflecting gasoline's greater volatility.",
      'Both are PG II; only their ERG guides differ.',
      'UN1202 falls under Class 9 rather than Class 3.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Ethanol (UN1170) and gasoline (UN1203) are both Class 3, Packing Group II. What differs in the ERG guidance?',
    choices: [
      'Ethanol points to Guide 127; gasoline points to Guide 128.',
      'Both point to Guide 128.',
      'Ethanol points to Guide 131.',
      'Ethanol has no assigned guide because it is also shipped as a beverage product.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Methanol (UN1230) shares Class 3 and Packing Group II with gasoline but carries a different ERG guide. What accounts for that?',
    choices: [
      'It reacts with water to release a flammable gas.',
      'It is a strong oxidizer as well as a flammable liquid.',
      'It is toxic by ingestion and inhalation in addition to being flammable.',
      'It is corrosive to skin on brief contact.',
    ],
    correctIndex: 2,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'A tanker of UN1114 has ruptured. Beyond flammability, what makes any exposure especially serious?',
    choices: [
      'It is a known carcinogen.',
      'It reacts violently with water.',
      'It is an oxidizer that intensifies nearby fire.',
      'It is corrosive to skin and eyes on contact.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Shipping papers list UN1993, "Flammable liquid, n.o.s." How should a responder use that entry?',
    choices: [
      'Treat it as gasoline, the most common Class 3 material.',
      'Treat it as a generic entry and read the papers for the actual substance.',
      'Assume Packing Group I until proven otherwise.',
      'Assume no ERG guide applies to generic entries.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Propane (UN1978), LPG (UN1075), and butane (UN1011) share which ERG guide number?',
    choices: ['116', '121', '128', '115'],
    correctIndex: 3,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Acetylene ships as UN1001, "Acetylene, dissolved," and carries Guide 116 rather than the 115 used by other flammable gases. What does "dissolved" reflect?',
    choices: [
      'It is unstable under pressure without an acetone stabilizer.',
      'It is shipped as a liquid rather than a compressed gas.',
      'It is diluted below its lower explosive limit for transport.',
      'It is dissolved in water to reduce its flammability.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1049, compressed hydrogen, presents a hazard that makes a fire hard to size up visually. What is it?',
    choices: [
      'It produces almost no radiant heat.',
      'It burns nearly invisibly in daylight.',
      'It is heavier than air and burns below sight line.',
      'It sublimates before it ignites.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Compressed oxygen ships as UN1072 in Class 2.2, not Class 2.1. Why?',
    choices: [
      'Its flammable range is too narrow to qualify.',
      'It is flammable only in its refrigerated form.',
      'It does not burn itself, though it vigorously supports the combustion of other materials.',
      'Class 2.1 is reserved for hydrocarbon gases.',
    ],
    correctIndex: 2,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1073 is refrigerated liquid oxygen. What hazard does the refrigerated form add over UN1072?',
    choices: [
      'Severe frostbite on contact.',
      'Toxicity by inhalation.',
      'Water reactivity.',
      'Flammability of the liquid itself.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Nitrogen (UN1066), helium (UN1046), and argon (UN1006) are all Class 2.2 with no packing group assigned. What hazard do they share?',
    choices: [
      'Corrosive action on respiratory tissue.',
      'Support of combustion in the surrounding area.',
      'Toxicity requiring SCBA at any detectable concentration.',
      'Asphyxiation in confined or enclosed spaces.',
    ],
    correctIndex: 3,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Carbon dioxide (UN1013) has been released inside a warehouse. Where should monitoring be concentrated?',
    choices: [
      'Low and confined spaces, because it is heavier than air.',
      'At ceiling level, because it is lighter than air.',
      'Nowhere in particular — it disperses evenly through the space.',
      'Along cold surfaces, where it condenses back to a liquid.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'Chlorine (UN1017) and anhydrous ammonia (UN1005) are both Class 2.3. What does that assignment require of responders?',
    choices: [
      'Foam application to suppress the vapor cloud.',
      'Full isolation of the area and SCBA for any approach.',
      'Dry chemical agents only.',
      'Standard structural firefighting gear.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1830 sulfuric acid carries a specific dilution warning. What is it?',
    choices: [
      'It must never contact water in any quantity.',
      'It neutralizes on contact with water and becomes inert.',
      'It reacts violently with water — always add acid to water, never the reverse.',
      'It must be diluted before it can legally be transported.',
    ],
    correctIndex: 2,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1823 (solid) and UN1824 (solution) are both sodium hydroxide, Class 8, PG II, Guide 154. What additional behavior does the solid form show?',
    choices: [
      'It reacts exothermically with water.',
      'It is flammable as an airborne dust.',
      'It is toxic by inhalation only in solid form.',
      'It carries a more severe packing group.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN2014 covers hydrogen peroxide solution at 20–60% under Guide 140. What changes above 60% concentration?',
    choices: [
      'It stays UN2014 but moves to Packing Group I.',
      'It becomes UN2015, with Guide 143.',
      'It is reclassified as Class 8 only.',
      'It becomes non-regulated for transport.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1942, ammonium nitrate fertilizer grade, is Class 5.1, Packing Group III. Under what conditions does its explosive risk rise sharply?',
    choices: [
      'When exposed to water.',
      'When cooled below freezing.',
      'When contaminated, or heavily confined under fire.',
      'When separated from its original packaging.',
    ],
    correctIndex: 2,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN3480 (lithium ion) and UN3090 (lithium metal) are both Class 9, Packing Group II, but their ERG guides differ. Which pairing is correct?',
    choices: [
      'Lithium ion → Guide 138; lithium metal → Guide 147.',
      'Both → Guide 147.',
      'Both → Guide 138.',
      'Lithium ion → Guide 147; lithium metal → Guide 138.',
    ],
    correctIndex: 3,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1845, solid carbon dioxide, has been shipped in a closed trailer. What is the primary hazard when the doors are opened?',
    choices: [
      'Asphyxiation, as the material sublimates into carbon dioxide gas.',
      'Frostbite only — the gas itself is inert and harmless.',
      'Flammable vapor accumulated at floor level.',
      'Corrosive condensate pooled on the trailer floor.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1402 calcium carbide is Class 4.3 with Guide 138. Which gas does contact with moisture release?',
    choices: [
      'Hydrogen sulfide.',
      'Acetylene.',
      'Chlorine.',
      'Carbon monoxide.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN1428 sodium metal is assigned Packing Group I. What does that tell you relative to a PG II or PG III material?',
    choices: [
      'It presents the greatest degree of danger of the three ratings.',
      'It presents the least degree of danger of the three ratings.',
      'Packing group refers to container size, not degree of danger.',
      'PG I means no packing group requirement applies.',
    ],
    correctIndex: 0,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN2794, batteries wet filled with acid, is Class 8 rather than Class 9 like lithium batteries. Why?',
    choices: [
      'Lead-acid batteries carry a thermal runaway risk that lithium cells do not.',
      'Class 9 applies only to rechargeable cells.',
      'The hazard is the corrosive electrolyte if the case is breached.',
      'They exceed the weight threshold that Class 9 allows.',
    ],
    correctIndex: 2,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN2814 and UN2900 both cover infectious substances under Guide 158. What separates them?',
    choices: [
      'UN2814 affects animals only; UN2900 affects humans.',
      'UN2900 affects animals only; UN2814 affects humans.',
      'UN2900 covers regulated medical waste.',
      'They differ by packaging type, not by what they affect.',
    ],
    correctIndex: 1,
    category: QuizCategory.unNumbers,
  ),
  QuizQuestion(
    prompt:
        'UN2908 is listed as an excepted package, empty packaging, Class 7, Guide 161. What does that indicate?',
    choices: [
      'A Type A package that was damaged in transit.',
      'Packaging awaiting a radiological survey before reuse.',
      'The lowest radioactive shipping category, with minimal residual activity.',
      'A package whose contents could not be determined.',
    ],
    correctIndex: 2,
    category: QuizCategory.unNumbers,
  ),
];

// ---------------------------------------------------------------------------
// GLOSSARY (30)
// ---------------------------------------------------------------------------

const List<QuizQuestion> kGlossaryQuestions = [
  QuizQuestion(
    prompt:
        'A veteran driver asks for "the MSDS" on a drum in his trailer. What should you hand him?',
    choices: [
      'The shipping papers, which superseded the MSDS.',
      'The safety data sheet — the current 16-section format that replaced the MSDS.',
      'The ERG guide page for the material.',
      'The GHS label, which replaced the document entirely.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'How many sections does the standardized safety data sheet format contain?',
    choices: ['9', '12', '16', '20'],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A GHS label carries the signal word "Warning" rather than "Danger." What does that indicate?',
    choices: [
      'A less severe hazard category.',
      'The hazard is unconfirmed pending further testing.',
      'PPE is required but no safety data sheet is.',
      'The label applies to transport only, not workplace use.',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A label reads "Causes severe skin burns and eye damage." Which GHS label element is that?',
    choices: [
      'A precautionary statement.',
      'A signal word.',
      'A hazard statement.',
      'A hazard class designation.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A label reads "Wear protective gloves and eye protection." Which GHS label element is that?',
    choices: [
      'A precautionary statement.',
      'A hazard statement.',
      'A signal word.',
      'A pictogram caption.',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'What distinguishes a label from a placard?',
    choices: [
      'A label is required only on international shipments.',
      'A label goes on individual packages; a placard goes on the vehicle or bulk container.',
      'A placard goes on packages; a label goes on the vehicle.',
      'A label carries the UN number; a placard never does.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'Shipping papers show a four-digit identifier prefixed "NA" instead of "UN." What does that tell you?',
    choices: [
      'It is a North American entry harmonized across the U.S., Canada, and Mexico.',
      'It indicates the material is not otherwise specified.',
      'It was assigned by U.S. DOT for a material with no UN number, and is valid for domestic shipments only.',
      'It indicates a non-regulated material below reporting thresholds.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'A material is assigned Packing Group III. What does that indicate?',
    choices: [
      'The greatest degree of danger of the three ratings.',
      'The least degree of danger of the three ratings.',
      'The third-largest permissible container size.',
      'That three separate hazard classes apply to the material.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'A proper shipping name ends in "n.o.s." What does that tell a responder?',
    choices: [
      'The material has no dedicated entry in the hazmat table, so the specific substance must come from the papers.',
      'The shipment is in error and the papers must be reissued.',
      'No packing group has been assigned to the material.',
      'The quantity falls below the placarding threshold.',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'Which of these describes what a flash point measures?',
    choices: [
      'The temperature at which a liquid ignites with no ignition source present.',
      'The temperature at which a liquid boils and vents its container.',
      'The lowest temperature at which a liquid gives off enough vapor to form an ignitable mixture with air.',
      'The temperature at which vapor concentration passes the upper explosive limit.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        "A material's vapor density is listed as 2.5. What should a responder expect?",
    choices: [
      'Vapor that sinks and pools in low areas.',
      'Vapor that rises and disperses upward.',
      'Toxicity roughly 2.5 times that of air.',
      'An isolation distance 2.5 times the standard.',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A meter reads a vapor concentration above the upper explosive limit. What does that mean?',
    choices: [
      'The mixture is at its most easily ignited concentration.',
      'The mixture is too lean to ignite.',
      'The material has exceeded its permissible exposure limit but is not flammable.',
      'The mixture is too rich to ignite now, though dilution can bring it back into the flammable range.',
    ],
    correctIndex: 3,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'Which exposure limit is legally enforceable in a U.S. workplace?',
    choices: [
      'The threshold limit value.',
      'The permissible exposure limit.',
      'The IDLH concentration.',
      'The lower explosive limit.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A safety officer cites a threshold limit value for a solvent. Whose recommendation is that?',
    choices: ['OSHA', 'EPA', 'ACGIH', 'PHMSA'],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'An atmosphere is reported at an IDLH concentration. What does that require?',
    choices: [
      'An air-purifying respirator is sufficient for entry.',
      'SCBA or equivalent — the concentration is likely to cause death or irreversible harm.',
      'Public evacuation, with no change to responder protection.',
      'Continuous monitoring, with entry permitted for up to eight hours.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A substance carries both a time-weighted average and a ceiling limit. What does the ceiling limit add?',
    choices: [
      'An average that may be exceeded so long as the eight-hour mean stays compliant.',
      'The height at which vapor accumulates inside a structure.',
      'A concentration that must never be exceeded, even briefly.',
      'The concentration above which the material becomes flammable.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'Decontamination of an entry team takes place in which zone?',
    choices: [
      'The hot zone.',
      'The warm zone.',
      'The cold zone.',
      'Outside the established perimeter entirely.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'Where is the incident command post established at a hazmat scene?',
    choices: [
      'The cold zone.',
      'The warm zone, for direct access to entry teams.',
      'The hot zone perimeter, for line of sight.',
      'Immediately downwind of the decontamination corridor.',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'An ERG entry lists both an initial isolation distance and a protective action distance. What does the protective action distance describe?',
    choices: [
      'The radius in all directions from which unprotected people must be kept.',
      'The distance responders must keep while wearing full PPE.',
      'The downwind distance within which evacuation or shelter-in-place should be considered.',
      'The distance at which the material can no longer be detected.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'A material is described as pyrophoric. What does that mean in practice?',
    choices: [
      'It ignites on contact with water.',
      'It ignites spontaneously in air within five minutes, with no ignition source.',
      'It ignites only under friction or impact.',
      'It supports combustion but does not burn itself.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A single container holds 200 gallons of a liquid hazardous material. Does that meet the bulk packaging threshold?',
    choices: [
      'No — bulk begins at 500 gallons for liquids.',
      'Only if the aggregate load also exceeds 1,001 pounds.',
      'Yes — it exceeds the 119-gallon liquid threshold.',
      'Only if it is a cargo tank rather than a portable tank.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'What quantity generally triggers placarding for Table 2 materials?',
    choices: [
      '119 gallons in a single container.',
      '882 pounds of solids.',
      'Any quantity, regardless of weight.',
      '1,001 pounds aggregate on the vehicle.',
    ],
    correctIndex: 3,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'Shipping papers must carry a 24-hour emergency contact number. What is it there for?',
    choices: [
      'Reporting the incident to PHMSA within 24 hours.',
      'Reaching technical guidance on the specific shipment, such as through CHEMTREC.',
      "Contacting the carrier's dispatcher.",
      'Requesting a replacement set of shipping papers.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'Which body of federal law governs hazardous waste generation, transport, and disposal?',
    choices: [
      'RCRA',
      'HazCom',
      'GHS',
      '49 CFR alone',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'Which standard requires employers to inform workers about chemical hazards through labels and safety data sheets?',
    choices: [
      '49 CFR §172.101.',
      'The Emergency Response Guidebook.',
      "OSHA's Hazard Communication Standard, 29 CFR 1910.1200.",
      'The Resource Conservation and Recovery Act.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'Which agency writes the hazmat transportation regulations and publishes the Emergency Response Guidebook?',
    choices: ['OSHA', 'EPA', 'PHMSA, within DOT', 'ACGIH'],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A damaged lithium-ion pack begins heating rapidly and keeps heating with no external heat source. What is that called?',
    choices: [
      'Off-gassing.',
      'Pyrophoric ignition.',
      'Thermal runaway.',
      'Sublimation.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'A sealed drum starts releasing gas around the bung. What does that most likely signal?',
    choices: [
      'Normal pressure equalization requiring no action.',
      'Decomposition, overheating, or an unstable reaction inside.',
      'That the material has reached its flash point.',
      'Failure of the secondary containment.',
    ],
    correctIndex: 1,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt:
        'Why do transport rules specify minimum separation between certain hazard classes on the same load?',
    choices: [
      'Because incompatible materials can react dangerously if they mix.',
      'Because placards for different classes must not be adjacent.',
      'Because packing groups cannot be mixed on one vehicle.',
      'Because it reduces the total number of placards required.',
    ],
    correctIndex: 0,
    category: QuizCategory.glossary,
  ),
  QuizQuestion(
    prompt: 'What is a spill pallet or bermed area intended to do?',
    choices: [
      'Neutralize the chemical on contact.',
      'Ventilate off-gassing containers.',
      'Hold a leak and keep it from spreading to the environment.',
      'Satisfy the bulk packaging capacity threshold.',
    ],
    correctIndex: 2,
    category: QuizCategory.glossary,
  ),
];

// ---------------------------------------------------------------------------
// MIXED (8) — cross-category scenarios. These are the questions that test
// whether a candidate can actually chain placard → UN number → response.
// ---------------------------------------------------------------------------

const List<QuizQuestion> kMixedQuestions = [
  QuizQuestion(
    prompt:
        'A tanker is on its side. Papers list UN1203, Class 3, PG II, Guide 128. Nothing is burning yet. Which fact most directly shapes the initial perimeter?',
    choices: [
      'Flammable liquid with vapors heavier than air, pooling in low ground downgrade of the wreck.',
      'Toxic gas requiring full isolation and SCBA before any approach.',
      'Water-reactive solid requiring dry agents only.',
      'Oxidizer that will intensify any combustion nearby.',
    ],
    correctIndex: 0,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'Papers list UN1428, Class 4.3, PG I. An engine company is stretching a water line. What should the incident commander do?',
    choices: [
      'Approve it — water is the standard agent for Class 4 fires.',
      'Stop it — the material reacts with water, and dry agents or a Class D extinguisher are required.',
      'Approve it, but only as a fog pattern.',
      'Approve it once foam concentrate is added to the line.',
    ],
    correctIndex: 1,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'A trailer carries 900 pounds of a Table 2 Class 3 material and no other hazmat. Are placards generally required?',
    choices: [
      'Yes — any quantity of a Class 3 material requires placards.',
      'No — Table 2 materials generally require placards above 1,001 pounds aggregate.',
      'Yes — the 119-gallon bulk threshold has been exceeded.',
      'No — Class 3 materials are exempt from placarding requirements.',
    ],
    correctIndex: 1,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'A load is placarded Division 2.3 and the papers list UN1017, Guide 124. Which zone arrangement follows?',
    choices: [
      'Command post inside the warm zone for direct line of sight.',
      'Entry with structural gear once the leak rate slows.',
      'Hot zone isolation with SCBA for entry, decon in the warm zone, command in the cold zone.',
      'No zoning required until a release is visually confirmed.',
    ],
    correctIndex: 2,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'Papers show UN3480, Class 9, PG II, Guide 147, and the pallet begins smoking after a forklift strike. What is the most likely mechanism?',
    choices: [
      'Thermal runaway in damaged lithium-ion cells.',
      'Sublimation of dry ice packed with the shipment.',
      'A water-reactive metal releasing flammable gas.',
      'Exothermic decomposition of an organic peroxide.',
    ],
    correctIndex: 0,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'A responder has Guide 128 from the shipping papers but cannot identify the specific material. What does the guide number itself provide?',
    choices: [
      'The exact chemical composition of the material.',
      'Initial isolation and response guidance for materials sharing similar hazards.',
      'The legally required placard for the vehicle.',
      'The packing group and container specification.',
    ],
    correctIndex: 1,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'A drum is placarded Class 8 and papers list UN1830, Guide 137. A crew proposes flushing the spill area with a fire line. What is the concern?',
    choices: [
      'Water will neutralize the acid too quickly and generate a toxic gas.',
      'The material reacts violently with water, so uncontrolled flushing can make things worse.',
      'Class 8 materials must never contact water in any form.',
      'Runoff would reclassify the spill as a Class 9 material.',
    ],
    correctIndex: 1,
    category: QuizCategory.mixed,
  ),
  QuizQuestion(
    prompt:
        'Papers list UN1993, Class 3, PG II, Guide 128, with no further detail on the substance. What is the correct next step?',
    choices: [
      'Treat it as gasoline and set distances accordingly.',
      'Read the shipping papers for the actual substance and call the 24-hour emergency contact.',
      'Treat it as non-regulated until the substance is confirmed.',
      'Switch to Guide 127, which covers generic entries.',
    ],
    correctIndex: 1,
    category: QuizCategory.mixed,
  ),
];

// ---------------------------------------------------------------------------
// Combined pool
// ---------------------------------------------------------------------------

const List<QuizQuestion> kQuizQuestions = [
  ...kPlacardQuestions,
  ...kUnNumberQuestions,
  ...kGlossaryQuestions,
  ...kMixedQuestions,
];
