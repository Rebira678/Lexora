import json

reference_hunter_data = [
    {
        "id": 1,
        "sentence": "The central bank unexpectedly raised benchmark interest rates by fifty basis points yesterday; this triggered an immediate sell-off across sovereign bond markets.",
        "level": 4,
        "pronoun": "this",
        "pronoun_index": 12,
        "antecedent": "raising benchmark interest rates by fifty basis points",
        "antecedent_span": "4-10",
        "options": [
            "raising benchmark interest rates by fifty basis points",
            "The central bank",
            "sovereign bond markets",
            "yesterday's financial report"
        ],
        "correct_option_index": 0,
        "explanation": "'this' acts as a demonstrative pro-form referring to the entire preceding proposition (the central bank raising rates), not the entity of the central bank itself."
    },
    {
        "id": 2,
        "sentence": "The research team developed an enzyme capable of depolymerizing plastic bottles within six hours, which could revolutionize municipal recycling pipelines.",
        "level": 4,
        "pronoun": "which",
        "pronoun_index": 14,
        "antecedent": "developing an enzyme capable of depolymerizing plastic",
        "antecedent_span": "3-10",
        "options": [
            "developing an enzyme capable of depolymerizing plastic",
            "plastic bottles",
            "municipal recycling pipelines",
            "six hours"
        ],
        "correct_option_index": 0,
        "explanation": "The non-restrictive relative pronoun 'which' refers to the preceding breakthrough discovery/enzyme development as an overarching phenomenon."
    },
    {
        "id": 3,
        "sentence": "Although pharmaceutical conglomerates invested billions into targeted gene therapy trials, they yielded few commercially viable treatments during the initial decade.",
        "level": 4,
        "pronoun": "they",
        "pronoun_index": 10,
        "antecedent": "targeted gene therapy trials",
        "antecedent_span": "6-9",
        "options": [
            "targeted gene therapy trials",
            "pharmaceutical conglomerates",
            "billions",
            "commercially viable treatments"
        ],
        "correct_option_index": 0,
        "explanation": "'they' functions as the grammatical subject of the main clause. Grammatically and semantically, it is the trials that 'yielded' few treatments, not the companies themselves."
    },
    {
        "id": 4,
        "sentence": "The municipal authority constructed elevated flood barriers along the riverbank, but such measures will prove insufficient if sea levels rise further.",
        "level": 4,
        "pronoun": "such measures",
        "pronoun_index": 9,
        "antecedent": "constructing elevated flood barriers along the riverbank",
        "antecedent_span": "3-8",
        "options": [
            "constructing elevated flood barriers along the riverbank",
            "The municipal authority",
            "sea levels",
            "the riverbank"
        ],
        "correct_option_index": 0,
        "explanation": "'Such measures' is an anaphoric noun phrase summarizing the specific civil defense intervention: building elevated flood barriers."
    },
    {
        "id": 5,
        "sentence": "While classical economists prized monetary stability and neo-Keynesians advocated fiscal stimulus, the latter argued that state intervention was essential during severe recessions.",
        "level": 5,
        "pronoun": "the latter",
        "pronoun_index": 10,
        "antecedent": "neo-Keynesians",
        "antecedent_span": "6-6",
        "options": [
            "neo-Keynesians",
            "classical economists",
            "severe recessions",
            "monetary stability"
        ],
        "correct_option_index": 0,
        "explanation": "'The latter' refers to the second of two previously mentioned parties or concepts; here, the neo-Keynesians who advocate fiscal stimulus."
    },
    {
        "id": 6,
        "sentence": "The urban planning commission scrutinized both high-density subway expansion and highway widening; the former was deemed far more ecologically sustainable.",
        "level": 5,
        "pronoun": "the former",
        "pronoun_index": 11,
        "antecedent": "high-density subway expansion",
        "antecedent_span": "5-7",
        "options": [
            "high-density subway expansion",
            "highway widening",
            "The urban planning commission",
            "ecological sustainability"
        ],
        "correct_option_index": 0,
        "explanation": "'The former' designates the first of two listed items, which in this sentence is high-density subway expansion."
    },
    {
        "id": 7,
        "sentence": "Neuroscientists discovered that sleep deprivation impairs hippocampal neurogenesis, and it subsequently compromises long-term spatial memory consolidation.",
        "level": 5,
        "pronoun": "it",
        "pronoun_index": 8,
        "antecedent": "sleep deprivation",
        "antecedent_span": "3-4",
        "options": [
            "sleep deprivation",
            "hippocampal neurogenesis",
            "spatial memory consolidation",
            "Neuroscientists"
        ],
        "correct_option_index": 0,
        "explanation": "'It' is the agent causing the secondary impairment; sleep deprivation is the underlying chronic factor driving memory decay."
    },
    {
        "id": 8,
        "sentence": "The legislature enacted strict privacy regulations regarding autonomous drones because these had sparked vehement protests among civil liberties advocates.",
        "level": 5,
        "pronoun": "these",
        "pronoun_index": 8,
        "antecedent": "autonomous drones",
        "antecedent_span": "5-6",
        "options": [
            "autonomous drones",
            "strict privacy regulations",
            "civil liberties advocates",
            "The legislature"
        ],
        "correct_option_index": 0,
        "explanation": "'These' is a proximal demonstrative pronoun picking up the plural inanimate entity immediately causing controversy: the autonomous drones."
    },
    {
        "id": 9,
        "sentence": "The museum acquired hundreds of rare Renaissance manuscripts, many of which had suffered severe water damage during previous centuries of neglect.",
        "level": 5,
        "pronoun": "which",
        "pronoun_index": 9,
        "antecedent": "rare Renaissance manuscripts",
        "antecedent_span": "5-7",
        "options": [
            "rare Renaissance manuscripts",
            "The museum",
            "hundreds",
            "previous centuries of neglect"
        ],
        "correct_option_index": 0,
        "explanation": "In the quantifier construction 'many of which', 'which' refers directly to the rare Renaissance manuscripts."
    },
    {
        "id": 10,
        "sentence": "Satellite observations revealed an unprecedented fracture across the Larsen Ice Shelf; its rapid propagation alarmed glaciologists worldwide.",
        "level": 5,
        "pronoun": "its",
        "pronoun_index": 10,
        "antecedent": "an unprecedented fracture",
        "antecedent_span": "4-6",
        "options": [
            "an unprecedented fracture",
            "the Larsen Ice Shelf",
            "Satellite observations",
            "glaciologists"
        ],
        "correct_option_index": 0,
        "explanation": "The possessive pronoun 'its' qualifies 'rapid propagation'. It is the fracture that propagates across the shelf."
    },
    {
        "id": 11,
        "sentence": "The regulatory agency warned against algorithmic price-gouging during natural disasters, noting that this undermines public faith in market mechanisms.",
        "level": 6,
        "pronoun": "this",
        "pronoun_index": 11,
        "antecedent": "algorithmic price-gouging during natural disasters",
        "antecedent_span": "3-7",
        "options": [
            "algorithmic price-gouging during natural disasters",
            "The regulatory agency",
            "public faith",
            "market mechanisms"
        ],
        "correct_option_index": 0,
        "explanation": "'This' summarizes the exploitative behavior (algorithmic price-gouging) that erodes collective trust."
    },
    {
        "id": 12,
        "sentence": "Insofar as multinational corporations exploit overseas tax havens, sovereign governments lose essential revenue; this necessitates domestic budgetary austerity.",
        "level": 6,
        "pronoun": "this",
        "pronoun_index": 12,
        "antecedent": "losing essential tax revenue to overseas havens",
        "antecedent_span": "9-11",
        "options": [
            "losing essential tax revenue to overseas havens",
            "multinational corporations",
            "domestic budgetary austerity",
            "sovereign governments"
        ],
        "correct_option_index": 0,
        "explanation": "'This' links back to the fiscal loss suffered by sovereign governments, which in turn forces them to enact domestic austerity."
    },
    {
        "id": 13,
        "sentence": "The archival discovery included treaties between Ottoman sultans and Venetian doges, all of whom recognized the commercial imperative of open maritime lanes.",
        "level": 6,
        "pronoun": "whom",
        "pronoun_index": 11,
        "antecedent": "Ottoman sultans and Venetian doges",
        "antecedent_span": "5-9",
        "options": [
            "Ottoman sultans and Venetian doges",
            "The archival discovery",
            "treaties",
            "open maritime lanes"
        ],
        "correct_option_index": 0,
        "explanation": "'Whom' is the objective relative pronoun referencing the human historical rulers (the sultans and doges)."
    },
    {
        "id": 14,
        "sentence": "The supreme court invalidated the executive decree on emergency detention powers, holding that it exceeded statutory constitutional boundaries.",
        "level": 6,
        "pronoun": "it",
        "pronoun_index": 12,
        "antecedent": "the executive decree on emergency detention powers",
        "antecedent_span": "3-9",
        "options": [
            "the executive decree on emergency detention powers",
            "The supreme court",
            "statutory constitutional boundaries",
            "emergency detention"
        ],
        "correct_option_index": 0,
        "explanation": "'It' is the subject of 'exceeded statutory boundaries', referring to the executive decree."
    },
    {
        "id": 15,
        "sentence": "Although critics accused the modern novelist of excessive cynicism and gratuitous despair, she maintained that these accurately reflected post-war disillusionment.",
        "level": 6,
        "pronoun": "these",
        "pronoun_index": 12,
        "antecedent": "excessive cynicism and gratuitous despair",
        "antecedent_span": "6-10",
        "options": [
            "excessive cynicism and gratuitous despair",
            "post-war disillusionment",
            "critics",
            "the modern novelist"
        ],
        "correct_option_index": 0,
        "explanation": "'These' stands in for the two thematic attributes cited by the critics: cynicism and despair."
    }
]

sentence_race_data = [
    {
        "id": 1,
        "sentence": "Despite encountering severe atmospheric turbulence over the mountain ridge, the seasoned pilot landed the cargo aircraft safely on the unpaved emergency runway.",
        "level": 4,
        "word_count": 22,
        "question": "Where did the seasoned pilot ultimately land the aircraft?",
        "options": [
            "On an unpaved emergency runway",
            "In an ocean harbor",
            "At a commercial international airport",
            "On top of the mountain ridge"
        ],
        "correct_index": 0,
        "explanation": "The sentence clearly states the pilot landed the cargo plane 'on the unpaved emergency runway' after navigating the turbulence."
    },
    {
        "id": 2,
        "sentence": "Because municipal inspectors detected elevated lead levels in the primary aqueduct, city officials immediately distributed bottled water to every elementary school.",
        "level": 4,
        "word_count": 21,
        "question": "What prompted the city officials to distribute bottled water?",
        "options": [
            "Elevated lead levels detected in the main aqueduct",
            "A burst pipe in the school basement",
            "A scheduled drought preparation drill",
            "Protests by local parent associations"
        ],
        "correct_index": 0,
        "explanation": "The causal clause beginning with 'Because' pinpoints elevated lead levels in the primary aqueduct as the direct trigger."
    },
    {
        "id": 3,
        "sentence": "The archaeological excavation unearthed a gilded ceremonial sceptre that confirmed historians' theories regarding third-century dynastic rituals.",
        "level": 4,
        "word_count": 16,
        "question": "What key artifact was unearthed during the excavation?",
        "options": [
            "A gilded ceremonial sceptre",
            "A stone sarcophagus",
            "A bronze warfare shield",
            "Ancient coins with royal portraits"
        ],
        "correct_index": 0,
        "explanation": "The grammatical direct object of 'unearthed' is 'a gilded ceremonial sceptre'."
    },
    {
        "id": 4,
        "sentence": "Although the fintech startup secured substantial venture capital, its inability to lower customer acquisition costs precipitated a severe liquidity crisis.",
        "level": 5,
        "word_count": 21,
        "question": "What precipitated the startup's liquidity crisis?",
        "options": [
            "Inability to lower customer acquisition costs",
            "A sudden collapse in venture capital funding",
            "Loss of its founding executive team",
            "Regulatory fines from government authorities"
        ],
        "correct_index": 0,
        "explanation": "The subject of the main clause 'its inability to lower customer acquisition costs' precipitated the crisis."
    },
    {
        "id": 5,
        "sentence": "The climatologist warned that melting permafrost releases trapped methane gas, which accelerates global warming at a rate far exceeding earlier computational forecasts.",
        "level": 5,
        "word_count": 22,
        "question": "Why is the melting of permafrost especially dangerous?",
        "options": [
            "It releases trapped methane that accelerates warming beyond forecasts",
            "It leads directly to immediate freezing temperatures",
            "It destroys underground fiber optic telecommunications",
            "It reduces the salinity of the deep Atlantic ocean"
        ],
        "correct_index": 0,
        "explanation": "The relative clause 'which accelerates global warming...' explains that releasing trapped methane compounds temperature rise beyond earlier predictions."
    },
    {
        "id": 6,
        "sentence": "Having audited hundreds of corporate balance sheets across the eurozone, the regulatory commission concluded that hidden derivative liabilities posed systemic hazards.",
        "level": 5,
        "word_count": 22,
        "question": "What did the regulatory commission identify as a systemic hazard?",
        "options": [
            "Hidden derivative liabilities",
            "Fluctuating international exchange rates",
            "Excessive employee severance packages",
            "Delayed quarterly revenue disclosures"
        ],
        "correct_index": 0,
        "explanation": "The that-clause object of 'concluded' establishes that 'hidden derivative liabilities' posed the systemic hazards."
    },
    {
        "id": 7,
        "sentence": "Inasmuch as autonomous driving algorithms rely on stochastic neural networks, edge-case sensory ambiguities continue to pose formidable ethical and engineering dilemmas.",
        "level": 6,
        "word_count": 21,
        "question": "What remains a formidable dilemma for autonomous vehicles according to the author?",
        "options": [
            "Edge-case sensory ambiguities",
            "High manufacturing costs of lithium batteries",
            "Insufficient cellular bandwidth on highways",
            "Driver resistance to computerized steering"
        ],
        "correct_index": 0,
        "explanation": "The sentence identifies 'edge-case sensory ambiguities' as the core ongoing dilemma resulting from reliance on neural networks."
    },
    {
        "id": 8,
        "sentence": "Notwithstanding the superficial truce signed in Geneva, deep-seated ethnic grievances and unresolved territorial disputes ensure that hostilities could reignite at any provocation.",
        "level": 6,
        "word_count": 23,
        "question": "What makes the Geneva truce fragile?",
        "options": [
            "Deep-seated ethnic grievances and unresolved territorial disputes",
            "Economic sanctions imposed by neighboring superpowers",
            "A lack of international peacekeeping observers",
            "The refusal of humanitarian aid shipments"
        ],
        "correct_index": 0,
        "explanation": "The phrase 'deep-seated ethnic grievances and unresolved territorial disputes' represents the underlying cause that could cause hostilities to reignite."
    },
    {
        "id": 9,
        "sentence": "Were sovereign central banks to unilaterally phase out physical banknotes in favor of central bank digital currencies, privacy advocates would mount unprecedented legal challenges.",
        "level": 6,
        "word_count": 24,
        "question": "What hypothetical event would trigger unprecedented legal challenges?",
        "options": [
            "Phasing out physical cash in favor of digital currencies",
            "Hiking interest rates to combat rampant inflation",
            "Nationalizing commercial investment banks",
            "Sharing citizen transaction data with foreign allies"
        ],
        "correct_index": 0,
        "explanation": "The conditional inverted clause 'Were sovereign central banks to unilaterally phase out physical banknotes...' sets the condition."
    },
    {
        "id": 10,
        "sentence": "So pervasive has become the reliance on semiconductor microchips that even localized factory shutdowns in East Asia trigger global automotive production standstills.",
        "level": 6,
        "word_count": 22,
        "question": "What is the global consequence of localized semiconductor factory shutdowns?",
        "options": [
            "Automotive production halts worldwide",
            "Immediate inflation of raw agricultural goods",
            "Submarine communications cables failure",
            "Total collapse of national electricity grids"
        ],
        "correct_index": 0,
        "explanation": "The result clause 'that even localized factory shutdowns... trigger global automotive production standstills' gives the consequence."
    }
]

output = {
    "reference_hunter": reference_hunter_data,
    "sentence_race": sentence_race_data
}

with open("assets/content/section20_content.json", "w", encoding="utf-8") as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print(f"Generated {len(reference_hunter_data)} reference hunter items and {len(sentence_race_data)} sentence race items.")
