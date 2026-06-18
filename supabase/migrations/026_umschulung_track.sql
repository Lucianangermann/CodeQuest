-- Migration 026: Umschulung Fachinformatiker Anwendungsentwicklung track

-- Schema changes
ALTER TABLE public.topics ADD COLUMN IF NOT EXISTS track TEXT NOT NULL DEFAULT 'junior_dev'
  CHECK (track IN ('junior_dev', 'umschulung'));
ALTER TABLE public.topics ADD COLUMN IF NOT EXISTS lernfeld_number INTEGER;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS active_tracks TEXT[] NOT NULL DEFAULT ARRAY['junior_dev'];

-- Insert umschulung topics
INSERT INTO public.topics (title, description, order_index, icon, track, lernfeld_number) VALUES
('LF 1 — Der Betrieb und sein Umfeld', 'Geschäftsprozesse, Unternehmensformen und betriebliche Organisation', 1, '🏢', 'umschulung', 1),
('LF 2 — Arbeitsplätze nach Kundenwunsch ausstatten', 'Hardware-Komponenten, Kalkulation und Angebotserstellung', 2, '🖥️', 'umschulung', 2),
('LF 3 — Clients in Netzwerke einbinden', 'IP-Adressen, Subnetting und das OSI-Modell', 3, '🌐', 'umschulung', 3),
('LF 4 — Schutzbedarfsanalyse', 'IT-Sicherheit, CIA-Triad, DSGVO und Datenschutz', 4, '🔒', 'umschulung', 4),
('LF 5 — Software zur Verwaltung von Daten anpassen', 'Relationale Datenbanken, SQL und Normalisierung', 5, '🗄️', 'umschulung', 5),
('LF 6 — Serviceanfragen bearbeiten', 'ITSM, Ticketsysteme und professionelle Kundenkommunikation', 6, '🎫', 'umschulung', 6),
('LF 7 — Cyber-physische Systeme', 'IoT-Grundlagen, Sensorik, Aktoren und Datenverarbeitung', 7, '🤖', 'umschulung', 7),
('LF 8 — Daten systemübergreifend bereitstellen', 'REST-APIs, HTTP-Methoden und Datenformate', 8, '🔌', 'umschulung', 8),
('LF 9 — Netzwerke und Dienste bereitstellen', 'DNS, DHCP, Servergrundlagen und Virtualisierung', 9, '📡', 'umschulung', 9),
('LF 10a — Benutzerschnittstellen gestalten', 'UI/UX-Grundlagen, Usability, Wireframes und Prototyping', 10, '🎨', 'umschulung', 10),
('LF 11a — Funktionalität in Anwendungen realisieren', 'Objektorientierte Programmierung vertieft und Design Patterns', 11, '⚙️', 'umschulung', 11),
('LF 12a — Kundenspezifische Anwendungsentwicklung', 'Lastenheft, Pflichtenheft, Scrum und Kanban', 12, '📋', 'umschulung', 12),
('WiSo — Wirtschafts- und Sozialkunde', 'Arbeitsrecht, Berufsausbildung und Sozialversicherungssystem', 13, '📚', 'umschulung', NULL)
;

-- ============================================================
-- LF 1 — Der Betrieb und sein Umfeld
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 1 — Der Betrieb und sein Umfeld' AND track = 'umschulung'),
  'Unternehmensformen und Stakeholder',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Unternehmensformen im Überblick",
        "content": "**Einzelunternehmen**: Eine Person gründet und führt das Unternehmen allein. Unbeschränkte persönliche Haftung mit Privatvermögen. Einfache Gründung, keine Mindestkapital-Anforderung.\n\n**GbR (Gesellschaft bürgerlichen Rechts)**: Mindestens 2 Personen schließen sich zusammen. Alle Gesellschafter haften gesamtschuldnerisch und unbeschränkt mit Privatvermögen. Kein Mindestkapital.\n\n**GmbH (Gesellschaft mit beschränkter Haftung)**: Kapitalgesellschaft mit Mindestkapital von 25.000 €. Haftung ist auf das Gesellschaftsvermögen beschränkt. Gesellschafter haften grundsätzlich nicht mit Privatvermögen. Pflicht zur Eintragung ins Handelsregister.\n\n**AG (Aktiengesellschaft)**: Kapitalgesellschaft mit Mindestgrundkapital von 50.000 €. Aktionäre haften nur mit ihrer Einlage. Kapital ist in Aktien aufgeteilt. Komplexe Organisationsstruktur (Vorstand, Aufsichtsrat, Hauptversammlung)."
      },
      {
        "heading": "Stakeholder: Interne und externe Anspruchsgruppen",
        "content": "**Interne Stakeholder** (innerhalb des Unternehmens):\n- **Eigenkapitalgeber / Gesellschafter**: Stellen das Kapital bereit, tragen das unternehmerische Risiko, erwarten Gewinnausschüttung (Dividende)\n- **Mitarbeiter / Arbeitnehmer**: Erbringen Arbeitsleistung, erwarten Lohn/Gehalt, sichere Arbeitsbedingungen und Weiterbildung\n- **Management / Geschäftsführung**: Leitet das Unternehmen, verfolgt strategische Ziele\n\n**Externe Stakeholder** (außerhalb des Unternehmens):\n- **Fremdkapitalgeber (Banken)**: Stellen Kredite bereit, erwarten pünktliche Rückzahlung mit Zinsen\n- **Kunden**: Kaufen Produkte/Dienstleistungen, erwarten Qualität und guten Service\n- **Lieferanten**: Liefern Waren/Materialien, erwarten pünktliche Zahlung und langfristige Geschäftsbeziehungen\n- **Staat / Behörden**: Erhebt Steuern und Abgaben, kontrolliert die Einhaltung von Gesetzen\n- **Gesellschaft / Öffentlichkeit**: Erwartet umweltbewusstes und sozial verantwortliches Handeln"
      }
    ],
    "summary": "Unternehmensformen unterscheiden sich vor allem in Haftung und Mindestkapital; Stakeholder sind alle Gruppen, die Interessen am Unternehmen haben."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 1 — Der Betrieb und sein Umfeld' AND track = 'umschulung'),
  'Geschäftsprozesse und betriebliche Organisation',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Aufbauorganisation",
        "content": "Die **Aufbauorganisation** beschreibt die statische Struktur eines Unternehmens: Wer ist wem unterstellt? Welche Abteilungen gibt es?\n\n**Kernbegriffe:**\n- **Stelle**: Die kleinste organisatorische Einheit. Eine Stelle beschreibt Aufgaben, Kompetenzen und Verantwortung einer Position (z.B. Sachbearbeiter Buchhaltung).\n- **Abteilung**: Zusammenfassung mehrerer Stellen unter einer Leitung (z.B. Abteilung IT).\n- **Hierarchieebenen**: Unternehmensleitung → Bereichsleitung → Abteilungsleitung → Sachbearbeitung\n- **Organigramm**: Grafische Darstellung der Aufbauorganisation. Zeigt Stellen, Abteilungen und Weisungsbeziehungen.\n\n**Organisationsformen:**\n- **Linienorganisation**: Klare Hierarchie, jede Stelle hat genau einen Vorgesetzten. Einfach, aber langsam.\n- **Stablinienorganisation**: Wie Linie, aber mit beratenden Stabsstellen (z.B. Rechtsabteilung, Controlling).\n- **Matrixorganisation**: Mitarbeiter haben zwei Vorgesetzte (Fachabteilung + Projektleitung). Flexibel, aber konfliktanfällig."
      },
      {
        "heading": "Ablauforganisation und Geschäftsprozesse",
        "content": "Die **Ablauforganisation** beschreibt die dynamischen Abläufe im Unternehmen: Wie werden Aufgaben erledigt? In welcher Reihenfolge?\n\n**Geschäftsprozess**: Eine Folge von Aktivitäten, die aus einem definierten Input einen definierten Output erzeugt und dabei Wert schöpft.\n\n**Prozessarten:**\n- **Kernprozesse**: Direkt wertschöpfend (z.B. Produktion, Vertrieb, Kundenservice)\n- **Unterstützungsprozesse**: Ermöglichen Kernprozesse (z.B. IT, Personalwesen, Buchhaltung)\n- **Managementprozesse**: Steuern und kontrollieren (z.B. Strategie, Qualitätsmanagement)\n\n**Unterschied Aufbau- vs. Ablauforganisation:**\n| Merkmal | Aufbauorganisation | Ablauforganisation |\n|---|---|---|\n| Fragestellung | Wer macht was? | Wie wird es gemacht? |\n| Darstellung | Organigramm | Flussdiagramm / Prozessmodell |\n| Charakter | Statisch | Dynamisch |\n| Fokus | Stellen und Hierarchien | Abläufe und Prozesse |"
      }
    ],
    "summary": "Aufbauorganisation = statische Struktur (Organigramm, Hierarchien); Ablauforganisation = dynamische Prozesse (Workflows, Abläufe)."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 1 — Der Betrieb und sein Umfeld' AND track = 'umschulung'),
  'Quiz: Unternehmensformen und Organisation',
  'quiz',
  $json${
    "question": "Ein Unternehmen wird von zwei Personen gegründet, die beide mit ihrem gesamten Privatvermögen haften. Es wurde kein Mindestkapital eingezahlt. Um welche Unternehmensform handelt es sich?",
    "options": [
      "GbR (Gesellschaft bürgerlichen Rechts)",
      "GmbH (Gesellschaft mit beschränkter Haftung)",
      "AG (Aktiengesellschaft)",
      "Einzelunternehmen"
    ],
    "correct_index": 0,
    "explanation": "Die GbR wird von mindestens 2 Personen gegründet, erfordert kein Mindestkapital und alle Gesellschafter haften unbeschränkt und gesamtschuldnerisch mit ihrem Privatvermögen. Die GmbH würde eine Haftungsbeschränkung bieten und 25.000 € Mindestkapital erfordern."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 2 — Arbeitsplätze nach Kundenwunsch ausstatten
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 2 — Arbeitsplätze nach Kundenwunsch ausstatten' AND track = 'umschulung'),
  'Hardware-Komponenten und ihre Funktion',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Prozessor (CPU) und Arbeitsspeicher (RAM)",
        "content": "**CPU (Central Processing Unit)**:\n- **Kerne (Cores)**: Anzahl paralleler Recheneinheiten. Mehr Kerne = bessere Multitasking-Performance. Heute Standard: 4–16 Kerne für Desktop-PCs.\n- **Taktfrequenz (GHz)**: Gibt an, wie viele Berechnungen pro Sekunde möglich sind. Höherer Takt = schneller (bei gleicher Architektur).\n- **Cache**: Ultraschneller Zwischenspeicher direkt auf der CPU. L1 (kleinster, schnellster) → L2 → L3 (größter, langsamer). Reduziert RAM-Zugriffe.\n- **Sockel**: Mechanische Schnittstelle zwischen CPU und Mainboard. AMD nutzt AM4/AM5, Intel nutzt LGA1700/LGA1851. CPU und Mainboard müssen kompatiblen Sockel haben.\n\n**RAM (Random Access Memory)**:\n- **DDR4 / DDR5**: Aktuelle RAM-Generationen. DDR5 ist schneller und energieeffizienter, aber teurer. Nicht abwärtskompatibel.\n- **Dual-Channel**: Zwei RAM-Module werden parallel betrieben und verdoppeln so die Speicherbandbreite. Wichtig: Module in die richtigen Slots stecken (meist Slot 2+4).\n- **Kapazität**: 16 GB für Office, 32 GB für professionelle Anwendungen, 64+ GB für Workstations."
      },
      {
        "heading": "Speicher, Mainboard, GPU und Netzteil",
        "content": "**Speicher:**\n- **HDD (Hard Disk Drive)**: Magnetische Scheiben, rotierend. Günstig, hohe Kapazität, aber langsam (~100 MB/s) und erschütterungsempfindlich.\n- **SSD (Solid State Drive)**: Keine beweglichen Teile. SATA-SSD: ~550 MB/s. NVMe-SSD (M.2-Slot): 3.000–7.000 MB/s. Deutlich schneller und robuster als HDD.\n\n**Mainboard:**\n- **Chipsatz**: Koordiniert Kommunikation zwischen CPU, RAM, PCIe-Slots und Anschlüssen. Bestimmt Übertaktbarkeit und verfügbare Features.\n- **Formfaktor**: ATX (30,5×24,4 cm, Standard), mATX (kleiner, weniger Slots), ITX (sehr kompakt).\n\n**GPU (Grafikkarte):**\n- Für professionelle Workstations (CAD, Video) oder Gaming. Eigener VRAM (4–24 GB). Integrierte Grafik (iGPU) für Office ausreichend.\n\n**Netzteil (PSU):**\n- **Wirkungsgrad / 80Plus**: Zertifizierung für Effizienz. 80Plus Bronze → Silver → Gold → Platinum → Titanium. Gold = mind. 90% Effizienz.\n- Leistung in Watt ausreichend für alle Komponenten wählen (10–20% Puffer)."
      }
    ],
    "summary": "Bei der Hardwareauswahl müssen CPU-Sockel, RAM-Typ, Speichergeschwindigkeit (NVMe > SATA > HDD), Mainboard-Formfaktor und Netzteileffizienz aufeinander abgestimmt werden."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 2 — Arbeitsplätze nach Kundenwunsch ausstatten' AND track = 'umschulung'),
  'Kalkulation und Angebotserstellung',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Preiskalkulation: Von Einkauf bis Verkauf",
        "content": "Die Kalkulation ermittelt, zu welchem Preis ein Produkt verkauft werden muss, um Kosten zu decken und Gewinn zu erzielen.\n\n**Kalkulationsschema (vereinfacht):**\n\n```\nListeneinkaufspreis (Listenpreis des Lieferanten)\n– Lieferantenrabatt\n= Zieleinkaufspreis\n– Lieferantenskonto\n= Bareinkaufspreis\n+ Bezugskosten (Fracht, Verpackung)\n= Bezugspreis (= Einstandspreis)\n+ Handlungskosten (Gemeinkosten: Miete, Personal, Energie)\n= Selbstkostenpreis\n+ Gewinnzuschlag\n= Barverkaufspreis\n+ Kundenskonto\n+ Kundenrabatt\n= Listenverkaufspreis (netto)\n+ Mehrwertsteuer (19% oder 7%)\n= Listenverkaufspreis (brutto)\n```\n\n**Merke:** Der **Bezugspreis** ist der tatsächliche Einstandspreis (was das Unternehmen wirklich für die Ware bezahlt). Der **Selbstkostenpreis** deckt alle Kosten ab."
      },
      {
        "heading": "Angebotserstellung: Pflichtangaben",
        "content": "Ein rechtsgültiges Angebot muss bestimmte Pflichtangaben enthalten:\n\n**Pflichtangaben im Angebot:**\n- Name und Anschrift des Anbieters (Absender)\n- Name und Anschrift des Empfängers\n- Datum des Angebots\n- Angebotsnummer (für spätere Referenz)\n- Genaue Bezeichnung der Ware/Dienstleistung (Artikelbezeichnung, Menge, Einheit)\n- Einzelpreise und Gesamtpreis (netto)\n- Mehrwertsteuer (Steuersatz und -betrag getrennt ausgewiesen)\n- Gesamtbetrag (brutto)\n- Zahlungsbedingungen (z.B. 30 Tage netto, 2% Skonto bei Zahlung innerhalb 10 Tage)\n- Lieferbedingungen und Lieferzeitpunkt\n- Gültigkeitsdauer des Angebots\n\n**Umsatzsteuer:** Regelsteuersatz 19% (die meisten Waren), ermäßigt 7% (z.B. Lebensmittel, Bücher). Als Fachinformatiker: IT-Hardware und Software = 19%."
      }
    ],
    "summary": "Kalkulation erfolgt vom Listeneinkaufspreis über Bezugspreis und Selbstkostenpreis zum Verkaufspreis; im Angebot müssen Preise netto und brutto mit Mehrwertsteuer ausgewiesen sein."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 2 — Arbeitsplätze nach Kundenwunsch ausstatten' AND track = 'umschulung'),
  'Quiz: Hardware-Komponenten',
  'quiz',
  $json${
    "question": "Ein Kunde möchte maximale RAM-Geschwindigkeit aus seinem System herausholen. Er hat ein Mainboard mit 4 RAM-Slots und kauft 2 DDR5-Module à 16 GB. In welche Slots sollte er die Module stecken?",
    "options": [
      "In Slot 1 und 2 (die ersten beiden Slots)",
      "In Slot 2 und 4 (für Dual-Channel-Betrieb)",
      "In Slot 1 und 3 (alternierend)",
      "Es ist egal, welche Slots genutzt werden"
    ],
    "correct_index": 1,
    "explanation": "Für Dual-Channel-Betrieb müssen die RAM-Module in den richtigen Slots stecken — bei 4 Slots typischerweise Slot 2 und 4 (manchmal auch 1 und 3, je nach Mainboard). Im Dual-Channel-Modus werden beide Module parallel angesprochen, was die Speicherbandbreite verdoppelt. Die genauen Slots stehen im Mainboard-Handbuch."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 3 — Clients in Netzwerke einbinden
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 3 — Clients in Netzwerke einbinden' AND track = 'umschulung'),
  'IP-Adressen und Subnetting',
  'theory',
  $json${
    "sections": [
      {
        "heading": "IPv4-Adressen und Subnetzmasken",
        "content": "**Aufbau einer IPv4-Adresse:**\nEine IPv4-Adresse besteht aus 32 Bits, dargestellt als 4 Oktette (je 8 Bit) in Dezimalschreibweise: z.B. `192.168.1.100`\n\nJede Adresse besteht aus:\n- **Netzanteil**: Identifiziert das Netzwerk\n- **Hostanteil**: Identifiziert das Gerät im Netzwerk\n\nDie **Subnetzmaske** trennt Netz- von Hostanteil:\n- `255.255.255.0` = CIDR `/24` → 24 Bits für Netz, 8 Bits für Hosts → 254 nutzbare Hosts\n- `255.255.0.0` = CIDR `/16` → 65.534 nutzbare Hosts\n- `255.0.0.0` = CIDR `/8` → ~16 Millionen Hosts\n\n**Private IP-Bereiche (nicht im Internet geroutet):**\n| Bereich | CIDR | Anzahl Adressen |\n|---|---|---|\n| 10.0.0.0 – 10.255.255.255 | /8 | ~16 Mio. |\n| 172.16.0.0 – 172.31.255.255 | /12 | ~1 Mio. |\n| 192.168.0.0 – 192.168.255.255 | /16 | 65.536 |"
      },
      {
        "heading": "Subnetting: Schritt für Schritt",
        "content": "**Aufgabe:** Netzwerk `192.168.10.0/26` analysieren.\n\n**Schritt 1: Subnetzmaske bestimmen**\n/26 = 26 Bits gesetzt → `11111111.11111111.11111111.11000000` = `255.255.255.192`\n\n**Schritt 2: Anzahl Hosts berechnen**\nHostbits = 32 − 26 = 6 Bits → 2⁶ = 64 Adressen − 2 (Netzadresse + Broadcast) = **62 nutzbare Hosts**\n\n**Schritt 3: Netzadresse und Broadcast**\n- Netzadresse: `192.168.10.0` (Host-Teil = 0)\n- Broadcast: `192.168.10.63` (Host-Teil = alle 1er)\n- Nutzbare Hosts: `192.168.10.1` bis `192.168.10.62`\n\n**Merksatz für Hosts:** 2^(Hostbits) − 2\n\n**Standardgateway**: Der Router im Netzwerk, meist `.1` (z.B. `192.168.10.1`), leitet Pakete in andere Netze weiter."
      }
    ],
    "summary": "IPv4-Adressen haben 32 Bits; die Subnetzmaske trennt Netz- von Hostanteil; mit /Präfix-Notation lässt sich die Anzahl nutzbarer Hosts als 2^Hostbits − 2 berechnen."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 3 — Clients in Netzwerke einbinden' AND track = 'umschulung'),
  'Das OSI-Modell',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Die 7 Schichten des OSI-Modells",
        "content": "Das OSI-Modell (Open Systems Interconnection) standardisiert Netzwerkkommunikation in 7 Schichten.\n\n**Merksatz (unten nach oben):** \"**P**hysiker **S**pielen **N**achts **T**ischtennis **S**ehr **D**ynamisch **A**n\"\n\n| Nr. | Schicht | Funktion | Protokolle / Geräte |\n|---|---|---|---|\n| 7 | Anwendung (Application) | Schnittstelle zu Anwendungen | HTTP, HTTPS, FTP, SMTP, DNS, SSH |\n| 6 | Darstellung (Presentation) | Dateiformat, Verschlüsselung, Kompression | TLS/SSL, JPEG, ASCII, Unicode |\n| 5 | Sitzung (Session) | Auf- und Abbau von Verbindungen | NetBIOS, RPC, SIP |\n| 4 | Transport (Transport) | Zuverlässige Übertragung, Ports | TCP (zuverlässig), UDP (schnell) |\n| 3 | Vermittlung (Network) | Routing zwischen Netzwerken, IP-Adressen | IP, ICMP, Router |\n| 2 | Sicherung (Data Link) | Fehlerkorrektur, MAC-Adressen | Ethernet, WLAN (802.11), Switch |\n| 1 | Bitübertragung (Physical) | Übertragung von Bits | Kabel, Glasfaser, Hub, Repeater |"
      },
      {
        "heading": "Wichtige OSI-Konzepte für die IHK-Prüfung",
        "content": "**Layer 3 (Vermittlung) vs. Layer 2 (Sicherung):**\n- Layer 3: **Router** arbeiten auf dieser Schicht. Sie nutzen **IP-Adressen** und verbinden verschiedene Netzwerke.\n- Layer 2: **Switches** arbeiten hier. Sie nutzen **MAC-Adressen** (hardware-basiert, 48 Bit, z.B. `AA:BB:CC:DD:EE:FF`) und verbinden Geräte im selben Netzwerk.\n\n**TCP vs. UDP (Layer 4):**\n| Merkmal | TCP | UDP |\n|---|---|---|\n| Verbindung | Verbindungsorientiert (3-Way-Handshake) | Verbindungslos |\n| Zuverlässigkeit | Garantierte Zustellung, Reihenfolge | Keine Garantie |\n| Geschwindigkeit | Langsamer (Overhead) | Schneller |\n| Einsatz | HTTP, E-Mail, Dateitransfer | DNS, Streaming, VoIP |\n\n**Wichtige Ports (Layer 4):**\n- 80: HTTP | 443: HTTPS | 22: SSH | 25: SMTP | 53: DNS | 3389: RDP"
      }
    ],
    "summary": "Das OSI-Modell hat 7 Schichten; für die IHK wichtig: Layer 1 (Physisch/Hub), Layer 2 (Switch/MAC), Layer 3 (Router/IP), Layer 4 (TCP/UDP/Ports), Layer 7 (Anwendungsprotokolle)."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 3 — Clients in Netzwerke einbinden' AND track = 'umschulung'),
  'Quiz: OSI-Modell und Netzwerkgrundlagen',
  'quiz',
  $json${
    "question": "Auf welcher OSI-Schicht arbeitet ein Switch, und welche Adressen verwendet er zur Weiterleitung von Datenpaketen?",
    "options": [
      "Schicht 3 (Vermittlung), IP-Adressen",
      "Schicht 2 (Sicherung), MAC-Adressen",
      "Schicht 1 (Bitübertragung), keine Adressierung",
      "Schicht 4 (Transport), Port-Nummern"
    ],
    "correct_index": 1,
    "explanation": "Ein Switch arbeitet auf Schicht 2 (Sicherungsschicht) und nutzt MAC-Adressen (48-Bit-Hardwareadressen) zur Weiterleitung von Frames innerhalb eines Netzwerksegments. Router hingegen arbeiten auf Schicht 3 und nutzen IP-Adressen, um zwischen verschiedenen Netzwerken zu vermitteln."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 4 — Schutzbedarfsanalyse
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 4 — Schutzbedarfsanalyse' AND track = 'umschulung'),
  'IT-Sicherheit: CIA-Triad und Schutzziele',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Die drei Schutzziele: CIA-Triad",
        "content": "Die drei grundlegenden Schutzziele der IT-Sicherheit bilden die sogenannte **CIA-Triad**:\n\n**C — Vertraulichkeit (Confidentiality)**\nNur autorisierte Personen dürfen auf Daten zugreifen. Beispiel: Patientendaten darf nur der behandelnde Arzt einsehen.\n*Maßnahmen:* Verschlüsselung (AES, TLS), Zugriffskontrollen, Benutzerrechte, VPN\n\n**I — Integrität (Integrity)**\nDaten dürfen nur von autorisierten Personen verändert werden. Veränderungen müssen nachvollziehbar sein.\n*Maßnahmen:* Hashwerte (SHA-256), digitale Signaturen, Versionierung, Prüfsummen\n\n**A — Verfügbarkeit (Availability)**\nSysteme und Daten müssen für berechtigte Nutzer zugänglich sein, wenn sie benötigt werden.\n*Maßnahmen:* Redundanz, RAID, Backup, USV (unterbrechungsfreie Stromversorgung), DDoS-Schutz\n\n**Erweiterte Schutzziele:**\n- **Authentizität**: Identität des Kommunikationspartners ist nachweisbar\n- **Nicht-Abstreitbarkeit**: Aktionen können dem Verursacher nachgewiesen werden"
      },
      {
        "heading": "Bedrohungen und Schutzmaßnahmen",
        "content": "**Typische Bedrohungen:**\n\n| Bedrohung | Beschreibung | Ziel der Verletzung |\n|---|---|---|\n| Malware (Viren, Trojaner, Ransomware) | Schadprogramme, die Systeme infizieren | Verfügbarkeit, Vertraulichkeit |\n| Phishing | Täuschende E-Mails / Webseiten zur Dateneingabe | Vertraulichkeit |\n| Social Engineering | Manipulation von Menschen zur Informationspreisgabe | Vertraulichkeit |\n| DDoS (Distributed Denial of Service) | Überlastung von Servern durch Massen-Anfragen | Verfügbarkeit |\n| SQL-Injection | Einschleusen von SQL-Befehlen in Eingabefelder | Vertraulichkeit, Integrität |\n\n**Schutzmaßnahmen (technisch und organisatorisch):**\n- **Firewall**: Filtert Netzwerkverkehr nach Regelwerk (Port, IP, Protokoll)\n- **Verschlüsselung**: TLS für Übertragung, AES für Speicherung\n- **Backup-Strategie**: 3-2-1-Regel (3 Kopien, 2 verschiedene Medien, 1 extern)\n- **MFA (Multi-Faktor-Authentifizierung)**: Passwort + zweiter Faktor (App, SMS, Hardware-Token)\n- **Patch-Management**: Regelmäßige Updates schließen bekannte Sicherheitslücken\n- **Awareness-Schulungen**: Mitarbeiter für Phishing und Social Engineering sensibilisieren"
      }
    ],
    "summary": "Die CIA-Triad (Vertraulichkeit, Integrität, Verfügbarkeit) sind die Kern-Schutzziele; typische Bedrohungen sind Malware, Phishing, Social Engineering und DDoS; Gegenmaßnahmen umfassen Firewall, Verschlüsselung, Backup und MFA."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 4 — Schutzbedarfsanalyse' AND track = 'umschulung'),
  'DSGVO und Datenschutz-Grundlagen',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Grundsätze der DSGVO",
        "content": "Die **DSGVO (Datenschutz-Grundverordnung)** gilt seit dem 25. Mai 2018 in der gesamten EU und regelt den Umgang mit personenbezogenen Daten.\n\n**7 Grundsätze (Art. 5 DSGVO):**\n1. **Rechtmäßigkeit, Verarbeitung nach Treu und Glauben, Transparenz**: Datenverarbeitung muss auf einer Rechtsgrundlage basieren (Einwilligung, Vertrag, gesetzliche Pflicht)\n2. **Zweckbindung**: Daten dürfen nur für den angegebenen Zweck verarbeitet werden\n3. **Datensparsamkeit (Datenminimierung)**: Nur so viele Daten wie nötig erheben\n4. **Richtigkeit**: Daten müssen aktuell und korrekt sein\n5. **Speicherbegrenzung**: Daten nicht länger als nötig aufbewahren\n6. **Integrität und Vertraulichkeit**: Technische und organisatorische Maßnahmen zum Schutz\n7. **Rechenschaftspflicht**: Der Verantwortliche muss die Einhaltung nachweisen können\n\n**Personenbezogene Daten**: Alle Daten, die eine natürliche Person identifizieren oder identifizierbar machen (Name, Adresse, IP-Adresse, Cookies).\n\n**Besondere Kategorien** (Art. 9, erhöhter Schutz): Gesundheitsdaten, biometrische Daten, genetische Daten, religiöse/politische Überzeugungen, ethnische Herkunft."
      },
      {
        "heading": "Betroffenenrechte und betriebliche Umsetzung",
        "content": "**Rechte der betroffenen Personen (Art. 15-21 DSGVO):**\n- **Auskunftsrecht (Art. 15)**: Jede Person kann Auskunft verlangen, welche Daten gespeichert sind\n- **Recht auf Berichtigung (Art. 16)**: Falsche Daten müssen korrigiert werden\n- **Recht auf Löschung / Vergessenwerden (Art. 17)**: Daten müssen auf Anfrage gelöscht werden (wenn kein Aufbewahrungsgrund)\n- **Recht auf Einschränkung (Art. 18)**: Verarbeitung kann eingeschränkt werden\n- **Recht auf Datenübertragbarkeit (Art. 20)**: Daten in maschinenlesbarem Format herausgeben\n- **Widerspruchsrecht (Art. 21)**: Widerspruch gegen bestimmte Verarbeitungen\n\n**Betriebliche Pflichten:**\n- **Datenschutzbeauftragter (DSB)**: Pflicht ab 20 Personen, die regelmäßig personenbezogene Daten verarbeiten\n- **Datenschutz-Folgenabschätzung (DSFA)**: Bei risikoreichen Verarbeitungen (z.B. Videoüberwachung großer Bereiche)\n- **Meldepflicht bei Datenpannen**: Behörde innerhalb 72 Stunden informieren, Betroffene unverzüglich\n- **Verarbeitungsverzeichnis**: Dokumentation aller Datenverarbeitungstätigkeiten\n\n**Bußgelder bei Verstoß**: Bis zu 20 Mio. € oder 4% des weltweiten Jahresumsatzes (der höhere Betrag)."
      }
    ],
    "summary": "Die DSGVO basiert auf 7 Grundsätzen (u.a. Zweckbindung, Datensparsamkeit, Transparenz) und gibt Betroffenen Rechte auf Auskunft, Berichtigung und Löschung; Verstöße können bis zu 20 Mio. € Bußgeld kosten."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 4 — Schutzbedarfsanalyse' AND track = 'umschulung'),
  'Quiz: IT-Sicherheit und DSGVO',
  'quiz',
  $json${
    "question": "Ein Unternehmen speichert Kundendaten für Marketingzwecke. Nun möchte ein Kunde wissen, welche seiner Daten gespeichert sind, und verlangt auf Anfrage die Löschung aller Daten. Welche DSGVO-Artikel sind hier relevant?",
    "options": [
      "Auskunftsrecht (Art. 15) und Recht auf Löschung (Art. 17)",
      "Zweckbindung (Art. 5) und Meldepflicht (Art. 33)",
      "Datensparsamkeit (Art. 5) und Datenübertragbarkeit (Art. 20)",
      "Rechenschaftspflicht (Art. 5) und Widerspruchsrecht (Art. 21)"
    ],
    "correct_index": 0,
    "explanation": "Das Auskunftsrecht (Art. 15 DSGVO) gibt jeder Person das Recht zu erfahren, welche personenbezogenen Daten über sie gespeichert sind. Das Recht auf Löschung (Art. 17, auch 'Recht auf Vergessenwerden') ermöglicht es, die Löschung der eigenen Daten zu verlangen — sofern kein vorrangiger Aufbewahrungsgrund (z.B. gesetzliche Aufbewahrungspflicht) entgegensteht."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 5 — Software zur Verwaltung von Daten anpassen
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 5 — Software zur Verwaltung von Daten anpassen' AND track = 'umschulung'),
  'Relationale Datenbanken und SQL-Grundlagen',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Grundkonzepte relationaler Datenbanken",
        "content": "**Tabellen und Beziehungen:**\nEine relationale Datenbank speichert Daten in **Tabellen** (Relationen). Jede Tabelle hat:\n- **Spalten (Attribute)**: Beschreiben die Eigenschaften (z.B. `name`, `preis`)\n- **Zeilen (Tupel/Datensätze)**: Enthalten die konkreten Datenwerte\n\n**Schlüsseltypen:**\n- **Primärschlüssel (Primary Key, PK)**: Identifiziert jeden Datensatz eindeutig. Darf nicht NULL sein und muss eindeutig sein.\n- **Fremdschlüssel (Foreign Key, FK)**: Verweist auf den Primärschlüssel einer anderen Tabelle. Stellt referentielle Integrität sicher.\n- **Zusammengesetzter Schlüssel**: PK aus mehreren Spalten (z.B. Bestellposition = BestellNr + ProduktNr)\n\n**Normalisierung — Warum?**\nVermeidet Redundanzen (doppelte Datenhaltung) und Anomalien (Einfüge-, Änderungs-, Löschanomalien).\n\n**1. Normalform (1NF):** Alle Attributwerte sind atomar (keine Listen in einer Zelle). Jede Spalte enthält nur einen Wert.\n\n**2. Normalform (2NF):** Erfüllt 1NF + jedes Nicht-Schlüsselattribut ist vom **gesamten** Primärschlüssel abhängig (relevant bei zusammengesetztem PK). Keine Teilabhängigkeiten.\n\n**3. Normalform (3NF):** Erfüllt 2NF + kein Nicht-Schlüsselattribut ist von einem anderen Nicht-Schlüsselattribut abhängig. Keine transitiven Abhängigkeiten."
      },
      {
        "heading": "ER-Diagramme und SQL-Grundbefehle",
        "content": "**Entity-Relationship-Diagramm (ERD):**\n- **Entität** (Rechteck): Objekt der realen Welt (z.B. Kunde, Produkt)\n- **Attribut** (Oval): Eigenschaft einer Entität (z.B. Kundenname, Preis)\n- **Beziehung** (Raute): Verbindung zwischen Entitäten (z.B. Kunde *kauft* Produkt)\n- **Kardinalitäten**: 1:1, 1:N (ein Kunde hat viele Bestellungen), M:N (viele Kunden kaufen viele Produkte)\n\n**SQL-Grundbefehle:**\n```sql\n-- Daten abfragen\nSELECT name, preis FROM produkte WHERE kategorie = 'Hardware' ORDER BY preis ASC;\n\n-- Tabellen verknüpfen\nSELECT k.name, b.datum\nFROM kunden k\nINNER JOIN bestellungen b ON k.id = b.kunden_id;\n\n-- Daten gruppieren\nSELECT kategorie, COUNT(*) AS anzahl, AVG(preis) AS durchschnittspreis\nFROM produkte\nGROUP BY kategorie\nHAVING COUNT(*) > 2;\n\n-- DML-Befehle\nINSERT INTO produkte (name, preis) VALUES ('SSD 1TB', 89.99);\nUPDATE produkte SET preis = 79.99 WHERE id = 5;\nDELETE FROM produkte WHERE id = 5;\n```"
      }
    ],
    "summary": "Relationale Datenbanken nutzen Tabellen mit Primär- und Fremdschlüsseln; Normalisierung (1NF, 2NF, 3NF) beseitigt Redundanzen; SQL-Befehle SELECT, JOIN, GROUP BY, INSERT, UPDATE, DELETE sind Grundlage jeder Datenbankarbeit."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 5 — Software zur Verwaltung von Daten anpassen' AND track = 'umschulung'),
  'SQL-Abfragen mit Python und SQLite',
  'quiz',
  $json${
    "question": "Welche Normalform wird verletzt, wenn eine Tabelle 'Bestellung' die Spalten (BestellNr, ProduktNr, ProduktName, Menge) hat und ProduktName nur von ProduktNr abhängt, aber der PK aus (BestellNr + ProduktNr) besteht?",
    "options": [
      "1. Normalform (1NF), weil Attributwerte nicht atomar sind",
      "2. Normalform (2NF), weil ProduktName nur vom Teil-Schlüssel ProduktNr abhängt",
      "3. Normalform (3NF), weil eine transitive Abhängigkeit besteht",
      "Keine Normalform ist verletzt"
    ],
    "correct_index": 1,
    "explanation": "Die 2. Normalform (2NF) ist verletzt: Der Primärschlüssel ist zusammengesetzt (BestellNr + ProduktNr), aber ProduktName hängt nur vom Teilschlüssel ProduktNr ab — nicht vom gesamten PK. Das ist eine Teilabhängigkeit. Lösung: ProduktName in eine separate Tabelle 'Produkte(ProduktNr, ProduktName)' auslagern."
  }$json$,
  10,
  2
);
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 5 — Software zur Verwaltung von Daten anpassen' AND track = 'umschulung'),
  'Python & SQLite: Datenbankabfragen',
  'code',
  $json${
    "instructions": "Nutze die vorbereitete SQLite-Datenbank mit der Tabelle 'produkte'. Schreibe eine SQL-Abfrage, die alle Hardware-Produkte ausgibt, sortiert nach Preis aufsteigend. Gib Name und Preis aus.\n\nVerwende cursor.execute() mit deiner SQL-Abfrage und cursor.fetchall() um die Ergebnisse zu holen. Gib jede Zeile aus.",
    "starter_code": "import sqlite3\nconn = sqlite3.connect(':memory:')\ncursor = conn.cursor()\ncursor.execute('''CREATE TABLE produkte (id INTEGER PRIMARY KEY, name TEXT, preis REAL, kategorie TEXT)''')\ncursor.executemany('INSERT INTO produkte VALUES (?,?,?,?)', [\n    (1, 'Laptop', 899.99, 'Hardware'),\n    (2, 'Maus', 29.99, 'Hardware'),\n    (3, 'Windows 11', 199.99, 'Software'),\n])\nconn.commit()\n\n# Aufgabe: Schreibe eine SQL-Abfrage, die alle Hardware-Produkte ausgibt,\n# sortiert nach Preis (aufsteigend). Gib Name und Preis aus.\n# Hinweis: Nutze cursor.execute() und cursor.fetchall()\n\n# Dein Code hier:\n",
    "expected_output": "('Maus', 29.99)\n('Laptop', 899.99)\n",
    "hints": [
      "Nutze WHERE kategorie = 'Hardware' in deiner SQL-Abfrage",
      "ORDER BY preis ASC sortiert aufsteigend nach Preis",
      "Mit cursor.fetchall() bekommst du alle Ergebnisse als Liste von Tupeln — iteriere mit einer for-Schleife und print() darüber"
    ],
    "solution": "import sqlite3\nconn = sqlite3.connect(':memory:')\ncursor = conn.cursor()\ncursor.execute('''CREATE TABLE produkte (id INTEGER PRIMARY KEY, name TEXT, preis REAL, kategorie TEXT)''')\ncursor.executemany('INSERT INTO produkte VALUES (?,?,?,?)', [\n    (1, 'Laptop', 899.99, 'Hardware'),\n    (2, 'Maus', 29.99, 'Hardware'),\n    (3, 'Windows 11', 199.99, 'Software'),\n])\nconn.commit()\n\ncursor.execute(\"SELECT name, preis FROM produkte WHERE kategorie = 'Hardware' ORDER BY preis ASC\")\nresults = cursor.fetchall()\nfor row in results:\n    print(row)"
  }$json$,
  20,
  3,
  'python'
);

-- ============================================================
-- LF 6 — Serviceanfragen bearbeiten
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 6 — Serviceanfragen bearbeiten' AND track = 'umschulung'),
  'Ticketsysteme und ITSM-Grundlagen',
  'theory',
  $json${
    "sections": [
      {
        "heading": "ITSM: Incident, Problem und Change Management",
        "content": "**ITSM (IT Service Management)** bezeichnet die Gesamtheit aller Aktivitäten zur Bereitstellung und Verwaltung von IT-Services. Das bekannteste Framework ist **ITIL (Information Technology Infrastructure Library)**.\n\n**Drei Kernprozesse:**\n\n**Incident Management:**\nEin **Incident** ist eine ungeplante Unterbrechung oder Qualitätsminderung eines IT-Services.\n*Ziel:* Schnellstmögliche Wiederherstellung des Normalbetriebs.\n*Beispiel:* Ein Drucker druckt nicht mehr.\n\n**Problem Management:**\nEin **Problem** ist die Ursache eines oder mehrerer Incidents.\n*Ziel:* Ursachenanalyse (Root Cause Analysis) und dauerhafte Behebung.\n*Beispiel:* Der Druckertreiber ist nach einem Windows-Update inkompatibel (Ursache mehrerer Druckerausfälle).\n\n**Change Management:**\nEin **Change** ist eine autorisierte Änderung an der IT-Infrastruktur.\n*Ziel:* Kontrolle und Dokumentation von Änderungen, um neue Incidents zu vermeiden.\n*Beispiel:* Migration auf neuen Druckserver — muss geplant, getestet und freigegeben werden.\n\n**Support-Level:**\n- **1st Level**: Erstanlaufstelle, nimmt Tickets an, löst Standardprobleme (Passwort zurücksetzen)\n- **2nd Level**: Tiefere technische Analyse, löst komplexere Probleme\n- **3rd Level**: Spezialisten, Hersteller-Support, Eskalation bei unbekannten Fehlern"
      },
      {
        "heading": "Ticket-Lebenszyklus und SLA",
        "content": "**Ticket-Lebenszyklus:**\n```\nEingang → Offen → In Bearbeitung → Wartend (auf Rückmeldung/Teile) → Gelöst → Geschlossen\n```\n\n**Ticketprioritäten (Beispiel):**\n| Priorität | Beschreibung | Reaktionszeit | Lösungszeit |\n|---|---|---|---|\n| Kritisch | Gesamter Betrieb steht still | 15 Minuten | 4 Stunden |\n| Hoch | Wichtige Systeme betroffen, Umgehungslösung möglich | 1 Stunde | 8 Stunden |\n| Mittel | Einzelner Nutzer eingeschränkt | 4 Stunden | 24 Stunden |\n| Niedrig | Kosmetische Fehler, keine Beeinträchtigung | 8 Stunden | 72 Stunden |\n\n**SLA (Service Level Agreement):**\nEin SLA ist ein vertraglich vereinbartes Serviceniveau zwischen IT-Dienstleister und Kunde. Es definiert:\n- Verfügbarkeit (z.B. 99,9% Uptime = max. 8,76 Stunden Ausfall/Jahr)\n- Reaktionszeiten (Zeit bis zur ersten Reaktion)\n- Lösungszeiten (Zeit bis zur Behebung)\n- Konsequenzen bei Verletzung (Vertragsstrafen, Gutschriften)"
      }
    ],
    "summary": "ITSM unterscheidet Incident (Symptom), Problem (Ursache) und Change (Änderung); Tickets durchlaufen einen definierten Lebenszyklus; SLAs vereinbaren Verfügbarkeits- und Reaktionszeiten vertraglich."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 6 — Serviceanfragen bearbeiten' AND track = 'umschulung'),
  'Professionelle Kundenkommunikation',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Gesprächsführung und Fragetechniken",
        "content": "**Aktives Zuhören:**\nAktives Zuhören bedeutet, dem Gesprächspartner volle Aufmerksamkeit zu schenken und zu signalisieren, dass man ihn versteht.\n- Verbale Signale: \"Ich verstehe\", \"Das klingt frustrierend\", Zusammenfassungen\n- Paraphrasieren: Das Gesagte in eigenen Worten wiederholen zur Vergewisserung\n- Nachfragen ohne Unterbrechung\n\n**Fragetechniken:**\n\n**Offene Fragen** (W-Fragen: Wer, Was, Wie, Wann, Warum, Wo):\n- Fördern ausführliche Antworten\n- Beispiel: \"Seit wann tritt das Problem auf?\" / \"Was passiert genau, wenn Sie auf Drucken klicken?\"\n- Einsatz: Zu Beginn des Gesprächs zur Problemerfassung\n\n**Geschlossene Fragen** (Ja/Nein-Antworten):\n- Präzisieren und eingrenzen\n- Beispiel: \"Haben Sie das System bereits neu gestartet?\" / \"Ist das Problem auf allen Geräten?\"\n- Einsatz: Zur Verifizierung von Vermutungen\n\n**Deeskalation bei verärgerten Kunden:**\n1. Ruhig und sachlich bleiben — niemals emotional gegensteuern\n2. Verständnis zeigen: \"Ich verstehe, dass das sehr ärgerlich ist\"\n3. Nicht Schuld zuweisen oder rechtfertigen\n4. Lösungsorientiert kommunizieren: \"Was ich jetzt für Sie tun kann, ist...\"\n5. Verbindliche Aussagen machen: Konkrete Zeitangaben nennen"
      },
      {
        "heading": "Dokumentation und Knowledge Base",
        "content": "**Warum Dokumentation wichtig ist:**\nGute Dokumentation ermöglicht:\n- Nachvollziehbarkeit von Lösungen für Kollegen und künftige Tickets\n- Aufbau einer **Knowledge Base** (Wissensdatenbank) für häufige Probleme\n- Auswertung von Trends (häufige Probleme = Candidate für Problem Management)\n- Nachweis gegenüber Kunden (SLA-Reporting)\n\n**Was im Ticket dokumentiert werden sollte:**\n- Problembeschreibung aus Kundensicht (wörtlich)\n- Fehlermeldungen (Screenshot oder exakter Text)\n- Durchgeführte Diagnoseschritte\n- Angewendete Lösung (Schritt für Schritt)\n- Beteiligte Systeme / Software / Versionen\n- Dauer der Bearbeitung\n- Kundenzufriedenheit / Abschlussbestätigung\n\n**KISS-Prinzip für Dokumentation:** Keep It Simple and Short — klare, verständliche Sprache, keine unnötigen Fachbegriffe wenn für Laien geschrieben."
      }
    ],
    "summary": "Professionelle Kundenkommunikation setzt aktives Zuhören, gezielte Fragetechniken (offen/geschlossen) und Deeskalationsfähigkeit voraus; vollständige Ticketdokumentation ist Grundlage für Knowledge Management und SLA-Nachweis."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 6 — Serviceanfragen bearbeiten' AND track = 'umschulung'),
  'Quiz: ITSM und Ticketpriorisierung',
  'quiz',
  $json${
    "question": "Der Server des Unternehmens ist komplett ausgefallen. Alle 50 Mitarbeiter können nicht arbeiten. Wie wird dieses Ticket priorisiert, und was ist das Ziel des Incident Managements in diesem Fall?",
    "options": [
      "Priorität: Niedrig — Ziel ist dauerhafte Ursachenbehebung durch Root Cause Analysis",
      "Priorität: Kritisch — Ziel ist schnellstmögliche Wiederherstellung des Normalbetriebs",
      "Priorität: Mittel — Ziel ist die Dokumentation für das Change Management",
      "Priorität: Hoch — Ziel ist die Erstellung eines SLA-Reports"
    ],
    "correct_index": 1,
    "explanation": "Ein kompletter Serverausfall mit 50 betroffenen Mitarbeitern ist ein kritischer Incident. Das Ziel des Incident Managements ist die schnellstmögliche Wiederherstellung des Normalbetriebs — auch durch temporäre Workarounds. Die dauerhafte Ursachenbehebung ist Aufgabe des Problem Managements, das parallel oder nachgelagert stattfindet."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 7 — Cyber-physische Systeme
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 7 — Cyber-physische Systeme' AND track = 'umschulung'),
  'IoT-Grundlagen und Architekturen',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Cyber-physische Systeme und IoT",
        "content": "**CPS (Cyber-physische Systeme):** Systeme, bei denen Software und physische Komponenten eng miteinander verknüpft sind. Die Software überwacht und steuert physikalische Prozesse in Echtzeit.\n\n**IoT (Internet of Things):** Vernetzte Alltagsgegenstände und Geräte, die über das Internet kommunizieren. Teilmenge der CPS mit Fokus auf Vernetzung.\n\n**Sensorik** (Eingang — nimmt Umweltdaten auf):\n- Temperatursensor (NTC, PT100) — misst Temperatur\n- Bewegungsmelder (PIR — Passive Infrared) — erkennt Wärmebewegung\n- Drucksensor — misst Luftdruck oder Flüssigkeitsdruck\n- Lichtsensor (LDR) — misst Helligkeit\n- Feuchtigkeitssensor — Luftfeuchtigkeit oder Bodenfeuchte\n\n**Aktoren** (Ausgang — reagiert auf Steuerbefehle):\n- Motoren (Servo, Schrittmotor) — Bewegung\n- Magnetventile — Fluid-/Gaszufuhr steuern\n- LEDs / Displays — visuelle Ausgabe\n- Relais — elektrische Verbraucher schalten\n- Lautsprecher — akustische Ausgabe\n\n**Mikrocontroller vs. Einplatinencomputer:**\n| | Mikrocontroller (z.B. Arduino) | Einplatinencomputer (z.B. Raspberry Pi) |\n|---|---|---|\n| Betriebssystem | Keins (direkte Programmierung) | Linux (Raspberry Pi OS) |\n| Leistung | Gering, deterministisch | Höher, nicht-deterministisch |\n| Einsatz | Echtzeitsensorik, einfache Steuerung | Bildverarbeitung, Webserver, KI |\n| Programmierung | C/C++, MicroPython | Python, Node.js, Java |"
      },
      {
        "heading": "IoT-Kommunikationsprotokolle",
        "content": "**MQTT (Message Queuing Telemetry Transport):**\n- Leichtgewichtiges Publish/Subscribe-Protokoll\n- Geeignet für ressourcenarme Geräte und instabile Verbindungen\n- Funktionsprinzip: Geräte *publishen* Daten auf Topics, andere Geräte *subscriben* Topics\n- Broker (z.B. Mosquitto) vermittelt Nachrichten\n- Beispiel: Temperatursensor publisht auf `haus/wohnzimmer/temperatur`, Heizungssteuerung subscribt dieses Topic\n\n**CoAP (Constrained Application Protocol):**\n- REST-ähnliches Protokoll für stark eingeschränkte Geräte\n- UDP-basiert (weniger Overhead als TCP)\n- Geeignet für Geräte mit sehr wenig RAM und CPU\n\n**HTTP/HTTPS:**\n- Für IoT-Geräte mit ausreichend Ressourcen (z.B. Raspberry Pi)\n- REST-APIs für Cloud-Kommunikation\n- Höherer Overhead als MQTT/CoAP\n\n**Vergleich:**\n| Protokoll | Schicht | Basis | Einsatz |\n|---|---|---|---|\n| MQTT | Anwendung | TCP | IoT-Messaging, Sensordaten |\n| CoAP | Anwendung | UDP | Sehr ressourcenarme Geräte |\n| HTTP | Anwendung | TCP | Cloud-APIs, ausreichend Ressourcen |"
      }
    ],
    "summary": "CPS/IoT verbindet Sensoren (Datenerfassung) und Aktoren (Steuerung) mit Software; MQTT ist das vorherrschende IoT-Protokoll (Publish/Subscribe über Broker); Mikrocontroller für Echtzeit, Raspberry Pi für komplexere Aufgaben."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 7 — Cyber-physische Systeme' AND track = 'umschulung'),
  'Datenverarbeitung in CPS',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Edge Computing vs. Cloud Computing",
        "content": "**Cloud Computing:**\nDaten werden an einen zentralen Server (Cloud) übertragen, dort verarbeitet und das Ergebnis zurückgeschickt.\n- Vorteile: Hohe Rechenleistung, einfache Skalierung, zentrale Verwaltung\n- Nachteile: Latenz (Verzögerung durch Netzwerkübertragung), Abhängigkeit von Internetverbindung, Datenschutzbedenken\n\n**Edge Computing:**\nDatenverarbeitung findet direkt am Gerät oder in der Nähe der Datenquelle statt (\"am Rand des Netzwerks\").\n- Vorteile: Geringe Latenz, funktioniert ohne Internet, Datenschutz (Daten verlassen das Gerät nicht)\n- Nachteile: Begrenzte Rechenleistung, verteilte Verwaltung aufwändiger\n\n**Wann welches Modell?**\n- **Echtzeitanforderungen** (z.B. Maschinensteuerung, autonomes Fahren) → Edge Computing\n- **Komplexe Analyse** (z.B. KI-Training, Big-Data-Auswertung) → Cloud Computing\n- **Hybridansatz**: Edge vorverarbeitet und filtert, Cloud analysiert\n\n**Datenströme in CPS:**\n- Sensoren liefern kontinuierliche Datenströme (Timeseries-Daten)\n- Herausforderungen: Hohe Datenmenge, Echtzeitverarbeitung, Speicherung\n- Lösungen: Stream Processing (Apache Kafka, Apache Flink), Zeitreihendatenbanken (InfluxDB)"
      },
      {
        "heading": "Sicherheitsaspekte bei vernetzten Geräten",
        "content": "IoT-Geräte sind oft schlecht gesichert und stellen ein erhebliches Sicherheitsrisiko dar.\n\n**Typische Schwachstellen:**\n- Standardpasswörter (admin/admin) werden nie geändert\n- Seltene oder fehlende Sicherheitsupdates\n- Unverschlüsselte Kommunikation\n- Keine Authentifizierung zwischen Geräten\n- Physischer Zugriff möglich\n\n**Bekannte Angriffe:**\n- **Botnetze** (z.B. Mirai-Botnetz 2016): Tausende unsichere IoT-Kameras wurden für DDoS-Angriffe missbraucht\n- **Man-in-the-Middle**: Daten werden abgehört oder manipuliert\n\n**Schutzmaßnahmen:**\n- Starke, individuelle Passwörter für jedes Gerät\n- Regelmäßige Firmware-Updates\n- Netzwerksegmentierung: IoT-Geräte in separates VLAN isolieren\n- Verschlüsselte Kommunikation (TLS/HTTPS, MQTT über TLS)\n- Authentifizierung mit Zertifikaten\n- Deaktivierung ungenutzter Dienste und Ports"
      }
    ],
    "summary": "Edge Computing verarbeitet Daten lokal mit niedriger Latenz; Cloud Computing bietet hohe Rechenleistung für komplexe Analysen; IoT-Sicherheit erfordert individuelle Passwörter, Updates, Netzwerksegmentierung und Verschlüsselung."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 7 — Cyber-physische Systeme' AND track = 'umschulung'),
  'Quiz: IoT und Cyber-physische Systeme',
  'quiz',
  $json${
    "question": "Ein Temperatursensor in einer Fabrikhalle sendet alle 5 Sekunden Messwerte. Welches Protokoll und welches Architekturmodell sind für diese Anwendung am besten geeignet, wenn eine Reaktionszeit unter 100ms erforderlich ist?",
    "options": [
      "HTTP und Cloud Computing — für maximale Rechenleistung",
      "MQTT und Edge Computing — leichtgewichtiges Protokoll, lokale Verarbeitung für niedrige Latenz",
      "CoAP und Cloud Computing — UDP-basiert für schnelle Übertragung",
      "FTP und Edge Computing — für zuverlässige Dateiübertragung"
    ],
    "correct_index": 1,
    "explanation": "MQTT ist das ideale Protokoll für kontinuierliche Sensordaten: leichtgewichtig, Publish/Subscribe-Modell, geringer Overhead. Edge Computing verarbeitet die Daten lokal direkt am Sensor, was Latenzen unter 100ms ermöglicht — Cloud-Kommunikation würde durch Netzwerklatenz diese Anforderung oft nicht erfüllen können."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 8 — Daten systemübergreifend bereitstellen
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 8 — Daten systemübergreifend bereitstellen' AND track = 'umschulung'),
  'REST-APIs und Datenformate',
  'theory',
  $json${
    "sections": [
      {
        "heading": "HTTP-Methoden und Statuscodes",
        "content": "**REST (Representational State Transfer)** ist ein Architekturstil für Web-APIs. REST-APIs nutzen HTTP und sind zustandslos.\n\n**HTTP-Methoden (CRUD-Zuordnung):**\n| Methode | Verwendung | Idempotent? |\n|---|---|---|\n| GET | Daten abrufen (Read) | Ja |\n| POST | Neue Ressource erstellen (Create) | Nein |\n| PUT | Ressource vollständig ersetzen (Update) | Ja |\n| PATCH | Ressource teilweise aktualisieren (Partial Update) | Nein |\n| DELETE | Ressource löschen (Delete) | Ja |\n\n**Idempotent** = mehrfaches Ausführen hat denselben Effekt wie einmaliges Ausführen.\n\n**HTTP-Statuscodes:**\n| Code | Bedeutung | Beispiel |\n|---|---|---|\n| 200 OK | Erfolgreiche Anfrage | GET liefert Daten |\n| 201 Created | Ressource erfolgreich erstellt | POST erfolgreich |\n| 204 No Content | Erfolg, keine Rückgabe | DELETE erfolgreich |\n| 400 Bad Request | Fehlerhafte Anfrage des Clients | Ungültige JSON-Syntax |\n| 401 Unauthorized | Nicht authentifiziert | Kein/falscher API-Key |\n| 403 Forbidden | Authentifiziert aber keine Berechtigung | Zu geringe Rechte |\n| 404 Not Found | Ressource nicht gefunden | Falsche URL |\n| 500 Internal Server Error | Fehler auf Serverseite | Bug im Backend |"
      },
      {
        "heading": "JSON vs. XML und API-Dokumentation",
        "content": "**JSON (JavaScript Object Notation):**\n- Leichtgewichtig, menschenlesbar, weit verbreitet\n- Datentypen: String, Number, Boolean, Array, Object, null\n```json\n{\n  \"kunde\": {\n    \"id\": 42,\n    \"name\": \"Max Mustermann\",\n    \"aktiv\": true,\n    \"bestellungen\": [101, 102, 103]\n  }\n}\n```\n\n**XML (eXtensible Markup Language):**\n- Ausführlicher, schemadefinierbar (XSD), in älteren Systemen verbreitet\n- Wird noch bei SOAP-Webservices, EDI-Systemen und Konfigurationsdateien genutzt\n```xml\n<kunde>\n  <id>42</id>\n  <name>Max Mustermann</name>\n</kunde>\n```\n\n**Vergleich JSON vs. XML:**\n| | JSON | XML |\n|---|---|---|\n| Lesbarkeit | Gut | Mittelmäßig (viel Markup) |\n| Dateigröße | Kleiner | Größer |\n| Verwendung | REST-APIs | SOAP, Legacy, Konfiguration |\n\n**API-Dokumentation (Swagger/OpenAPI):**\nOpenAPI-Spezifikation beschreibt REST-APIs maschinenlesbar (YAML/JSON). Swagger UI generiert daraus interaktive Dokumentation zum Testen. Enthält: Endpunkte, HTTP-Methoden, Parameter, Request/Response-Schemas, Authentifizierung."
      }
    ],
    "summary": "REST-APIs nutzen HTTP-Methoden (GET/POST/PUT/PATCH/DELETE) für CRUD-Operationen; Statuscodes signalisieren Erfolg (2xx), Client-Fehler (4xx) und Server-Fehler (5xx); JSON ist das Standard-Datenformat für moderne APIs."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 8 — Daten systemübergreifend bereitstellen' AND track = 'umschulung'),
  'Quiz: HTTP-Methoden und Statuscodes',
  'quiz',
  $json${
    "question": "Eine REST-API gibt den Statuscode 401 zurück. Was bedeutet das, und was sollte der Client als nächstes tun?",
    "options": [
      "Die Ressource wurde nicht gefunden (404) — der Client sollte die URL prüfen",
      "Der Client ist nicht authentifiziert — ein gültiger API-Key oder Token muss mitgeschickt werden",
      "Der Server hat einen internen Fehler — der Client sollte es später erneut versuchen",
      "Die Anfrage war fehlerhaft — der Client sollte das JSON-Format prüfen"
    ],
    "correct_index": 1,
    "explanation": "401 Unauthorized bedeutet, dass der Client nicht authentifiziert ist — also kein gültiges Authentifizierungsmerkmal (API-Key, Bearer Token, Cookies) mitgeschickt hat. 403 Forbidden würde bedeuten, der Client ist authentifiziert, hat aber keine Berechtigung. 404 ist 'Not Found', 500 ist ein Server-Fehler, 400 ist eine fehlerhafte Anfrage."
  }$json$,
  10,
  2
);
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 8 — Daten systemübergreifend bereitstellen' AND track = 'umschulung'),
  'Python: JSON-Daten aus API-Antwort verarbeiten',
  'code',
  $json${
    "instructions": "Eine API hat folgende Antwort zurückgegeben (als Python-Dictionary). Extrahiere alle Produkte mit einem Preis über 100 Euro und gib Name und Preis aus. Format: 'Name: Preis' (z.B. 'Laptop: 899.99')",
    "starter_code": "api_response = {\n    \"status\": \"success\",\n    \"data\": {\n        \"produkte\": [\n            {\"id\": 1, \"name\": \"Laptop\", \"preis\": 899.99},\n            {\"id\": 2, \"name\": \"Maus\", \"preis\": 29.99},\n            {\"id\": 3, \"name\": \"Monitor\", \"preis\": 349.99},\n            {\"id\": 4, \"name\": \"Tastatur\", \"preis\": 79.99},\n        ]\n    }\n}\n# Dein Code hier:\n",
    "expected_output": "Laptop: 899.99\nMonitor: 349.99\n",
    "hints": [
      "Navigiere durch das Dictionary: api_response['data']['produkte'] liefert die Liste der Produkte",
      "Iteriere mit einer for-Schleife über die Produktliste",
      "Prüfe mit einer if-Bedingung, ob produkt['preis'] > 100, und nutze dann print() zur Ausgabe"
    ],
    "solution": "api_response = {\n    \"status\": \"success\",\n    \"data\": {\n        \"produkte\": [\n            {\"id\": 1, \"name\": \"Laptop\", \"preis\": 899.99},\n            {\"id\": 2, \"name\": \"Maus\", \"preis\": 29.99},\n            {\"id\": 3, \"name\": \"Monitor\", \"preis\": 349.99},\n            {\"id\": 4, \"name\": \"Tastatur\", \"preis\": 79.99},\n        ]\n    }\n}\nfor produkt in api_response['data']['produkte']:\n    if produkt['preis'] > 100:\n        print(f\"{produkt['name']}: {produkt['preis']}\")"
  }$json$,
  20,
  3,
  'python'
);

-- ============================================================
-- LF 9 — Netzwerke und Dienste bereitstellen
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 9 — Netzwerke und Dienste bereitstellen' AND track = 'umschulung'),
  'DNS und DHCP verstehen',
  'theory',
  $json${
    "sections": [
      {
        "heading": "DNS: Domain Name System",
        "content": "DNS übersetzt menschenlesbare Domainnamen (z.B. `www.example.de`) in IP-Adressen (`93.184.216.34`).\n\n**DNS-Auflösung Schritt für Schritt:**\n1. Client fragt lokalen **DNS-Resolver** (meist vom Router/ISP bereitgestellt)\n2. Resolver prüft seinen Cache — wenn Antwort bekannt, direkte Rückgabe\n3. Resolver fragt **Root-Nameserver** (13 weltweit, verwalten Top-Level-Domains)\n4. Root verweist auf **TLD-Nameserver** (für `.de`, `.com`, `.org` etc.)\n5. TLD-Nameserver verweist auf **Autoritativen Nameserver** der Domain\n6. Autoritativer Nameserver gibt die IP-Adresse zurück\n7. Resolver gibt Antwort an Client, speichert sie im Cache (TTL)\n\n**Wichtige DNS-Record-Typen:**\n| Record | Funktion | Beispiel |\n|---|---|---|\n| A | IPv4-Adresse | example.de → 93.184.216.34 |\n| AAAA | IPv6-Adresse | example.de → 2606:2800::1 |\n| CNAME | Alias auf anderen Hostnamen | www → example.de |\n| MX | Mailserver für die Domain | example.de → mail.example.de |\n| TXT | Freitext (SPF, DKIM, Verifikation) | \"v=spf1 include:...\" |\n| NS | Nameserver der Domain | example.de → ns1.example.de |"
      },
      {
        "heading": "DHCP: Dynamische IP-Adressvergabe",
        "content": "DHCP (Dynamic Host Configuration Protocol) vergibt automatisch IP-Konfiguration an Clients.\n\n**DORA-Prozess (4 Schritte):**\n1. **D — Discover**: Client sendet Broadcast-Paket ins Netzwerk: \"Gibt es einen DHCP-Server?\"\n2. **O — Offer**: DHCP-Server antwortet: \"Ich biete dir die IP 192.168.1.50 an\"\n3. **R — Request**: Client akzeptiert das Angebot: \"Ich nehme 192.168.1.50 an\"\n4. **A — Acknowledge**: DHCP-Server bestätigt: \"IP 192.168.1.50 ist ab jetzt für dich reserviert\"\n\n**DHCP vergibt dabei:**\n- IP-Adresse (aus einem konfigurierten Pool)\n- Subnetzmaske\n- Standardgateway (Default Gateway)\n- DNS-Server-Adresse\n- Lease-Zeit (wie lange die IP gültig ist)\n\n**DHCP-Lease:** Eine IP-Adresse wird nicht permanent vergeben, sondern für eine bestimmte Zeit (Lease-Zeit, z.B. 24 Stunden). Nach Ablauf muss der Client erneuern (Renew).\n\n**DHCP-Reservierung:** MAC-Adresse des Geräts kann im Server fix einer IP zugeordnet werden (statisch via DHCP — Kompromiss zwischen statischer und dynamischer Vergabe)."
      }
    ],
    "summary": "DNS löst Domainnamen über eine Hierarchie (Root → TLD → Autoritativer Nameserver) in IP-Adressen auf; DHCP vergibt IP-Konfiguration automatisch über den DORA-Prozess (Discover, Offer, Request, Acknowledge)."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 9 — Netzwerke und Dienste bereitstellen' AND track = 'umschulung'),
  'Servergrundlagen und Virtualisierung',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Bare-Metal, VMs und Container",
        "content": "**Bare-Metal-Server:**\nPhysischer Server, Betriebssystem läuft direkt auf der Hardware.\n- Vorteile: Maximale Performance, keine Virtualisierungs-Overhead\n- Nachteile: Teure Hardware, schlechte Auslastung (oft 10-30%), aufwändige Wartung\n\n**Virtuelle Maschinen (VMs):**\nSoftware emuliert vollständige Hardware. Mehrere VMs teilen sich einen physischen Server.\n- **Hypervisor Typ 1 (Bare-Metal-Hypervisor)**: Läuft direkt auf Hardware, kein Hostbetriebssystem. Höhere Performance. Beispiele: VMware ESXi, Microsoft Hyper-V, KVM.\n- **Hypervisor Typ 2 (Hosted Hypervisor)**: Läuft als Anwendung auf einem Hostbetriebssystem. Einfacher zu installieren. Beispiele: VirtualBox, VMware Workstation.\n\nVMs haben: eigenes Betriebssystem, eigenen Kernel, vollständige Isolation.\n\n**Container:**\nTeilen den Kernel des Host-Betriebssystems, isolieren nur Prozesse und Dateisystem.\n- Deutlich leichtgewichtiger als VMs (Sekunden statt Minuten Startzeit)\n- Weniger Overhead, höhere Dichte (100+ Container auf einem Server möglich)\n- Keine vollständige Isolation (Kernel wird geteilt)\n- Beispiel: Docker, Podman"
      },
      {
        "heading": "Docker Grundkonzept",
        "content": "Docker ist die bekannteste Container-Plattform.\n\n**Kernkonzepte:**\n- **Image**: Unveränderliches Schablone/Vorlage für Container (wie eine ISO-Datei). Enthält Betriebssystem-Layer, Anwendung und Abhängigkeiten.\n- **Container**: Laufende Instanz eines Images. Kann gestartet, gestoppt, gelöscht werden.\n- **Dockerfile**: Textdatei mit Anweisungen zum Erstellen eines Images.\n- **Registry**: Speicherort für Images (Docker Hub = öffentlich, eigene Registry = privat).\n- **Volume**: Persistenter Speicher, der Container-Lebenszeit übersteht.\n\n**Vergleich VM vs. Container:**\n| Merkmal | VM | Container |\n|---|---|---|\n| Start-Zeit | Minuten | Sekunden |\n| Größe | GB (ganzes OS) | MB (nur App + Deps) |\n| Isolation | Vollständig (eigener Kernel) | Prozess-Level (geteilter Kernel) |\n| Portabilität | Gut | Sehr gut |\n| Overhead | Hoch | Gering |\n\n**Wann was?** VMs für maximale Isolation und verschiedene Betriebssysteme. Container für schnelle Deployments, Microservices, DevOps-Workflows."
      }
    ],
    "summary": "Hypervisor Typ 1 (ESXi) läuft direkt auf Hardware für maximale Performance; Typ 2 (VirtualBox) läuft auf einem Hostbetriebssystem; Container (Docker) sind leichtgewichtiger als VMs und teilen den Host-Kernel."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 9 — Netzwerke und Dienste bereitstellen' AND track = 'umschulung'),
  'Quiz: DNS, DHCP und Virtualisierung',
  'quiz',
  $json${
    "question": "Ein Mitarbeiter fragt: 'Wie viele E-Mail-Server hat unsere Domain?' Welcher DNS-Record-Typ gibt darüber Auskunft, und wie heißt der Prozessschritt bei DHCP, in dem der Client ein Angebot vom Server bestätigt?",
    "options": [
      "CNAME-Record; der Schritt heißt 'Offer'",
      "MX-Record; der Schritt heißt 'Request'",
      "A-Record; der Schritt heißt 'Acknowledge'",
      "TXT-Record; der Schritt heißt 'Discover'"
    ],
    "correct_index": 1,
    "explanation": "MX-Records (Mail Exchange) geben an, welche Mailserver für eine Domain zuständig sind (und ihre Priorität). Im DORA-Prozess sendet der Client nach einem Offer (Angebot des Servers) ein 'Request' um das Angebot zu akzeptieren — der Server bestätigt dann mit 'Acknowledge'. Die Reihenfolge ist: Discover → Offer → Request → Acknowledge."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 10a — Benutzerschnittstellen gestalten
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 10a — Benutzerschnittstellen gestalten' AND track = 'umschulung'),
  'UI/UX-Grundlagen und Usability',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Nielsens 10 Usability-Heuristiken",
        "content": "Jakob Nielsen definierte 10 allgemeine Prinzipien für gutes Interface-Design:\n\n1. **Sichtbarkeit des Systemstatus**: Das System informiert den Nutzer über seinen aktuellen Zustand (z.B. Fortschrittsbalken, Ladeanzeigen)\n2. **Übereinstimmung mit der realen Welt**: Sprache, Konzepte und Metaphern aus der Welt des Nutzers verwenden (kein IT-Jargon für Laien)\n3. **Benutzerkontrolle und -freiheit**: Aktionen rückgängig machen können, klarer Ausstieg aus Prozessen\n4. **Konsistenz und Standards**: Gleiche Dinge sehen gleich aus und funktionieren gleich (interne Konsistenz) + Einhaltung von Plattform-Konventionen (externe Konsistenz)\n5. **Fehlervermeidung**: Probleme verhindern, bevor sie entstehen (Bestätigungsdialoge, klare Eingabeformate)\n6. **Wiedererkennung statt Erinnerung**: Optionen sichtbar machen, nicht im Gedächtnis behalten lassen müssen\n7. **Flexibilität und Effizienz**: Shortcuts für erfahrene Nutzer (Tastaturkürzel, Makros)\n8. **Ästhetisches und minimalistisches Design**: Keine irrelevanten Informationen — jede Extra-Information konkurriert um Aufmerksamkeit\n9. **Hilfe beim Erkennen, Verstehen und Beheben von Fehlern**: Klare, verständliche Fehlermeldungen (kein \"Error 0x8007045D\")\n10. **Hilfe und Dokumentation**: Gut durchsuchbare Hilfe, aufgabenorientiert, mit konkreten Schritten"
      },
      {
        "heading": "Gestaltgesetze, Responsive Design und Barrierefreiheit",
        "content": "**Gestaltgesetze (Gestaltpsychologie):**\n- **Gesetz der Nähe**: Elemente, die nah beieinander liegen, werden als zusammengehörig wahrgenommen\n- **Gesetz der Ähnlichkeit**: Ähnlich aussehende Elemente werden gruppiert (gleiche Farbe = gleiche Funktion)\n- **Gesetz der Kontinuität**: Das Auge folgt Linien und Kurven\n- **Gesetz der Geschlossenheit**: Unvollständige Formen werden als vollständig wahrgenommen\n\n**Responsive Design Prinzipien:**\n- **Mobile First**: Design beginnt für kleine Bildschirme, wird dann für größere erweitert\n- **Fluid Grids**: Prozentuale statt fixe Breiten\n- **Flexible Images**: max-width: 100% verhindert Überlauf\n- **Media Queries**: CSS-Regeln für bestimmte Bildschirmbreiten\n- **Breakpoints**: Typisch 320px (Mobile), 768px (Tablet), 1024px (Desktop), 1440px (Wide)\n\n**WCAG 2.1 Barrierefreiheit:**\n- **Stufe A**: Minimum (z.B. Alt-Texte für Bilder, keine reine Farb-Information)\n- **Stufe AA**: Standard (Kontrastverhältnis min. 4,5:1 für Text, Tastaturzugänglichkeit) — gesetzliche Pflicht für öffentliche Stellen in Deutschland\n- **Stufe AAA**: Ideal (Kontrast 7:1, Gebärdensprache für Videos)"
      }
    ],
    "summary": "Nielsens 10 Heuristiken sind Grundlage guter Usability; Gestaltgesetze beschreiben, wie Menschen visuelle Gruppen wahrnehmen; WCAG 2.1 Stufe AA ist der gesetzliche Standard für Barrierefreiheit in Deutschland."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 10a — Benutzerschnittstellen gestalten' AND track = 'umschulung'),
  'Wireframes und Prototyping',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Wireframe, Mockup und Prototyp",
        "content": "Im UI/UX-Designprozess gibt es verschiedene Detailstufen der Darstellung:\n\n**Wireframe (Drahtgitter):**\n- Grobe Skizze der Seitenstruktur und Layout\n- Nur Struktur: Boxen, Linien, Platzhaltertext\n- Keine Farben, keine echten Bilder, keine Designdetails\n- Ziel: Schnell Layouts diskutieren, Feedback einholen\n- Tools: Balsamiq, Figma (Low-Fidelity), Stift und Papier\n\n**Mockup:**\n- Statisches, visuell ausgearbeitetes Design\n- Zeigt echte Farben, Typografie, Icons, Bilder\n- Nicht interaktiv (kein Klicken)\n- Ziel: Visuelles Erscheinungsbild abstimmen und genehmigen\n- Tools: Figma, Adobe XD, Sketch\n\n**Prototyp:**\n- Interaktives Modell mit klickbaren Bereichen\n- Simuliert den Nutzerfluss (User Flow)\n- Low-Fidelity: Einfache Klick-Verbindungen zwischen Wireframes\n- High-Fidelity: Fast wie echte Anwendung mit Animationen\n- Ziel: Usability-Tests, Stakeholder-Demos\n- Tools: Figma (Prototype Mode), InVision, Marvel"
      },
      {
        "heading": "User Stories, User Flow und A/B-Testing",
        "content": "**User Stories:**\nBeschreiben Anforderungen aus Nutzerperspektive im Format:\n*\"Als [Nutzerrolle] möchte ich [Funktion], damit [Nutzen]\"*\n\nBeispiel: \"Als Azubi möchte ich meinen Lernfortschritt in einem Dashboard sehen, damit ich weiß, welche Themen ich noch üben muss.\"\n\n**Akzeptanzkriterien** definieren, wann eine User Story als erfüllt gilt:\n- Das Dashboard zeigt den Prozentsatz abgeschlossener Lektionen pro Thema\n- Der Fortschritt wird nach jeder abgeschlossenen Lektion sofort aktualisiert\n\n**User Flow Diagramm:**\nVisualisiert, wie ein Nutzer durch die Anwendung navigiert, um ein Ziel zu erreichen.\n- Start: Nutzer öffnet App\n- Entscheidungsknoten (Raute): Eingeloggt? Ja → Dashboard, Nein → Login\n- Aktionen (Rechteck): Thema auswählen, Lektion starten\n- Ende: Ziel erreicht (Lektion abgeschlossen)\n\n**A/B-Testing:**\nZwei Versionen einer Seite (A und B) werden gleichzeitig an verschiedene Nutzergruppen ausgeliefert. Gemessen wird, welche Version besser performt (höhere Klickrate, mehr Konversionen). Wichtig: Immer nur eine Variable gleichzeitig ändern!"
      }
    ],
    "summary": "Wireframe (Struktur) → Mockup (visuelles Design) → Prototyp (interaktiv) sind die Stufen des UI-Designprozesses; User Stories beschreiben Anforderungen aus Nutzersicht; A/B-Testing vergleicht zwei Varianten mit echten Nutzern."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 10a — Benutzerschnittstellen gestalten' AND track = 'umschulung'),
  'Quiz: UI/UX, Usability und Barrierefreiheit',
  'quiz',
  $json${
    "question": "Eine öffentliche Behörden-Website muss nach WCAG 2.1 barrierefrei sein. Welche Konformitätsstufe ist gesetzlich vorgeschrieben, und welches Kontrastverhältnis ist dabei für normalen Text Minimum?",
    "options": [
      "Stufe A, Kontrastverhältnis mindestens 3:1",
      "Stufe AA, Kontrastverhältnis mindestens 4,5:1",
      "Stufe AAA, Kontrastverhältnis mindestens 7:1",
      "Stufe A, Kontrastverhältnis mindestens 4,5:1"
    ],
    "correct_index": 1,
    "explanation": "Für öffentliche Stellen in Deutschland ist WCAG 2.1 Stufe AA gesetzlich vorgeschrieben (Barrierefreiheitsstärkungsgesetz / BITV 2.0). Stufe AA verlangt ein Kontrastverhältnis von mindestens 4,5:1 für normalen Text (unter 18pt) und 3:1 für großen Text (ab 18pt oder 14pt fett). Stufe AAA (Kontrast 7:1) ist der höchste Standard, aber nicht gesetzlich Pflicht."
  }$json$,
  10,
  3
);

-- ============================================================
-- LF 11a — Funktionalität in Anwendungen realisieren
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 11a — Funktionalität in Anwendungen realisieren' AND track = 'umschulung'),
  'Objektorientierte Programmierung vertieft',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Die vier OOP-Prinzipien",
        "content": "**1. Kapselung (Encapsulation):**\nDaten und Methoden werden in einer Klasse zusammengefasst. Interne Details werden verborgen (private Attribute), nur definierte Schnittstellen sind zugänglich (public Methoden / Getter-Setter).\n\n```python\nclass Bankkonto:\n    def __init__(self, kontonummer):\n        self.__kontonummer = kontonummer  # privat (doppelter Unterstrich)\n        self.__kontostand = 0.0\n    \n    def einzahlen(self, betrag):  # public\n        if betrag > 0:\n            self.__kontostand += betrag\n    \n    def get_kontostand(self):  # Getter\n        return self.__kontostand\n```\n\n**2. Vererbung (Inheritance):**\nEine Klasse (Unterklasse/Kindklasse) erbt Attribute und Methoden einer anderen Klasse (Oberklasse/Elternklasse) und kann diese erweitern oder überschreiben.\n\n```python\nclass Tier:\n    def __init__(self, name):\n        self.name = name\n    \n    def sprechen(self):\n        return \"...\"\n\nclass Hund(Tier):  # erbt von Tier\n    def sprechen(self):  # Methode überschreiben\n        return \"Wuff!\"\n\nclass Katze(Tier):\n    def sprechen(self):\n        return \"Miau!\"\n```\n\n**3. Polymorphismus (Polymorphism):**\nObjekte verschiedener Klassen können über dieselbe Schnittstelle angesprochen werden. Gleicher Methodenname, unterschiedliches Verhalten.\n\n```python\ntiere = [Hund(\"Rex\"), Katze(\"Mimi\"), Hund(\"Bello\")]\nfor tier in tiere:\n    print(tier.sprechen())  # Wuff! / Miau! / Wuff!\n```\n\n**4. Abstraktion (Abstraction):**\nKomplexität verbergen, nur das Wesentliche zeigen. Abstrakte Klassen definieren eine Schnittstelle, die Unterklassen implementieren müssen. In Python mit `abc`-Modul."
      },
      {
        "heading": "Design Patterns: Singleton, Factory und Observer",
        "content": "Design Patterns sind bewährte Lösungsschablonen für häufig auftretende Entwurfsprobleme.\n\n**Singleton:**\n- Stellt sicher, dass von einer Klasse nur eine einzige Instanz existiert\n- Bietet globalen Zugriffspunkt auf diese Instanz\n- Einsatz: Datenbankverbindung, Logger, Konfigurationsobjekt\n- Problem: Schwer testbar, kann globalen Zustand einführen\n\n**Factory (Fabrikmethode):**\n- Kapselt die Objekterstellung in einer Methode/Klasse\n- Der Aufrufer weiß nicht, welche konkrete Klasse instanziiert wird\n- Einsatz: Wenn die zu erstellende Klasse erst zur Laufzeit bekannt ist\n- Beispiel: `TierFactory.erstelle('hund')` gibt Hund-Objekt zurück, ohne dass Aufrufer `Hund()` kennen muss\n\n**Observer (Beobachter):**\n- Ein Objekt (Subject) informiert automatisch alle registrierten Objekte (Observer) bei Zustandsänderungen\n- Lose Kopplung zwischen Subject und Observer\n- Einsatz: Event-Systeme, GUI-Frameworks, Publish/Subscribe\n- Beispiel: Aktienhandel-App — bei Kursänderung werden alle registrierten Anzeigen automatisch aktualisiert"
      }
    ],
    "summary": "Die vier OOP-Prinzipien sind Kapselung, Vererbung, Polymorphismus und Abstraktion; Design Patterns wie Singleton (eine Instanz), Factory (Objekterstellung kapseln) und Observer (automatische Benachrichtigung) lösen typische Entwurfsprobleme."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 11a — Funktionalität in Anwendungen realisieren' AND track = 'umschulung'),
  'Quiz: OOP-Konzepte',
  'quiz',
  $json${
    "question": "Eine Methode 'berechne_flaeche()' existiert in den Klassen 'Kreis', 'Rechteck' und 'Dreieck', gibt aber für jede Klasse unterschiedliche Ergebnisse zurück. Welches OOP-Prinzip wird hier demonstriert?",
    "options": [
      "Kapselung — weil die interne Berechnung verborgen ist",
      "Vererbung — weil alle drei Klassen von einer Basisklasse erben",
      "Polymorphismus — weil gleicher Methodenname, aber unterschiedliches Verhalten",
      "Abstraktion — weil die Klassen nur das Wesentliche zeigen"
    ],
    "correct_index": 2,
    "explanation": "Polymorphismus bedeutet 'viele Formen' — derselbe Methodenname ('berechne_flaeche()') zeigt je nach Objekt-Typ unterschiedliches Verhalten. Ein Code wie 'for form in formen: form.berechne_flaeche()' funktioniert für alle Formen, ohne den konkreten Typ zu kennen. Dies ist ein Kernvorteil von OOP: Code wird flexibel und erweiterbar."
  }$json$,
  10,
  2
);
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 11a — Funktionalität in Anwendungen realisieren' AND track = 'umschulung'),
  'Python: Klassenvererbung implementieren',
  'code',
  $json${
    "instructions": "Erstelle eine Klasse 'Fahrzeug' mit den Attributen 'marke' (String) und 'geschwindigkeit' (Integer). Implementiere eine Methode 'beschreiben()', die ausgibt: 'Fahrzeug: BMW, max. 250 km/h'\n\nErstelle dann eine Unterklasse 'PKW', die von 'Fahrzeug' erbt und das zusätzliche Attribut 'sitzplaetze' (Integer) hat. Überschreibe 'beschreiben()' so, dass ausgegeben wird: 'PKW: BMW, max. 250 km/h, 5 Sitzplätze'\n\nErstelle ein PKW-Objekt mit marke='BMW', geschwindigkeit=250, sitzplaetze=5 und rufe beschreiben() auf.",
    "starter_code": "# Dein Code hier:\n",
    "expected_output": "Fahrzeug: BMW, max. 250 km/h\nPKW: BMW, max. 250 km/h, 5 Sitzplätze\n",
    "hints": [
      "Definiere die Basisklasse Fahrzeug mit __init__(self, marke, geschwindigkeit) und einer Methode beschreiben(self)",
      "Definiere PKW(Fahrzeug): — die Klammern zeigen die Vererbung an. Nutze super().__init__(marke, geschwindigkeit) im __init__ der Unterklasse",
      "Erstelle ein PKW-Objekt: auto = PKW('BMW', 250, 5) und rufe auto.beschreiben() auf. Beachte: beschreiben() soll BEIDE Ausgaben erzeugen — erst die der Elternklasse via super().beschreiben(), dann die zusätzliche Info"
    ],
    "solution": "class Fahrzeug:\n    def __init__(self, marke, geschwindigkeit):\n        self.marke = marke\n        self.geschwindigkeit = geschwindigkeit\n    \n    def beschreiben(self):\n        print(f\"Fahrzeug: {self.marke}, max. {self.geschwindigkeit} km/h\")\n\nclass PKW(Fahrzeug):\n    def __init__(self, marke, geschwindigkeit, sitzplaetze):\n        super().__init__(marke, geschwindigkeit)\n        self.sitzplaetze = sitzplaetze\n    \n    def beschreiben(self):\n        super().beschreiben()\n        print(f\"PKW: {self.marke}, max. {self.geschwindigkeit} km/h, {self.sitzplaetze} Sitzplätze\")\n\nauto = PKW('BMW', 250, 5)\nauto.beschreiben()"
  }$json$,
  20,
  3,
  'python'
);

-- ============================================================
-- LF 12a — Kundenspezifische Anwendungsentwicklung
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'LF 12a — Kundenspezifische Anwendungsentwicklung' AND track = 'umschulung'),
  'Lastenheft, Pflichtenheft und Anforderungsanalyse',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Lastenheft vs. Pflichtenheft",
        "content": "**Lastenheft (WAS soll gemacht werden?):**\n- Verfasst vom **Auftraggeber** (Kunde)\n- Beschreibt die Anforderungen und Ziele aus Kundenperspektive\n- Antwortet auf: Was soll das System leisten? Welche Ziele sollen erreicht werden?\n- Technisch grob — der Auftraggeber muss kein IT-Experte sein\n- Beispiel-Inhalt: \"Das System soll Bestellungen erfassen und den Lagerbestand automatisch aktualisieren.\"\n\n**Pflichtenheft (WIE wird es umgesetzt?):**\n- Verfasst vom **Auftragnehmer** (IT-Dienstleister)\n- Konkretisiert das Lastenheft in technische Spezifikationen\n- Antwortet auf: Wie wird die Anforderung technisch realisiert? Welche Technologien, Architekturen, Schnittstellen?\n- Rechtlich bindend — Basis für die Abnahme\n- Beispiel-Inhalt: \"Eine REST-API (FastAPI, Python) empfängt POST-Anfragen auf /api/bestellungen. Die Datenbank (PostgreSQL) wird via SQLAlchemy aktualisiert. Ladezeit < 2 Sekunden.\"\n\n**Zusammenfassung:**\n| | Lastenheft | Pflichtenheft |\n|---|---|---|\n| Autor | Auftraggeber | Auftragnehmer |\n| Frage | WAS? | WIE? |\n| Technisch | Grob | Präzise |\n| Zeitpunkt | Vor Angebotserstellung | Nach Auftragsvergabe |"
      },
      {
        "heading": "Anforderungsarten und Use-Case-Diagramme",
        "content": "**Funktionale Anforderungen:**\nWas das System konkret tun soll — messbare, testbare Funktionen.\n- \"Der Nutzer kann sich mit E-Mail und Passwort anmelden.\"\n- \"Das System schickt eine Bestätigungs-E-Mail nach jeder Bestellung.\"\n- \"Suchergebnisse werden innerhalb von 2 Sekunden angezeigt.\"\n\n**Nicht-funktionale Anforderungen (Qualitätsanforderungen):**\nWie gut das System etwas tun soll — Qualitätskriterien.\n- **Performance**: Antwortzeit < 500ms unter Normallast\n- **Verfügbarkeit**: 99,9% Uptime (max. 8,76 Stunden Ausfall/Jahr)\n- **Sicherheit**: Alle Passwörter mit bcrypt gehasht\n- **Skalierbarkeit**: System muss 10.000 gleichzeitige Nutzer unterstützen\n- **Wartbarkeit**: Code muss Unit-Tests mit min. 80% Coverage haben\n- **Usability**: System muss von ungeschulten Nutzern ohne Handbuch bedient werden können\n\n**Use-Case-Diagramm (Anwendungsfalldiagramm):**\n- Zeigt, welche Akteure (Rollen) welche Funktionen des Systems nutzen\n- **Akteur** (Strichmännchen): Person oder externes System\n- **Use Case** (Ellipse): Eine Funktion aus Nutzersicht\n- **System-Grenze** (Rechteck): Trennt intern (Use Cases) von extern (Akteure)\n- Beziehungen: <<include>> (immer enthalten), <<extend>> (optional erweitert)"
      }
    ],
    "summary": "Das Lastenheft (WAS, vom Auftraggeber) beschreibt Anforderungen grob; das Pflichtenheft (WIE, vom Auftragnehmer) konkretisiert technisch; funktionale Anforderungen beschreiben Funktionen, nicht-funktionale beschreiben Qualitätskriterien."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 12a — Kundenspezifische Anwendungsentwicklung' AND track = 'umschulung'),
  'Projektmanagement: Scrum und Kanban',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Scrum: Rollen, Events und Artefakte",
        "content": "**Scrum** ist ein agiles Framework für die Softwareentwicklung in iterativen Zyklen (Sprints).\n\n**Die drei Scrum-Rollen:**\n- **Product Owner (PO)**: Verantwortet das Produkt-Backlog (priorisierte Liste aller Anforderungen). Repräsentiert die Interessen des Kunden. Entscheidet, was entwickelt wird.\n- **Scrum Master (SM)**: Moderiert den Scrum-Prozess, schützt das Team vor Störungen, beseitigt Hindernisse (Impediments). Kein Vorgesetzter!\n- **Entwicklungsteam (Dev Team)**: Selbstorganisierend, cross-funktional (Design, Entwicklung, Test). Typisch 3-9 Personen.\n\n**Die fünf Scrum-Events:**\n1. **Sprint**: Herzstück von Scrum. Fester Zeitraum (1-4 Wochen, typisch 2 Wochen) zur Entwicklung eines potenziell auslieferbaren Produktinkrements.\n2. **Sprint Planning**: Zu Beginn jedes Sprints — was wird im Sprint umgesetzt? (Sprint-Backlog wird erstellt)\n3. **Daily Scrum**: Täglich, 15 Minuten — Was habe ich gestern gemacht? Was mache ich heute? Was blockiert mich?\n4. **Sprint Review**: Am Ende des Sprints — Demo der fertigen Features vor Stakeholdern, Feedback einholen\n5. **Sprint Retrospective**: Rückblick auf den Prozess — Was lief gut? Was schlecht? Was verbessern wir?"
      },
      {
        "heading": "Kanban und Vergleich Scrum vs. Kanban",
        "content": "**Kanban** ist ein visuelles Workflow-Management-System aus der japanischen Lean-Produktion (Toyota).\n\n**Kanban-Board:**\nAufgaben (Karten) werden durch Spalten bewegt:\n```\n| Backlog | To Do | In Progress | Review | Done |\n|---------|-------|-------------|--------|------|\n| Aufg. 5 | Aufg3 | Aufg. 1     | Aufg.2 | Aufg.4 |\n```\n\n**WIP-Limits (Work in Progress):**\nKanban begrenzt, wie viele Aufgaben gleichzeitig in einer Spalte sein dürfen. Verhindert Multitasking und macht Engpässe sichtbar.\nBeispiel: \"In Progress\" max. 3 Karten — bei 3 Karten muss erst eine fertig werden, bevor neue starten.\n\n**Scrum vs. Kanban Vergleich:**\n| Merkmal | Scrum | Kanban |\n|---|---|---|\n| Iterationen | Feste Sprints (1-4 Wochen) | Kontinuierlicher Fluss |\n| Rollen | Product Owner, Scrum Master, Dev Team | Keine vorgeschriebenen Rollen |\n| Planung | Sprint Planning, feste Kapazität | Nach Kapazität, kontinuierlich |\n| Änderungen | Während Sprint nicht erlaubt | Jederzeit möglich |\n| Metriken | Velocity (Punkte/Sprint) | Cycle Time, Throughput |\n| Einsatz | Neue Produktentwicklung | Support, Operations, laufende Wartung |"
      }
    ],
    "summary": "Scrum strukturiert Entwicklung in Sprints mit drei Rollen (PO, SM, Dev Team) und fünf Events; Kanban nutzt ein visuelles Board mit WIP-Limits für kontinuierlichen Fluss; Scrum eignet sich für neue Entwicklung, Kanban für Support und Operations."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'LF 12a — Kundenspezifische Anwendungsentwicklung' AND track = 'umschulung'),
  'Quiz: Anforderungen und Projektmanagement',
  'quiz',
  $json${
    "question": "Ein Kunde sagt: 'Das neue System muss alle Bestellungen aus unserem Shop erfassen und den Lagerbestand aktualisieren.' Wer schreibt diesen Text auf, in welches Dokument gehört er, und welche Art von Anforderung ist das?",
    "options": [
      "Auftragnehmer schreibt es ins Pflichtenheft; es ist eine nicht-funktionale Anforderung",
      "Auftraggeber schreibt es ins Lastenheft; es ist eine funktionale Anforderung",
      "Scrum Master schreibt es ins Sprint-Backlog; es ist eine User Story",
      "Auftraggeber schreibt es ins Pflichtenheft; es ist eine technische Anforderung"
    ],
    "correct_index": 1,
    "explanation": "Das Lastenheft wird vom Auftraggeber (Kunden) verfasst und beschreibt, WAS das System leisten soll — in diesem Fall die Erfassung von Bestellungen und Lagerbestandsaktualisierung. Das ist eine funktionale Anforderung, da sie eine konkrete Funktion des Systems beschreibt. Das Pflichtenheft würde dann vom Auftragnehmer spezifizieren, WIE diese Funktion technisch umgesetzt wird."
  }$json$,
  10,
  3
);

-- ============================================================
-- WiSo — Wirtschafts- und Sozialkunde
-- ============================================================
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  (SELECT id FROM public.topics WHERE title = 'WiSo — Wirtschafts- und Sozialkunde' AND track = 'umschulung'),
  'Berufsausbildung und Arbeitsrecht',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Berufsausbildungsvertrag und Pflichten",
        "content": "Die Berufsausbildung in Deutschland ist dual: Betrieb (praktische Ausbildung) + Berufsschule (theoretische Ausbildung).\n\n**Berufsausbildungsvertrag (BBiG § 10):**\nMuss vor Beginn der Ausbildung schriftlich abgeschlossen werden. Pflichtangaben:\n- Beginn und Dauer der Ausbildung\n- Ausbildungsberuf und Ausbildungsrahmenplan\n- Probezeit (mindestens 1 Monat, maximal 4 Monate)\n- Ausbildungsvergütung (muss angemessen sein; Mindestausbildungsvergütung seit 2020 gesetzlich geregelt)\n- Arbeitszeit\n- Urlaub (mindestens 24 Werktage, für unter 18-Jährige nach JArbSchG mehr)\n\n**Pflichten des Auszubildenden:**\n- Lernpflicht: Berufsschule besuchen, Ausbildungsmaßnahmen teilnehmen\n- Sorgfaltspflicht: Arbeit gewissenhaft ausführen\n- Berichtsheftsführung (Ausbildungsnachweis)\n- Verschwiegenheitspflicht\n- Weisungsgebundenheit\n\n**Pflichten des Ausbildungsbetriebs:**\n- Ausbildungspflicht: Alle ausbildungsrelevanten Kenntnisse und Fähigkeiten vermitteln\n- Vergütungspflicht: Angemessene Ausbildungsvergütung zahlen\n- Freistellung für Berufsschule und Prüfungen\n- Zeugnis am Ende der Ausbildung ausstellen\n- Mittel und Geräte zur Verfügung stellen\n\n**Probezeit:**\n- 1 bis 4 Monate (vertraglich vereinbart)\n- Während Probezeit: Kündigung jederzeit ohne Frist und ohne Angabe von Gründen möglich (beide Seiten)"
      },
      {
        "heading": "Kündigung, Kündigungsschutz und Arbeitszeugnis",
        "content": "**Kündigung nach der Probezeit (Ausbildungsverhältnis):**\n- **Durch Auszubildenden**: Jederzeit mit 4 Wochen Frist möglich (wenn Berufswunsch aufgegeben)\n- **Durch Ausbildungsbetrieb**: Nur aus wichtigem Grund (fristlos), z.B. schwerer Pflichtverstoß, Diebstahl. Ordentliche Kündigung durch den Betrieb ist NICHT möglich!\n\n**Arbeitsverhältnis (nach Ausbildung) — Kündigungsfristen:**\nNach § 622 BGB:\n- Grundkündigung (bis 2 Jahre): 4 Wochen zum 15. oder zum Monatsende\n- Ab 2 Jahren: 1 Monat zum Monatsende\n- Ab 5 Jahren: 2 Monate zum Monatsende\n- (Staffel steigt bis 7 Monate bei 20 Jahren Betriebszugehörigkeit)\n\n**Kündigungsschutzgesetz (KSchG):**\n- Gilt ab 6 Monaten Betriebszugehörigkeit und in Betrieben mit mehr als 10 Mitarbeitern\n- Kündigung muss sozial gerechtfertigt sein: personenbedingt, verhaltensbedingt oder betriebsbedingt\n\n**Mutterschutz:**\n- 6 Wochen vor dem errechneten Geburtstermin: Beschäftigungsverbot (kann aufgehoben werden)\n- 8 Wochen nach der Geburt: Absolutes Beschäftigungsverbot\n- Kündigungsschutz ab Beginn der Schwangerschaft bis 4 Monate nach Geburt\n\n**Arbeitszeugnis:**\n- Einfaches Zeugnis: Art und Dauer der Beschäftigung\n- Qualifiziertes Zeugnis: Art, Dauer, Leistung und Verhalten — Anspruch nach § 109 GewO\n- Zeugnis muss wohlwollend formuliert sein (kein Schaden für beruflichen Werdegang)"
      }
    ],
    "summary": "Der Berufsausbildungsvertrag regelt Rechte und Pflichten beider Parteien; Kündigung durch den Betrieb nach der Probezeit ist nur aus wichtigem Grund möglich; das KSchG schützt ab 6 Monaten Betriebszugehörigkeit in Betrieben über 10 Mitarbeiter."
  }$json$,
  15,
  1
),
(
  (SELECT id FROM public.topics WHERE title = 'WiSo — Wirtschafts- und Sozialkunde' AND track = 'umschulung'),
  'Sozialversicherungssystem Deutschland',
  'theory',
  $json${
    "sections": [
      {
        "heading": "Die fünf Säulen der Sozialversicherung",
        "content": "Das deutsche Sozialversicherungssystem besteht aus fünf Pflichtversicherungen. Beiträge werden je hälftig von Arbeitgeber (AG) und Arbeitnehmer (AN) getragen (außer Unfallversicherung).\n\n| Versicherung | Abk. | Beitragssatz (ca.) | Träger | Leistung |\n|---|---|---|---|---|\n| Krankenversicherung | KV | 14,6% + Zusatzbeitrag | Krankenkassen (GKV) | Arztbesuche, Krankenhausaufenthalte |\n| Pflegeversicherung | PV | 3,4% (kinderlos: +0,6%) | Pflegekassen | Pflege bei Pflegebedürftigkeit |\n| Rentenversicherung | RV | 18,6% | Deutsche Rentenversicherung | Altersrente, Erwerbsminderungsrente |\n| Unfallversicherung | UV | Variabel (nur AG zahlt!) | Berufsgenossenschaften | Arbeitsunfälle, Berufskrankheiten |\n| Arbeitslosenversicherung | AV | 2,6% | Bundesagentur für Arbeit | Arbeitslosengeld I (60%/67% des Nettolohns, max. 24 Monate) |\n\n**Wichtig:** Bei der Unfallversicherung zahlt nur der Arbeitgeber!\n\n**Versicherungspflichtgrenze (Krankenversicherung):**\n- Liegt über einem bestimmten Jahreseinkommen (2024: 69.300 €/Jahr = 5.775 €/Monat)\n- Darunter: Pflichtmitglied in der GKV\n- Darüber: Wahl zwischen GKV (freiwillig) und PKV (Private Krankenversicherung)"
      },
      {
        "heading": "Tarifvertrag und weitere Grundlagen",
        "content": "**GKV vs. PKV:**\n| | GKV (gesetzlich) | PKV (privat) |\n|---|---|---|\n| Beitrag | Einkommensabhängig | Risikoabhängig (Alter, Gesundheit) |\n| Leistung | Einheitlicher Leistungskatalog | Individuelle Tarife, oft mehr Leistungen |\n| Familienversicherung | Kostenlose Mitversicherung möglich | Jede Person zahlt eigenen Beitrag |\n| Wechsel | Relativ flexibel | Rückkehr in GKV schwierig |\n\n**Tarifvertrag:**\nVertrag zwischen Gewerkschaft und Arbeitgeberverband (oder einzelnem Arbeitgeber). Regelt Mindestbedingungen für einen Wirtschaftszweig oder ein Unternehmen:\n- Mindestlohn (über gesetzlichem Mindestlohn)\n- Urlaubstage (über gesetzlichem Minimum)\n- Arbeitszeiten\n- Zulagen (Weihnachtsgeld, Urlaubsgeld)\n\n**Tarifvertragsgesetz (TVG):**\n- Regelt, welche Parteien Tarifverträge schließen dürfen (tariffähige Parteien)\n- Tarifverträge sind bindend für alle Mitglieder der beteiligten Verbände\n- Allgemeinverbindlicherklärung: Bundesarbeitsministerium kann Tarifvertrag auf alle Arbeitgeber einer Branche ausdehnen\n\n**Gesetzlicher Mindestlohn:**\n- Eingeführt 2015, wird regelmäßig angepasst\n- Gilt für alle Arbeitnehmer ab 18 Jahren (Ausnahmen: Auszubildende, Praktikanten unter bestimmten Bedingungen)"
      }
    ],
    "summary": "Die fünf Säulen der Sozialversicherung sind Kranken-, Pflege-, Renten-, Unfall- und Arbeitslosenversicherung; Beiträge werden hälftig geteilt (außer UV, die nur AG zahlt); Tarifverträge legen branchenspezifische Mindestbedingungen über gesetzliche Mindeststandards hinaus fest."
  }$json$,
  15,
  2
),
(
  (SELECT id FROM public.topics WHERE title = 'WiSo — Wirtschafts- und Sozialkunde' AND track = 'umschulung'),
  'Quiz: Sozialversicherung und Arbeitsrecht',
  'quiz',
  $json${
    "question": "Ein Arbeitnehmer verdient 4.000 € brutto/Monat. Wer zahlt den Beitrag zur gesetzlichen Unfallversicherung, und welche Institution ist Träger der Rentenversicherung?",
    "options": [
      "AG und AN je hälftig; Träger ist die Bundesagentur für Arbeit",
      "Nur der Arbeitgeber (AG); Träger ist die Deutsche Rentenversicherung",
      "Nur der Arbeitnehmer (AN); Träger sind die Krankenkassen",
      "AG und AN je hälftig; Träger sind die Berufsgenossenschaften"
    ],
    "correct_index": 1,
    "explanation": "Die Unfallversicherung ist die einzige Sozialversicherung, die ausschließlich vom Arbeitgeber finanziert wird — der Arbeitnehmer zahlt keinen Beitrag. Träger sind die Berufsgenossenschaften. Die Rentenversicherung hingegen wird hälftig von AG und AN getragen; ihr Träger ist die Deutsche Rentenversicherung (DRV). Die Bundesagentur für Arbeit ist Träger der Arbeitslosenversicherung."
  }$json$,
  10,
  3
);

-- IHK checklist progress table (used by /ihk-checklist route)
CREATE TABLE IF NOT EXISTS public.ihk_checklist (
    id           SERIAL PRIMARY KEY,
    user_id      UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    item_key     TEXT NOT NULL,
    completed    BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at TIMESTAMPTZ,
    UNIQUE (user_id, item_key)
);
