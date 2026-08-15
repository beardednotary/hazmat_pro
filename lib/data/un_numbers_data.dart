// Cross-checked 2026-08-14 against ERG2024 (yellow ID index) and 49 CFR
// §172.101 (Hazardous Materials Table) for guide numbers and packing
// groups: gasoline, diesel/gas oil, ethanol, methanol, acetone, toluene,
// benzene, ammonia, chlorine, sulfuric/hydrochloric acid, sodium hydroxide,
// sodium metal, potassium permanganate, calcium carbide, ammonium nitrate,
// carbon dioxide/dry ice, formaldehyde, paint, kerosene, jet fuel, matches,
// lithium battery guide numbers, infectious substances, radioactive Type A,
// environmentally hazardous substances. A handful of entries (xylene PG,
// hydrogen peroxide split at UN2014/2015, a few battery/exotic entries)
// were corrected from the official tables during this pass but not every
// remaining field was independently re-verified — re-check before shipping
// if adding new entries or if this data is later edited by hand.

class UnEntry {
  final String unNumber; // "1203" (no "UN" prefix, always stored as digits)
  final String properShippingName;
  final String hazardClass; // "3", "8", "2.1" ...
  final String? packingGroup; // "I", "II", "III", or null if not applicable
  final String ergGuideNumber; // "128"
  final String notes;

  const UnEntry({
    required this.unNumber,
    required this.properShippingName,
    required this.hazardClass,
    this.packingGroup,
    required this.ergGuideNumber,
    required this.notes,
  });

  String get displayNumber => 'UN$unNumber';

  bool matchesQuery(String q) {
    final lower = q.toLowerCase();
    return unNumber.contains(lower) ||
        properShippingName.toLowerCase().contains(lower) ||
        ergGuideNumber.contains(lower);
  }
}

const List<UnEntry> kUnNumbers = [
  UnEntry(unNumber: '1203', properShippingName: 'Gasoline', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '128', notes: 'Common motor fuel. Vapors heavier than air, pool in low areas.'),
  UnEntry(unNumber: '1202', properShippingName: 'Diesel fuel / Fuel oil', hazardClass: '3', packingGroup: 'III', ergGuideNumber: '128', notes: 'Combustible liquid, lower volatility than gasoline.'),
  UnEntry(unNumber: '1223', properShippingName: 'Kerosene', hazardClass: '3', packingGroup: 'III', ergGuideNumber: '128', notes: 'Used as jet fuel base and heating fuel.'),
  UnEntry(unNumber: '1863', properShippingName: 'Fuel, aviation, turbine engine (Jet A / JP-8)', hazardClass: '3', packingGroup: 'III', ergGuideNumber: '128', notes: 'Common at airports and military fuel points.'),
  UnEntry(unNumber: '1170', properShippingName: 'Ethanol / Ethyl alcohol', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '127', notes: 'Also seen in beverage-grade tanker transport.'),
  UnEntry(unNumber: '1230', properShippingName: 'Methanol', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '131', notes: 'Toxic by ingestion/inhalation in addition to flammability.'),
  UnEntry(unNumber: '1090', properShippingName: 'Acetone', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '127', notes: 'Common industrial solvent.'),
  UnEntry(unNumber: '1294', properShippingName: 'Toluene', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '130', notes: 'Aromatic solvent, narcotic effects at high concentration.'),
  UnEntry(unNumber: '1307', properShippingName: 'Xylenes', hazardClass: '3', packingGroup: 'III', ergGuideNumber: '130', notes: 'Common paint and coatings solvent.'),
  UnEntry(unNumber: '1114', properShippingName: 'Benzene', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '130', notes: 'Known carcinogen — treat any exposure seriously.'),
  UnEntry(unNumber: '1993', properShippingName: 'Flammable liquid, n.o.s.', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '128', notes: 'Generic entry — check shipping papers for the actual substance.'),
  UnEntry(unNumber: '1263', properShippingName: 'Paint / Paint related material', hazardClass: '3', packingGroup: 'II', ergGuideNumber: '128', notes: 'Includes thinners, reducers, and related coatings.'),
  UnEntry(unNumber: '1198', properShippingName: 'Formaldehyde solution, flammable', hazardClass: '3', packingGroup: 'III', ergGuideNumber: '132', notes: 'Also toxic and a respiratory irritant.'),
  UnEntry(unNumber: '1978', properShippingName: 'Propane', hazardClass: '2.1', ergGuideNumber: '115', notes: 'Liquefied gas, heavier than air when released.'),
  UnEntry(unNumber: '1075', properShippingName: 'Liquefied petroleum gas (LPG)', hazardClass: '2.1', ergGuideNumber: '115', notes: 'Mixture of propane/butane, common home and grill fuel.'),
  UnEntry(unNumber: '1011', properShippingName: 'Butane', hazardClass: '2.1', ergGuideNumber: '115', notes: 'Used in lighters, camp stoves, aerosol propellant.'),
  UnEntry(unNumber: '1971', properShippingName: 'Natural gas, compressed (methane)', hazardClass: '2.1', ergGuideNumber: '115', notes: 'CNG vehicle fuel — high-pressure cylinders.'),
  UnEntry(unNumber: '1001', properShippingName: 'Acetylene, dissolved', hazardClass: '2.1', ergGuideNumber: '116', notes: 'Unstable under pressure without acetone stabilizer — welding gas.'),
  UnEntry(unNumber: '1049', properShippingName: 'Hydrogen, compressed', hazardClass: '2.1', ergGuideNumber: '115', notes: 'Wide flammability range, burns nearly invisibly in daylight.'),
  UnEntry(unNumber: '1072', properShippingName: 'Oxygen, compressed', hazardClass: '2.2', ergGuideNumber: '122', notes: 'Not flammable itself but vigorously supports combustion.'),
  UnEntry(unNumber: '1073', properShippingName: 'Oxygen, refrigerated liquid', hazardClass: '2.2', ergGuideNumber: '122', notes: 'Cryogenic — risk of severe frostbite on contact.'),
  UnEntry(unNumber: '1066', properShippingName: 'Nitrogen, compressed', hazardClass: '2.2', ergGuideNumber: '121', notes: 'Asphyxiation hazard in confined/enclosed spaces.'),
  UnEntry(unNumber: '1977', properShippingName: 'Nitrogen, refrigerated liquid', hazardClass: '2.2', ergGuideNumber: '120', notes: 'Cryogenic liquid, rapid expansion ratio on release.'),
  UnEntry(unNumber: '1013', properShippingName: 'Carbon dioxide', hazardClass: '2.2', ergGuideNumber: '120', notes: 'Asphyxiant, heavier than air — collects in low/confined spaces.'),
  UnEntry(unNumber: '1046', properShippingName: 'Helium, compressed', hazardClass: '2.2', ergGuideNumber: '120', notes: 'Simple asphyxiant, otherwise low hazard.'),
  UnEntry(unNumber: '1006', properShippingName: 'Argon, compressed', hazardClass: '2.2', ergGuideNumber: '120', notes: 'Simple asphyxiant, common welding shield gas.'),
  UnEntry(unNumber: '1017', properShippingName: 'Chlorine', hazardClass: '2.3', ergGuideNumber: '124', notes: 'Toxic and corrosive gas — full isolation and SCBA required.'),
  UnEntry(unNumber: '1005', properShippingName: 'Ammonia, anhydrous', hazardClass: '2.3', ergGuideNumber: '125', notes: 'Toxic gas, common in refrigeration and agriculture.'),
  UnEntry(unNumber: '1079', properShippingName: 'Sulfur dioxide', hazardClass: '2.3', ergGuideNumber: '125', notes: 'Toxic, corrosive to respiratory tract.'),
  UnEntry(unNumber: '1830', properShippingName: 'Sulfuric acid', hazardClass: '8', packingGroup: 'II', ergGuideNumber: '137', notes: 'Strong acid, reacts violently with water — add acid to water, never reverse.'),
  UnEntry(unNumber: '1789', properShippingName: 'Hydrochloric acid', hazardClass: '8', packingGroup: 'II', ergGuideNumber: '157', notes: 'Corrosive, emits irritating fumes.'),
  UnEntry(unNumber: '1824', properShippingName: 'Sodium hydroxide solution', hazardClass: '8', packingGroup: 'II', ergGuideNumber: '154', notes: 'Strong caustic base — severe chemical burns on contact.'),
  UnEntry(unNumber: '1823', properShippingName: 'Sodium hydroxide, solid', hazardClass: '8', packingGroup: 'II', ergGuideNumber: '154', notes: 'Same hazard as solution form; reacts exothermically with water.'),
  UnEntry(unNumber: '1760', properShippingName: 'Corrosive liquid, n.o.s.', hazardClass: '8', packingGroup: 'II', ergGuideNumber: '154', notes: 'Generic entry — check shipping papers for the actual substance.'),
  UnEntry(unNumber: '1759', properShippingName: 'Corrosive solid, n.o.s.', hazardClass: '8', packingGroup: 'II', ergGuideNumber: '154', notes: 'Generic entry — check shipping papers for the actual substance.'),
  UnEntry(unNumber: '2014', properShippingName: 'Hydrogen peroxide, aqueous solution (20–60%)', hazardClass: '5.1', packingGroup: 'II', ergGuideNumber: '140', notes: 'Oxidizer and corrosive. Above 60% concentration this becomes UN2015, Guide 143 instead.'),
  UnEntry(unNumber: '1490', properShippingName: 'Potassium permanganate', hazardClass: '5.1', packingGroup: 'II', ergGuideNumber: '140', notes: 'Strong oxidizer, contact with organics can ignite.'),
  UnEntry(unNumber: '2067', properShippingName: 'Ammonium nitrate based fertilizer', hazardClass: '5.1', packingGroup: 'III', ergGuideNumber: '140', notes: 'Bulk agricultural shipments — decomposition risk under heat/contamination.'),
  UnEntry(unNumber: '1942', properShippingName: 'Ammonium nitrate, fertilizer grade', hazardClass: '5.1', packingGroup: 'III', ergGuideNumber: '140', notes: 'Explosive risk increases when contaminated or heavily confined under fire.'),
  UnEntry(unNumber: '1402', properShippingName: 'Calcium carbide', hazardClass: '4.3', packingGroup: 'II', ergGuideNumber: '138', notes: 'Reacts with water/moisture to release flammable acetylene gas.'),
  UnEntry(unNumber: '1428', properShippingName: 'Sodium (metal)', hazardClass: '4.3', packingGroup: 'I', ergGuideNumber: '138', notes: 'Reacts violently with water — never use water-based extinguishing agents.'),
  UnEntry(unNumber: '1331', properShippingName: 'Matches, strike anywhere', hazardClass: '4.1', ergGuideNumber: '133', notes: 'Consumer/industrial bulk shipment — friction-sensitive.'),
  UnEntry(unNumber: '1944', properShippingName: 'Matches, safety', hazardClass: '4.1', ergGuideNumber: '133', notes: 'Lower sensitivity than strike-anywhere matches.'),
  UnEntry(unNumber: '3480', properShippingName: 'Lithium ion batteries', hazardClass: '9', packingGroup: 'II', ergGuideNumber: '147', notes: 'Thermal runaway/fire risk from damage, short circuit, or overcharge.'),
  UnEntry(unNumber: '3481', properShippingName: 'Lithium ion batteries packed with/in equipment', hazardClass: '9', packingGroup: 'II', ergGuideNumber: '147', notes: 'Same underlying hazard as UN3480, packaged with the device.'),
  UnEntry(unNumber: '3090', properShippingName: 'Lithium metal batteries', hazardClass: '9', packingGroup: 'II', ergGuideNumber: '138', notes: 'Non-rechargeable lithium cells — different reactivity profile than Li-ion.'),
  UnEntry(unNumber: '3091', properShippingName: 'Lithium metal batteries packed with/in equipment', hazardClass: '9', packingGroup: 'II', ergGuideNumber: '138', notes: 'Same underlying hazard as UN3090, packaged with the device.'),
  UnEntry(unNumber: '1845', properShippingName: 'Carbon dioxide, solid (dry ice)', hazardClass: '9', ergGuideNumber: '120', notes: 'Sublimates to CO2 gas — asphyxiation risk in enclosed spaces.'),
  UnEntry(unNumber: '3082', properShippingName: 'Environmentally hazardous substance, liquid, n.o.s.', hazardClass: '9', packingGroup: 'III', ergGuideNumber: '171', notes: 'Generic environmental-hazard entry — check shipping papers.'),
  UnEntry(unNumber: '3077', properShippingName: 'Environmentally hazardous substance, solid, n.o.s.', hazardClass: '9', packingGroup: 'III', ergGuideNumber: '171', notes: 'Generic environmental-hazard entry — check shipping papers.'),
  UnEntry(unNumber: '2794', properShippingName: 'Batteries, wet, filled with acid', hazardClass: '8', ergGuideNumber: '154', notes: 'Standard lead-acid batteries — corrosive electrolyte risk if breached.'),
  UnEntry(unNumber: '2800', properShippingName: 'Batteries, wet, non-spillable', hazardClass: '8', ergGuideNumber: '154', notes: 'Sealed lead-acid — lower spill risk than flooded wet batteries.'),
  UnEntry(unNumber: '2814', properShippingName: 'Infectious substance, affecting humans', hazardClass: '6.2', ergGuideNumber: '158', notes: 'Treat breached packaging as an active biohazard exposure.'),
  UnEntry(unNumber: '2900', properShippingName: 'Infectious substance, affecting animals only', hazardClass: '6.2', ergGuideNumber: '158', notes: 'Veterinary/agricultural pathogen shipments.'),
  UnEntry(unNumber: '3291', properShippingName: 'Regulated medical waste, n.o.s.', hazardClass: '6.2', ergGuideNumber: '158', notes: 'Common on medical waste transport and disposal routes.'),
  UnEntry(unNumber: '2915', properShippingName: 'Radioactive material, Type A package', hazardClass: '7', ergGuideNumber: '163', notes: 'Time, distance, and shielding are the core exposure controls.'),
  UnEntry(unNumber: '2908', properShippingName: 'Radioactive material, excepted package — empty packaging', hazardClass: '7', ergGuideNumber: '161', notes: 'Lowest radioactive shipping category, minimal residual activity.'),
];
