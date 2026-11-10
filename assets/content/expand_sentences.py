import json

filepath = "/home/rebik/Documents/my_business/English App/assets/content/sentences.json"
with open(filepath, "r", encoding="utf-8") as f:
    sentences = json.load(f)

existing_ids = {s["id"] for s in sentences}
print(f"Current sentences count: {len(sentences)}")

# Add Level 3, 4, 5, 6 sentences to reach 105+
new_sentences = [
    {
        "id": 61,
        "sentence": "The epidemiologist who isolated the viral pathogen received international accolades for her breakthrough research.",
        "level": 3,
        "word_count": 14,
        "subject_span": "0-1",
        "verb_span": "7",
        "chunks_json": ["The epidemiologist", "who isolated the viral pathogen", "received", "international accolades", "for her breakthrough research."],
        "layers_json": [{"type": "relative_clause", "span": "2-6"}],
        "connectors_json": [],
        "simple_meaning": "The scientist who found the virus won global honors.",
        "audio_path": ""
    },
    {
        "id": 62,
        "sentence": "The software engineer who designed the fault-tolerant distributed ledger delivered a keynote presentation in Zurich.",
        "level": 3,
        "word_count": 15,
        "subject_span": "0-2",
        "verb_span": "10",
        "chunks_json": ["The software engineer", "who designed the fault-tolerant distributed ledger", "delivered", "a keynote presentation", "in Zurich."],
        "layers_json": [{"type": "relative_clause", "span": "3-9"}],
        "connectors_json": [],
        "simple_meaning": "The engineer who built the secure database spoke at a conference in Zurich.",
        "audio_path": ""
    },
    {
        "id": 63,
        "sentence": "The diplomat who negotiated the maritime boundary treaty was praised by delegates from both sovereign nations.",
        "level": 3,
        "word_count": 16,
        "subject_span": "0-1",
        "verb_span": "8-9",
        "chunks_json": ["The diplomat", "who negotiated the maritime boundary treaty", "was praised", "by delegates", "from both sovereign nations."],
        "layers_json": [{"type": "relative_clause", "span": "2-7"}],
        "connectors_json": [],
        "simple_meaning": "The diplomat who settled the ocean border agreement earned respect from both countries.",
        "audio_path": ""
    },
    {
        "id": 64,
        "sentence": "The architect who drafted the zero-emission residential complex incorporated passive geothermal cooling into the foundation.",
        "level": 3,
        "word_count": 15,
        "subject_span": "0-1",
        "verb_span": "8",
        "chunks_json": ["The architect", "who drafted the zero-emission residential complex", "incorporated", "passive geothermal cooling", "into the foundation."],
        "layers_json": [{"type": "relative_clause", "span": "2-7"}],
        "connectors_json": [],
        "simple_meaning": "The architect of the green housing project added natural underground cooling.",
        "audio_path": ""
    },
    {
        "id": 65,
        "sentence": "Although supply chain disruptions escalated manufacturing expenses, the executive board refused to compromise component quality.",
        "level": 4,
        "word_count": 15,
        "subject_span": "8-10",
        "verb_span": "11",
        "chunks_json": ["Although supply chain disruptions", "escalated manufacturing expenses,", "the executive board", "refused to compromise", "component quality."],
        "layers_json": [{"type": "concession_clause", "span": "0-5"}],
        "connectors_json": ["Although"],
        "simple_meaning": "Factory costs rose, but the leaders kept using high-grade parts.",
        "audio_path": ""
    },
    {
        "id": 66,
        "sentence": "Because monetary inflation eroded household purchasing power, consumer sentiment fell to unprecedented historical lows.",
        "level": 4,
        "word_count": 14,
        "subject_span": "8-9",
        "verb_span": "10",
        "chunks_json": ["Because monetary inflation", "eroded household purchasing power,", "consumer sentiment", "fell", "to unprecedented historical lows."],
        "layers_json": [{"type": "causal_clause", "span": "0-6"}],
        "connectors_json": ["Because"],
        "simple_meaning": "People had less money to spend, so confidence dropped to record lows.",
        "audio_path": ""
    },
    {
        "id": 67,
        "sentence": "While municipal authorities expanded cycling infrastructure, vehicular emissions continued to rise across outlying suburban corridors.",
        "level": 4,
        "word_count": 15,
        "subject_span": "6-7",
        "verb_span": "8",
        "chunks_json": ["While municipal authorities", "expanded cycling infrastructure,", "vehicular emissions", "continued to rise", "across outlying suburban corridors."],
        "layers_json": [{"type": "contrast_clause", "span": "0-5"}],
        "connectors_json": ["While"],
        "simple_meaning": "Even with more bike paths, car pollution kept growing outside the city.",
        "audio_path": ""
    },
    {
        "id": 68,
        "sentence": "Unless sovereign governments enforce stringent carbon tariffs, global industrial decarbonization targets will remain unobtainable.",
        "level": 4,
        "word_count": 14,
        "subject_span": "6-9",
        "verb_span": "10-11",
        "chunks_json": ["Unless sovereign governments", "enforce stringent carbon tariffs,", "global industrial decarbonization targets", "will remain", "unobtainable."],
        "layers_json": [{"type": "conditional_clause", "span": "0-5"}],
        "connectors_json": ["Unless"],
        "simple_meaning": "Without strict taxes on carbon, the world will fail to meet climate goals.",
        "audio_path": ""
    },
    {
        "id": 69,
        "sentence": "The lead forensic investigator, having scrutinized the corrupted database registers, concluded that the anomaly was deliberate.",
        "level": 5,
        "word_count": 16,
        "subject_span": "0-3",
        "verb_span": "10",
        "chunks_json": ["The lead forensic investigator,", "having scrutinized the corrupted database registers,", "concluded", "that the anomaly was deliberate."],
        "layers_json": [{"type": "participial_clause", "span": "4-9"}, {"type": "content_clause", "span": "11-15"}],
        "connectors_json": ["that"],
        "simple_meaning": "After examining the damaged files, the detective determined the hack was intentional.",
        "audio_path": ""
    },
    {
        "id": 70,
        "sentence": "The medical panel, which convened following unexpected clinical irregularities, recommended immediate suspension of the trial, although corporate stakeholders objected.",
        "level": 5,
        "word_count": 18,
        "subject_span": "0-2",
        "verb_span": "8",
        "chunks_json": ["The medical panel,", "which convened following unexpected clinical irregularities,", "recommended", "immediate suspension of the trial,", "although corporate stakeholders objected."],
        "layers_json": [{"type": "relative_clause", "span": "3-7"}, {"type": "concession_clause", "span": "14-17"}],
        "connectors_json": ["which", "although"],
        "simple_meaning": "The doctors met about strange test results and halted the study despite company pushback.",
        "audio_path": ""
    },
    {
        "id": 71,
        "sentence": "Having concluded three months of ethnographic field observations, the anthropologist published her preliminary monograph, which challenged prevailing colonial historiography.",
        "level": 5,
        "word_count": 18,
        "subject_span": "8-9",
        "verb_span": "10",
        "chunks_json": ["Having concluded three months of ethnographic field observations,", "the anthropologist", "published", "her preliminary monograph,", "which challenged prevailing colonial historiography."],
        "layers_json": [{"type": "participial_clause", "span": "0-7"}, {"type": "relative_clause", "span": "14-17"}],
        "connectors_json": ["which"],
        "simple_meaning": "After months of field study, the scholar released a book questioning old historical theories.",
        "audio_path": ""
    },
    {
        "id": 72,
        "sentence": "Confronted by acute liquidity shortages in secondary debt auctions, central bankers initiated quantitative easing interventions, thereby preventing systemic financial contagion.",
        "level": 5,
        "word_count": 18,
        "subject_span": "9-10",
        "verb_span": "11",
        "chunks_json": ["Confronted by acute liquidity shortages in secondary debt auctions,", "central bankers", "initiated", "quantitative easing interventions,", "thereby preventing systemic financial contagion."],
        "layers_json": [{"type": "participial_clause", "span": "0-8"}, {"type": "result_clause", "span": "15-18"}],
        "connectors_json": ["thereby"],
        "simple_meaning": "Facing a cash crunch in bond markets, central banks injected funds to stop a panic.",
        "audio_path": ""
    },
    {
        "id": 73,
        "sentence": "The proliferation of unverified algorithmic recommendations, which deliberately exploit human cognitive vulnerabilities, exacerbates social polarization to an unprecedented degree.",
        "level": 6,
        "word_count": 18,
        "subject_span": "0-4",
        "verb_span": "12",
        "chunks_json": ["The proliferation of unverified algorithmic recommendations,", "which deliberately exploit human cognitive vulnerabilities,", "exacerbates", "social polarization", "to an unprecedented degree."],
        "layers_json": [{"type": "relative_clause", "span": "5-11"}, {"type": "prepositional_manner", "span": "15-18"}],
        "connectors_json": ["which"],
        "simple_meaning": "Automated feeds that prey on human psychology intensify societal division like never before.",
        "audio_path": ""
    },
    {
        "id": 74,
        "sentence": "Notwithstanding the preliminary efficacy demonstrated in pre-clinical rodent cohorts, regulatory authorities withheld therapeutic certification until long-term human pharmacokinetic trials could verify metabolic safety.",
        "level": 6,
        "word_count": 22,
        "subject_span": "8-9",
        "verb_span": "10",
        "chunks_json": ["Notwithstanding the preliminary efficacy demonstrated in pre-clinical rodent cohorts,", "regulatory authorities", "withheld", "therapeutic certification", "until long-term human pharmacokinetic trials could verify metabolic safety."],
        "layers_json": [{"type": "prepositional_concession", "span": "0-7"}, {"type": "temporal_condition", "span": "13-21"}],
        "connectors_json": ["Notwithstanding", "until"],
        "simple_meaning": "Despite good early tests in mice, regulators delayed approval until human trials proved it safe.",
        "audio_path": ""
    },
    {
        "id": 75,
        "sentence": "In light of widespread macroeconomic volatility precipitated by geopolitical embargoes, sovereign wealth funds reallocated capital reserves from speculative ventures into inflation-hedged commodities.",
        "level": 6,
        "word_count": 21,
        "subject_span": "10-12",
        "verb_span": "13",
        "chunks_json": ["In light of widespread macroeconomic volatility precipitated by geopolitical embargoes,", "sovereign wealth funds", "reallocated", "capital reserves", "from speculative ventures into inflation-hedged commodities."],
        "layers_json": [{"type": "complex_prepositional_cause", "span": "0-9"}, {"type": "prepositional_direction", "span": "16-21"}],
        "connectors_json": ["In light of"],
        "simple_meaning": "Because trade bans caused market swings, state funds moved money into safer physical assets.",
        "audio_path": ""
    },
    {
        "id": 76,
        "sentence": "By delegating administrative documentation to deep-learning models, clinicians can dedicate greater cognitive bandwidth to diagnostic consultations, although empirical evaluations must ensure algorithmic accountability.",
        "level": 6,
        "word_count": 22,
        "subject_span": "7-7",
        "verb_span": "8-9",
        "chunks_json": ["By delegating administrative documentation to deep-learning models,", "clinicians", "can dedicate", "greater cognitive bandwidth", "to diagnostic consultations,", "although empirical evaluations must ensure algorithmic accountability."],
        "layers_json": [{"type": "gerund_means", "span": "0-6"}, {"type": "concession_clause", "span": "15-21"}],
        "connectors_json": ["although"],
        "simple_meaning": "AI clinical notes give doctors more time with patients, but systems must remain strictly audited.",
        "audio_path": ""
    }
]

# Generate more sentences up to ID 108 to comfortably exceed 100 sentences
base_id = 77
sentence_templates = [
    (3, "The historian who uncovered the diplomatic correspondence reinterpreted the origins of the Cold War.", "0-1", "6", ["The historian", "who uncovered the diplomatic correspondence", "reinterpreted", "the origins of the Cold War."], "The scholar who found the old letters viewed the Cold War differently."),
    (3, "The oceanographer who mapped the subduction zone detected anomalous seismic tremors along the fault line.", "0-1", "7", ["The oceanographer", "who mapped the subduction zone", "detected", "anomalous seismic tremors", "along the fault line."], "The scientist who charted the ocean trench found strange earthquake tremors."),
    (3, "The geneticist who synthesized the modified enzyme published her findings in a leading scientific journal.", "0-1", "7", ["The geneticist", "who synthesized the modified enzyme", "published", "her findings", "in a leading scientific journal."], "The scientist who created the artificial enzyme shared her work in a top journal."),
    (3, "The judge who presided over the antitrust trial ordered the monopolistic corporation to divest its assets.", "0-1", "8", ["The judge", "who presided over the antitrust trial", "ordered", "the monopolistic corporation", "to divest its assets."], "The judge in the monopoly case forced the big company to sell parts of its business."),
    (4, "Because renewable energy costs plummeted rapidly, municipal utilities phased out fossil-fueled generators.", "6-7", "8", ["Because renewable energy costs plummeted rapidly,", "municipal utilities", "phased out", "fossil-fueled generators."], "As solar and wind got cheaper, power companies closed old coal and gas plants."),
    (4, "Although the prototype demonstrated superior computational speed, thermal throttling constrained prolonged operation.", "6-7", "8", ["Although the prototype demonstrated superior computational speed,", "thermal throttling", "constrained", "prolonged operation."], "The computer ran fast, but overheating limited how long it could run."),
    (4, "While the executive committee endorsed the restructuring proposal, rank-and-file employees expressed profound skepticism.", "6-7", "8", ["While the executive committee endorsed the restructuring proposal,", "rank-and-file employees", "expressed", "profound skepticism."], "Managers backed the reorganization, but staff strongly doubted its success."),
    (4, "Provided that sovereign lenders restructure existing debt obligations, the developing nation can avert insolvency.", "6-7", "8-9", ["Provided that sovereign lenders restructure existing debt obligations,", "the developing nation", "can avert", "insolvency."], "If foreign banks ease payment terms, the country can avoid going bankrupt."),
    (5, "The committee, which had deliberated the ethical ramifications for weeks, rejected the patent application, though investors appealed.", "0-1", "10", ["The committee,", "which had deliberated the ethical ramifications for weeks,", "rejected", "the patent application,", "though investors appealed."], "After weeks of debate, the panel denied the patent despite appeals from financiers."),
    (5, "Having completed extensive metallurgical stress testing, engineers certified the suspension bridge for commercial freight transit.", "6-6", "7", ["Having completed extensive metallurgical stress testing,", "engineers", "certified", "the suspension bridge", "for commercial freight transit."], "After testing the steel under load, engineers approved the bridge for heavy trucks."),
    (5, "Confronted by persistent algorithmic anomalies during live trading, financial supervisors suspended automated market making protocols.", "7-8", "9", ["Confronted by persistent algorithmic anomalies during live trading,", "financial supervisors", "suspended", "automated market making protocols."], "When trading bots behaved strangely, regulators halted automated order systems."),
    (5, "The archaeological team, having excavated the subterranean kiln, reconstructed ancient ceramic manufacturing methods.", "0-2", "8", ["The archaeological team,", "having excavated the subterranean kiln,", "reconstructed", "ancient ceramic manufacturing methods."], "After digging up the old furnace, archaeologists worked out how ancient pots were made."),
    (6, "In spite of aggressive monetary tightening by western central banks, sovereign inflation metrics remained stubbornly elevated across consumer staples.", "10-12", "13", ["In spite of aggressive monetary tightening by western central banks,", "sovereign inflation metrics", "remained", "stubbornly elevated", "across consumer staples."], "Even with higher interest rates, prices on everyday goods stayed stubbornly high."),
    (6, "By integrating quantum computing architectures with cryptographic hash protocols, cybersecurity specialists seek to neutralize catastrophic decryption attacks.", "8-9", "10", ["By integrating quantum computing architectures with cryptographic hash protocols,", "cybersecurity specialists", "seek to neutralize", "catastrophic decryption attacks."], "By pairing quantum hardware with new security math, experts aim to block future breaches."),
    (6, "Whereas classical economic models presuppose perfectly rational utility maximization, contemporary behavioral psychology demonstrates pervasive heuristic biases.", "7-9", "10", ["Whereas classical economic models presuppose perfectly rational utility maximization,", "contemporary behavioral psychology", "demonstrates", "pervasive heuristic biases."], "Old models assumed people act logically, but modern psychology proves we rely on mental shortcuts."),
    (6, "Inasmuch as rapid planetary warming destabilizes polar jet streams, temperate agricultural regions face increasingly erratic frost patterns.", "8-10", "11", ["Inasmuch as rapid planetary warming destabilizes polar jet streams,", "temperate agricultural regions", "face", "increasingly erratic frost patterns."], "Because climate change shifts wind patterns, farming zones suffer unpredictable freezing weather."),
    (3, "The architect who designed the geothermal heating network won the sustainable building medal.", "0-1", "8", ["The architect", "who designed the geothermal heating network", "won", "the sustainable building medal."], "The architect who created the green heating system won an award."),
    (3, "The historian who uncovered the lost correspondence shed new light on the ceasefire negotiations.", "0-1", "7", ["The historian", "who uncovered the lost correspondence", "shed new light", "on the ceasefire negotiations."], "The historian found old letters that clarified peace talks."),
    (4, "Despite facing insurmountable logistical hurdles during the winter storm, the relief convoy delivered emergency medical supplies to the isolated village.", "10-12", "13", ["Despite facing insurmountable logistical hurdles during the winter storm,", "the relief convoy", "delivered", "emergency medical supplies", "to the isolated village."], "Even though the winter storm caused huge travel problems, the aid trucks brought medicine to the village."),
    (4, "Having thoroughly evaluated all risk assessments presented by the audit committee, the board voted unanimously to halt the acquisition.", "11-12", "13", ["Having thoroughly evaluated all risk assessments presented by the audit committee,", "the board", "voted unanimously", "to halt the acquisition."], "After checking the risk reports, the board agreed to stop the purchase."),
    (4, "Although consumer confidence declined slightly in the third quarter, manufacturing output expanded faster than analysts anticipated.", "8-9", "10", ["Although consumer confidence declined slightly in the third quarter,", "manufacturing output", "expanded faster", "than analysts anticipated."], "Even though shoppers were cautious, factory production grew more than expected."),
    (5, "The hypothesis, which had been vigorously dismissed by orthodoxy for decades, was finally vindicated by empirical measurements from orbital telescopes.", "0-1", "10-11", ["The hypothesis,", "which had been vigorously dismissed by orthodoxy for decades,", "was finally vindicated", "by empirical measurements", "from orbital telescopes."], "The theory that traditional experts rejected for years was proven true by space telescope data."),
    (5, "Beneath the intricate facade of diplomatic pleasantries, profound ideological disagreements threatened to derail the multilateral trade agreement.", "8-9", "10", ["Beneath the intricate facade of diplomatic pleasantries,", "profound ideological disagreements", "threatened", "to derail the multilateral trade agreement."], "Underneath polite diplomatic words, deep ideological arguments almost destroyed the trade deal."),
    (5, "The constitutional court, having deliberated in closed chambers for three consecutive weeks, struck down the surveillance statute as an intolerable infringement upon privacy.", "0-2", "12-13", ["The constitutional court,", "having deliberated in closed chambers for three consecutive weeks,", "struck down", "the surveillance statute", "as an intolerable infringement upon privacy."], "The supreme court reviewed the case for three weeks and canceled the spying law to protect privacy."),
    (5, "Had the central bank not intervened with emergency liquidity auctions, several regional commercial lenders would inevitably have defaulted.", "9-12", "13-15", ["Had the central bank not intervened with emergency liquidity auctions,", "several regional commercial lenders", "would inevitably have defaulted."], "If the central bank had not provided cash, regional banks would have failed."),
    (6, "Notwithstanding the superficial consensus proclaimed in the joint communique, irreconcilable geopolitical rivalries ensure that genuine disarmament remains a remote aspiration.", "7-9", "10", ["Notwithstanding the superficial consensus proclaimed in the joint communique,", "irreconcilable geopolitical rivalries", "ensure", "that genuine disarmament remains a remote aspiration."], "Despite the polite public statement, deep country rivalries mean real disarmament is very unlikely."),
    (6, "To the extent that algorithmic decision-making models internalize historical human biases, automated lending systems will perpetuate systemic socioeconomic inequality.", "8-10", "11", ["To the extent that algorithmic decision-making models internalize historical human biases,", "automated lending systems", "will perpetuate", "systemic socioeconomic inequality."], "If algorithms learn past human biases, automated loan systems will continue unfair financial treatment."),
    (6, "Insofar as quantum computing promises exponential accelerations in cryptographic factorization, existing digital security infrastructures must undergo comprehensive overhaul.", "9-12", "13-14", ["Insofar as quantum computing promises exponential accelerations in cryptographic factorization,", "existing digital security infrastructures", "must undergo", "comprehensive overhaul."], "Because quantum computers will break encryption easily, current computer security must be completely rebuilt."),
    (6, "Lest inadvertent diplomatic blunders precipitate irreversible escalation, both nuclear powers maintain direct, redundant telecommunication hotlines.", "6-8", "9", ["Lest inadvertent diplomatic blunders precipitate irreversible escalation,", "both nuclear powers", "maintain", "direct, redundant telecommunication hotlines."], "To prevent accidental mistakes from starting a war, both nations keep direct phone lines open."),
    (6, "Far from being a mere decorative flourish, the ornate calligraphy throughout the mausoleum embodies sophisticated cosmological treatises.", "9-11", "12", ["Far from being a mere decorative flourish,", "the ornate calligraphy throughout the mausoleum", "embodies", "sophisticated cosmological treatises."], "Rather than just decoration, the writing in the tomb represents deep ideas about the universe."),
    (6, "Were the international community to neglect the plight of displaced climate refugees, subsequent cross-border tensions would inevitably strain global stability.", "10-12", "13-15", ["Were the international community to neglect the plight of displaced climate refugees,", "subsequent cross-border tensions", "would inevitably strain", "global stability."], "If countries ignore climate refugees, border tensions will harm world peace."),
    (6, "Much as the printing press democratized theological scholarship in the Renaissance, open-source artificial intelligence is decentralizing scientific discovery.", "10-13", "14", ["Much as the printing press democratized theological scholarship in the Renaissance,", "open-source artificial intelligence", "is decentralizing", "scientific discovery."], "Just like the printing press spread religious knowledge, open-source AI is spreading scientific tools."),
    (6, "So pervasive has become the reliance on satellite navigation systems that even localized geomagnetic disturbances can disorient entire commercial maritime fleets.", "3-7", "8", ["So pervasive has become the reliance on satellite navigation systems", "that even localized geomagnetic disturbances", "can disorient", "entire commercial maritime fleets."], "Because ships rely so heavily on GPS, solar storms can easily confuse entire shipping fleets.")
]

for idx, (lvl, sent, sub, verb, chunks, meaning) in enumerate(sentence_templates):
    current_id = base_id + idx
    words = sent.split()
    new_sentences.append({
        "id": current_id,
        "sentence": sent,
        "level": lvl,
        "word_count": len(words),
        "subject_span": sub,
        "verb_span": verb,
        "chunks_json": chunks,
        "layers_json": [],
        "connectors_json": [],
        "simple_meaning": meaning,
        "audio_path": ""
    })

for item in new_sentences:
    if item["id"] not in existing_ids:
        sentences.append(item)

with open(filepath, "w", encoding="utf-8") as f:
    json.dump(sentences, f, indent=2, ensure_ascii=False)

print(f"Total sentences now in sentences.json: {len(sentences)}")
