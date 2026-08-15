class GlossaryEntry {
  final String term;
  final String definition;

  const GlossaryEntry({required this.term, required this.definition});

  bool matchesQuery(String q) {
    final lower = q.toLowerCase();
    return term.toLowerCase().contains(lower) ||
        definition.toLowerCase().contains(lower);
  }
}

const List<GlossaryEntry> kGlossary = [
  GlossaryEntry(term: 'MSDS', definition: 'Material Safety Data Sheet — the legacy pre-2012 name for what is now called an SDS. Still widely used in speech, especially by older workers.'),
  GlossaryEntry(term: 'SDS', definition: 'Safety Data Sheet — the current standardized 16-section document required under GHS/HazCom 2012, replacing the old MSDS format.'),
  GlossaryEntry(term: 'GHS', definition: 'Globally Harmonized System of Classification and Labelling of Chemicals — the international standard for hazard communication, pictograms, and SDS format.'),
  GlossaryEntry(term: 'HazCom', definition: "OSHA's Hazard Communication Standard (29 CFR 1910.1200) — requires employers to inform workers about chemical hazards via labels and SDSs."),
  GlossaryEntry(term: 'ERG', definition: 'Emergency Response Guidebook — the DOT/PHMSA reference used by first responders to identify a hazmat and find initial isolation and response guidance during the first phase of an incident.'),
  GlossaryEntry(term: 'UN Number', definition: 'A four-digit number assigned by the United Nations to identify a hazardous material or class of materials in transport, always prefixed "UN" (e.g. UN1203).'),
  GlossaryEntry(term: 'NA Number', definition: 'A four-digit number assigned by the U.S. DOT for materials not covered by a UN number, used only for domestic shipments.'),
  GlossaryEntry(term: 'Proper Shipping Name', definition: 'The standardized name for a hazardous material used on shipping papers and placards, taken from the DOT hazardous materials table.'),
  GlossaryEntry(term: 'Hazard Class', definition: 'One of nine broad categories DOT uses to classify dangerous goods by the type of hazard they present, e.g. Class 3 flammable liquid.'),
  GlossaryEntry(term: 'Packing Group', definition: 'A rating (I, II, or III) indicating the degree of danger a hazardous material presents — I is greatest danger, III is least.'),
  GlossaryEntry(term: 'Placard', definition: 'The diamond-shaped sign displayed on a vehicle or bulk container indicating the hazard class of the material being transported.'),
  GlossaryEntry(term: 'Label', definition: "A smaller version of a placard's diamond symbol applied directly to individual packages rather than the transport vehicle."),
  GlossaryEntry(term: 'Pictogram', definition: 'A GHS symbol inside a red diamond border printed on a label or SDS to visually convey a specific hazard, such as flame or skull-and-crossbones.'),
  GlossaryEntry(term: 'Signal Word', definition: 'GHS-required label text — either "Danger" (more severe hazards) or "Warning" (less severe) — indicating relative hazard severity.'),
  GlossaryEntry(term: 'Hazard Statement', definition: 'Standardized GHS phrase describing the nature of a hazard, e.g. "Causes severe skin burns and eye damage."'),
  GlossaryEntry(term: 'Precautionary Statement', definition: 'Standardized GHS phrase describing recommended measures to minimize or prevent adverse effects from a hazard.'),
  GlossaryEntry(term: 'PPE', definition: 'Personal Protective Equipment — gloves, respirators, suits, and other gear used to protect against exposure to a hazardous material.'),
  GlossaryEntry(term: 'SCBA', definition: 'Self-Contained Breathing Apparatus — a portable air supply worn to provide breathable air in atmospheres that are toxic, oxygen-deficient, or otherwise unsafe.'),
  GlossaryEntry(term: 'Isolation Distance', definition: 'The recommended minimum distance to keep unprotected people away from a hazmat incident during the initial response phase, found in the ERG.'),
  GlossaryEntry(term: 'Protective Action Distance', definition: 'The downwind distance within which protective actions (evacuation or shelter-in-place) should be considered for a hazmat release, per ERG guidance.'),
  GlossaryEntry(term: 'Hot Zone', definition: 'The area immediately surrounding a hazmat incident where contamination exists or is likely — entry requires full PPE and decontamination on exit.'),
  GlossaryEntry(term: 'Warm Zone', definition: 'The area between the hot and cold zones used for decontamination and staging of entry teams; reduced but non-zero contamination risk.'),
  GlossaryEntry(term: 'Cold Zone', definition: 'The safe area outside the incident perimeter used for command posts, staging, and uncontaminated personnel and equipment.'),
  GlossaryEntry(term: 'Flash Point', definition: 'The lowest temperature at which a liquid gives off enough vapor to form an ignitable mixture with air near its surface.'),
  GlossaryEntry(term: 'Vapor Density', definition: "A gas or vapor's weight compared to air — values above 1 mean the vapor sinks and pools in low areas; below 1 means it rises."),
  GlossaryEntry(term: 'LEL / UEL', definition: 'Lower and Upper Explosive Limits — the concentration range of a gas or vapor in air within which it can ignite.'),
  GlossaryEntry(term: 'IDLH', definition: 'Immediately Dangerous to Life or Health — an exposure concentration likely to cause death or irreversible harm; requires SCBA or equivalent protection.'),
  GlossaryEntry(term: 'TLV', definition: 'Threshold Limit Value — the ACGIH-recommended exposure level below which most workers can be repeatedly exposed without adverse health effects.'),
  GlossaryEntry(term: 'PEL', definition: 'Permissible Exposure Limit — the legally enforceable OSHA exposure limit for a substance in workplace air.'),
  GlossaryEntry(term: 'Corrosive', definition: 'A substance that causes visible destruction of, or irreversible alterations to, living tissue by chemical action at the site of contact.'),
  GlossaryEntry(term: 'Oxidizer', definition: 'A substance that readily yields oxygen or another oxidizing agent, causing or contributing to the combustion of other materials.'),
  GlossaryEntry(term: 'Pyrophoric', definition: 'A substance that ignites spontaneously in air within five minutes of exposure, without any external ignition source.'),
  GlossaryEntry(term: 'Reactivity', definition: 'A measure of how readily a substance undergoes a chemical reaction, potentially releasing energy, heat, or hazardous byproducts.'),
  GlossaryEntry(term: 'Incompatible Materials', definition: 'Substances that react dangerously if mixed or stored together — a core reason for chemical segregation in storage and transport.'),
  GlossaryEntry(term: 'Fume Hood', definition: 'Ventilated enclosure used in labs to capture and exhaust hazardous vapors, gases, or dust away from the worker.'),
  GlossaryEntry(term: 'Secondary Containment', definition: 'A barrier such as a spill pallet or bermed area designed to hold a leak or spill and prevent it from spreading to the environment.'),
  GlossaryEntry(term: 'DOT', definition: 'U.S. Department of Transportation — the federal agency regulating hazardous materials transport in the United States.'),
  GlossaryEntry(term: 'PHMSA', definition: "Pipeline and Hazardous Materials Safety Administration — the DOT agency that writes and enforces the hazmat transportation regulations and publishes the ERG."),
  GlossaryEntry(term: 'OSHA', definition: 'Occupational Safety and Health Administration — the federal agency regulating workplace safety, including HazCom and PPE requirements.'),
  GlossaryEntry(term: 'EPA', definition: 'Environmental Protection Agency — regulates hazardous waste, environmental release reporting, and spill cleanup requirements.'),
  GlossaryEntry(term: 'CFR', definition: 'Code of Federal Regulations — the codified body of U.S. federal regulations; hazmat transport rules live in 49 CFR.'),
  GlossaryEntry(term: 'RCRA', definition: 'Resource Conservation and Recovery Act — the federal law governing hazardous waste generation, transport, and disposal.'),
  GlossaryEntry(term: 'Shipping Papers', definition: 'The documentation required to accompany a hazmat shipment, listing the proper shipping name, hazard class, UN number, and quantity.'),
  GlossaryEntry(term: 'Emergency Contact Number', definition: 'A 24-hour phone number required on shipping papers (e.g. CHEMTREC) that responders can call for technical guidance on a specific shipment.'),
  GlossaryEntry(term: 'CHEMTREC', definition: 'A 24/7 emergency call center that connects first responders with chemical manufacturers for technical hazmat incident guidance.'),
  GlossaryEntry(term: 'Bulk Packaging', definition: 'A single container with capacity over 119 gallons for liquids or 882 pounds for solids, such as a cargo tank or portable tank.'),
  GlossaryEntry(term: 'Non-Bulk Packaging', definition: 'Smaller individual packages such as drums, boxes, or cylinders below the bulk packaging thresholds.'),
  GlossaryEntry(term: 'Segregation', definition: "DOT/IMDG requirements dictating minimum distances or separation between incompatible hazard classes during transport or storage."),
  GlossaryEntry(term: 'Placarding Threshold', definition: 'The quantity of a hazardous material (often 1,001 lbs aggregate for Table 2 materials) above which a vehicle must display placards.'),
  GlossaryEntry(term: 'N.O.S.', definition: '"Not Otherwise Specified" — used in a proper shipping name when the specific material has no dedicated entry in the hazmat table.'),
  GlossaryEntry(term: 'Decontamination', definition: 'The process of removing or neutralizing hazardous material contamination from people, equipment, or the environment after an exposure.'),
  GlossaryEntry(term: 'Spill Kit', definition: 'A pre-assembled set of absorbents, PPE, and tools kept on hand to respond to a small hazmat spill.'),
  GlossaryEntry(term: 'Thermal Runaway', definition: 'An uncontrolled, self-heating chemical reaction — most commonly discussed today with damaged or overcharged lithium-ion batteries.'),
  GlossaryEntry(term: 'Off-Gassing', definition: 'The release of gas from a material, often the first warning sign of decomposition, overheating, or an unstable reaction.'),
  GlossaryEntry(term: 'Ceiling Limit', definition: 'An exposure limit that must never be exceeded, even briefly, as opposed to a time-weighted average limit.'),
  GlossaryEntry(term: 'Time-Weighted Average (TWA)', definition: 'An exposure limit averaged over a standard 8-hour workday, allowing brief excursions above the limit if the average stays compliant.'),
];
