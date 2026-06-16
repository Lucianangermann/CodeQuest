-- Add translations column to lessons
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS translations JSONB DEFAULT '{}';

-- Theory lesson: Introduction to Variables
UPDATE lessons SET translations = '{
  "title": "Einführung in Variablen",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was ist eine Variable?\n\nEine **Variable** ist wie eine beschriftete Box, in der du Informationen speicherst. Du gibst ihr einen Namen und legst einen Wert hinein, den du später verwenden und verändern kannst.\n\nIn Python ist das Erstellen einer Variable ganz einfach — schreibe einfach den Namen, ein Gleichheitszeichen und den Wert:"},
      {"type": "code", "language": "python", "content": "# Variablen erstellen\nname = \"Alice\"\nalter = 25\ngroesse = 1.68\nist_student = True\n\n# Variablen verwenden\nprint(name)        # Alice\nprint(alter)       # 25\nprint(ist_student) # True"},
      {"type": "text", "content": "## Regeln für Variablennamen\n\nVariablen müssen diese Regeln befolgen:\n- **Beginnen** mit einem Buchstaben oder Unterstrich `_`\n- Nur Buchstaben, Zahlen und Unterstriche enthalten\n- **Groß-/Kleinschreibung** beachten (`name` ≠ `Name`)\n- Keine Python-Schlüsselwörter (`if`, `for`, `while`)\n\nBeste Praxis: Verwende `snake_case` für bessere Lesbarkeit."},
      {"type": "code", "language": "python", "content": "# Gute Variablennamen\nvorname = \"Bob\"\nbenutzer_alter = 30\ngesamt_punkte = 100\n\n# Du kannst Variablen aktualisieren\nbenutzer_alter = 31  # Herzlichen Glückwunsch!\nprint(benutzer_alter)  # 31\n\n# Mehrfachzuweisung\nx, y, z = 1, 2, 3\nprint(x, y, z)  # 1 2 3"},
      {"type": "text", "content": "## Wichtigste Punkte\n\n✅ Variablen sind benannte Behälter zum Speichern von Daten\n✅ Verwende `=` zum Zuweisen von Werten (nicht `==`)\n✅ Du kannst eine Variable jederzeit aktualisieren\n✅ Wähle beschreibende Namen für lesbaren Code"}
    ],
    "summary": "Variablen sind benannte Behälter für Daten. Verwende = zum Zuweisen von Werten und wähle beschreibende snake_case-Namen."
  }
}' WHERE title = 'Introduction to Variables';

-- Quiz: Variable Basics
UPDATE lessons SET translations = '{
  "title": "Quiz: Variablen-Grundlagen",
  "content": {
    "question": "Welche der folgenden Varianten ist die RICHTIGE Art, eine Variable `punkte` mit dem Wert 100 in Python zu erstellen?",
    "options": ["punkte = 100", "var punkte = 100", "punkte == 100", "int punkte = 100"],
    "explanation": "In Python erstellst du Variablen mit einer einfachen Zuweisung: Name = Wert. Keine Schlüsselwörter wie ''var'' oder Typdeklarationen wie ''int'' sind nötig! Der ==-Operator dient dem Vergleich, nicht der Zuweisung."
  }
}' WHERE title = 'Quiz: Variable Basics';

-- Theory: Understanding Python Data Types
UPDATE lessons SET translations = '{
  "title": "Python-Datentypen verstehen",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was sind Datentypen?\n\nJeder Wert in Python hat einen **Typ**, der bestimmt, welche Operationen möglich sind und wie der Wert gespeichert wird.\n\nDie vier grundlegenden Datentypen:\n- `int` — Ganzzahlen (42, -7, 0)\n- `float` — Dezimalzahlen (3.14, -0.5)\n- `str` — Texte (\"Hallo\", ''Welt'')\n- `bool` — Wahrheitswerte (True, False)"},
      {"type": "code", "language": "python", "content": "# Datentypen in Python\nalter = 25           # int\ngroesse = 1.75       # float\nname = \"Anna\"        # str\nist_aktiv = True     # bool\n\n# Typ prüfen\nprint(type(alter))     # <class ''int''>\nprint(type(groesse))   # <class ''float''>\nprint(type(name))      # <class ''str''>\nprint(type(ist_aktiv)) # <class ''bool''>"},
      {"type": "text", "content": "## Typumwandlung\n\nDu kannst Werte zwischen Typen umwandeln:"},
      {"type": "code", "language": "python", "content": "# Typumwandlung\nzahl_text = \"42\"\nzahl = int(zahl_text)   # str → int: 42\nfloat_zahl = float(\"3.14\")  # str → float: 3.14\ntext = str(100)          # int → str: \"100\"\n\n# Strings können addiert (verbunden) werden\nvorname = \"Max\"\nnachname = \"Mustermann\"\nvollerName = vorname + \" \" + nachname\nprint(vollerName)  # Max Mustermann"},
      {"type": "text", "content": "## Wichtigste Punkte\n\n✅ Jeder Wert in Python hat einen Typ\n✅ `type()` gibt den Typ eines Wertes zurück\n✅ Du kannst zwischen Typen umwandeln mit `int()`, `float()`, `str()`\n✅ Strings werden mit `+` verbunden"}
    ],
    "summary": "Python hat 4 Grunddatentypen: int, float, str, bool. Verwende type() um den Typ zu prüfen, und int(), float(), str() für Umwandlungen."
  }
}' WHERE title = 'Understanding Python Data Types';

-- Quiz: Data Types
UPDATE lessons SET translations = '{
  "title": "Quiz: Datentypen",
  "content": {
    "question": "Was gibt `type(3.14)` in Python zurück?",
    "options": ["<class ''float''>", "<class ''int''>", "<class ''number''>", "<class ''decimal''>"],
    "explanation": "3.14 ist eine Dezimalzahl, also ein float. Python''s type()-Funktion gibt den Klassentyp zurück: <class ''float''>."
  }
}' WHERE title = 'Data Types Quiz';

-- Theory: Making Decisions with Conditionals
UPDATE lessons SET translations = '{
  "title": "Entscheidungen mit Bedingungen treffen",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was sind Bedingungen?\n\n**Bedingungen** (if/elif/else) erlauben es deinem Code, Entscheidungen zu treffen. Wie im echten Leben: *Wenn* es regnet, nimm einen Schirm; *sonst* geh ohne.\n\nIn Python:\n```\nif Bedingung:\n    # Code wenn wahr\nelif andere_bedingung:\n    # Code wenn die andere Bedingung wahr\nelse:\n    # Code wenn alles falsch\n```"},
      {"type": "code", "language": "python", "content": "# Einfaches if/else\nalter = 18\n\nif alter >= 18:\n    print(\"Du darfst wählen!\")\nelse:\n    print(\"Du bist noch zu jung.\")\n\n# if/elif/else\npunkte = 75\n\nif punkte >= 90:\n    note = \"Sehr gut\"\nelif punkte >= 75:\n    note = \"Gut\"\nelif punkte >= 60:\n    note = \"Befriedigend\"\nelse:\n    note = \"Nicht bestanden\"\n\nprint(f\"Deine Note: {note}\")"},
      {"type": "text", "content": "## Vergleichsoperatoren\n\n| Operator | Bedeutung |\n|----------|----------|\n| `==` | Gleich |\n| `!=` | Ungleich |\n| `>` | Größer als |\n| `<` | Kleiner als |\n| `>=` | Größer oder gleich |\n| `<=` | Kleiner oder gleich |\n\nUnd logische Operatoren: `and`, `or`, `not`"},
      {"type": "code", "language": "python", "content": "# Logische Operatoren\nalter = 25\nhat_ausweis = True\n\nif alter >= 18 and hat_ausweis:\n    print(\"Zugang gewährt\")\n\n# not-Operator\nist_wochenende = False\nif not ist_wochenende:\n    print(\"Arbeitszeit!\")"}
    ],
    "summary": "if/elif/else ermöglichen Entscheidungen im Code. Vergleichsoperatoren (==, !=, >, <) und logische Operatoren (and, or, not) helfen dabei."
  }
}' WHERE title = 'Making Decisions with Conditionals';

-- Quiz: Conditionals
UPDATE lessons SET translations = '{
  "title": "Quiz: Bedingungen",
  "content": {
    "question": "Was gibt dieser Code aus?\n```python\nx = 10\nif x > 5:\n    print(\"Groß\")\nelse:\n    print(\"Klein\")\n```",
    "options": ["Groß", "Klein", "10", "Fehler"],
    "explanation": "Da x = 10 und 10 > 5 wahr ist, wird der if-Block ausgeführt und ''Groß'' ausgegeben."
  }
}' WHERE title = 'Conditionals Quiz';

-- Theory: Repeating Actions with Loops
UPDATE lessons SET translations = '{
  "title": "Aktionen mit Schleifen wiederholen",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was sind Schleifen?\n\n**Schleifen** wiederholen Code mehrfach. Statt denselben Code 100 Mal zu schreiben, sagst du Python: \"Führe das 100 Mal aus.\"\n\nPython hat zwei Schleifentypen:\n- `for` — für eine bekannte Anzahl von Wiederholungen\n- `while` — solange eine Bedingung wahr ist"},
      {"type": "code", "language": "python", "content": "# for-Schleife\nfor i in range(5):\n    print(f\"Durchgang {i}\")\n# Ausgabe: Durchgang 0, 1, 2, 3, 4\n\n# Über eine Liste iterieren\nfrüchte = [\"Apfel\", \"Banane\", \"Kirsche\"]\nfor frucht in früchte:\n    print(f\"Ich mag {frucht}\")\n\n# while-Schleife\nzähler = 0\nwhile zähler < 3:\n    print(f\"Zähler: {zähler}\")\n    zähler += 1"},
      {"type": "text", "content": "## Schleifensteuerung\n\n- `break` — Schleife sofort beenden\n- `continue` — aktuelle Iteration überspringen\n- `range(start, stop, step)` — Zahlenfolge erzeugen"},
      {"type": "code", "language": "python", "content": "# break und continue\nfor i in range(10):\n    if i == 3:\n        continue  # 3 überspringen\n    if i == 7:\n        break     # bei 7 aufhören\n    print(i)  # Ausgabe: 0 1 2 4 5 6\n\n# range mit Schrittweite\nfor i in range(0, 10, 2):\n    print(i)  # 0 2 4 6 8"}
    ],
    "summary": "for-Schleifen iterieren über Sequenzen oder range(). while-Schleifen laufen bis eine Bedingung falsch wird. break beendet die Schleife, continue überspringt eine Iteration."
  }
}' WHERE title = 'Repeating Actions with Loops';

-- Quiz: Loops
UPDATE lessons SET translations = '{
  "title": "Quiz: Schleifen",
  "content": {
    "question": "Was gibt `range(2, 8, 2)` aus?",
    "options": ["2, 4, 6", "2, 4, 6, 8", "0, 2, 4, 6, 8", "2, 3, 4, 5, 6, 7"],
    "explanation": "range(start, stop, step) erzeugt Zahlen von start bis (nicht einschließlich) stop mit der angegebenen Schrittweite. Also: 2, 4, 6 (8 ist nicht enthalten, da stop-Wert exklusiv)."
  }
}' WHERE title = 'Loops Quiz';

-- Theory: Writing Reusable Code with Functions
UPDATE lessons SET translations = '{
  "title": "Wiederverwendbaren Code mit Funktionen schreiben",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was sind Funktionen?\n\n**Funktionen** sind benannte Codeblöcke, die eine bestimmte Aufgabe ausführen. Sie vermeiden Wiederholungen und machen deinen Code organisierter und leichter testbar.\n\nDef-Syntax:\n```python\ndef funktionsname(parameter):\n    # Code hier\n    return ergebnis\n```"},
      {"type": "code", "language": "python", "content": "# Einfache Funktion\ndef begrüße(name):\n    return f\"Hallo, {name}!\"\n\nprint(begrüße(\"Anna\"))   # Hallo, Anna!\nprint(begrüße(\"Max\"))    # Hallo, Max!\n\n# Funktion mit mehreren Parametern\ndef addiere(a, b):\n    return a + b\n\nergebnis = addiere(3, 5)\nprint(ergebnis)  # 8"},
      {"type": "text", "content": "## Standardwerte und Rückgabewerte\n\nFunktionen können Standardwerte für Parameter haben:"},
      {"type": "code", "language": "python", "content": "# Standardwerte\ndef potenz(basis, exponent=2):\n    return basis ** exponent\n\nprint(potenz(3))    # 9 (3²)\nprint(potenz(3, 3)) # 27 (3³)\n\n# Mehrere Rückgabewerte\ndef min_max(zahlen):\n    return min(zahlen), max(zahlen)\n\nkleinste, größte = min_max([3, 1, 4, 1, 5])\nprint(kleinste, größte)  # 1 5"}
    ],
    "summary": "Funktionen sind wiederverwendbare Codeblöcke mit def. Sie nehmen Parameter entgegen und geben mit return Werte zurück. Standardwerte machen Parameter optional."
  }
}' WHERE title = 'Writing Reusable Code with Functions';

-- Quiz: Functions
UPDATE lessons SET translations = '{
  "title": "Quiz: Funktionen",
  "content": {
    "question": "Was gibt folgende Funktion zurück?\n```python\ndef verdopple(x):\n    return x * 2\n\nprint(verdopple(5))\n```",
    "options": ["10", "5", "25", "None"],
    "explanation": "Die Funktion gibt x * 2 zurück. Mit x = 5 ergibt das 5 * 2 = 10."
  }
}' WHERE title = 'Functions Quiz';

-- Theory: Working with Python Lists
UPDATE lessons SET translations = '{
  "title": "Mit Python-Listen arbeiten",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was sind Listen?\n\n**Listen** speichern mehrere Werte in einer geordneten Sammlung. Du kannst verschiedene Datentypen mischen und Elemente hinzufügen, entfernen oder ändern.\n\n```python\nmeine_liste = [element1, element2, element3]\n```"},
      {"type": "code", "language": "python", "content": "# Listen erstellen\nzahlen = [1, 2, 3, 4, 5]\nfrüchte = [\"Apfel\", \"Banane\", \"Kirsche\"]\ngemischt = [1, \"Hallo\", True, 3.14]\n\n# Auf Elemente zugreifen (Index beginnt bei 0)\nprint(früchte[0])   # Apfel\nprint(früchte[-1])  # Kirsche (letztes Element)\n\n# Teilbereiche (Slicing)\nprint(zahlen[1:4])  # [2, 3, 4]"},
      {"type": "text", "content": "## Wichtige Listenmethoden"},
      {"type": "code", "language": "python", "content": "früchte = [\"Apfel\", \"Banane\"]\n\n# Elemente hinzufügen\nfrüchte.append(\"Kirsche\")      # am Ende\nfrüchte.insert(1, \"Mango\")     # an Position 1\n\n# Elemente entfernen\nfrüchte.remove(\"Banane\")       # nach Wert\nentfernt = früchte.pop()       # letztes Element\n\n# Nützliche Operationen\nprint(len(früchte))            # Anzahl Elemente\nfrüchte.sort()                 # sortieren\nfrüchte.reverse()              # umkehren\nprint(\"Apfel\" in früchte)      # True/False"}
    ],
    "summary": "Listen speichern geordnete Sammlungen von Werten. Zugriff per Index (ab 0), Slicing für Teilbereiche. append(), remove(), pop() für Änderungen."
  }
}' WHERE title = 'Working with Python Lists';

-- Quiz: Lists
UPDATE lessons SET translations = '{
  "title": "Quiz: Listen",
  "content": {
    "question": "Welche Methode fügt ein Element ans ENDE einer Liste hinzu?",
    "options": ["append()", "insert()", "add()", "push()"],
    "explanation": "append() fügt ein Element an das Ende einer Liste hinzu. insert(index, wert) fügt an einer bestimmten Position ein. add() und push() gibt es für Listen nicht."
  }
}' WHERE title = 'Lists Quiz';

-- Theory: Dictionaries
UPDATE lessons SET translations = '{
  "title": "Schlüssel-Wert-Daten mit Dictionaries speichern",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was sind Dictionaries?\n\n**Dictionaries** (Wörterbücher) speichern Daten als **Schlüssel-Wert-Paare**. Wie ein echtes Wörterbuch: Schlage den Schlüssel nach, um den Wert zu finden.\n\n```python\nmein_dict = {\"schlüssel\": wert}\n```"},
      {"type": "code", "language": "python", "content": "# Dictionary erstellen\nperson = {\n    \"name\": \"Alice\",\n    \"alter\": 30,\n    \"beruf\": \"Entwicklerin\"\n}\n\n# Auf Werte zugreifen\nprint(person[\"name\"])         # Alice\nprint(person.get(\"alter\"))    # 30\n\n# Werte hinzufügen/ändern\nperson[\"stadt\"] = \"Berlin\"\nperson[\"alter\"] = 31\n\n# Alle Schlüssel/Werte\nprint(list(person.keys()))    # [''name'', ''alter'', ...]\nprint(list(person.values()))  # [''Alice'', 31, ...]"},
      {"type": "text", "content": "## Dictionaries durchsuchen"},
      {"type": "code", "language": "python", "content": "# Über Dictionary iterieren\nprodukte = {\"Apfel\": 0.99, \"Banane\": 0.49, \"Kirsche\": 2.99}\n\nfor produkt, preis in produkte.items():\n    print(f\"{produkt}: {preis}€\")\n\n# Schlüssel prüfen\nif \"Banane\" in produkte:\n    print(\"Banane ist verfügbar\")\n\n# Eintrag entfernen\ndel produkte[\"Apfel\"]"}
    ],
    "summary": "Dictionaries speichern Schlüssel-Wert-Paare mit geschwungenen Klammern {}. Zugriff über dict[schlüssel] oder .get(). keys(), values(), items() für Iteration."
  }
}' WHERE title = 'Storing Key-Value Data with Dictionaries';

-- Quiz: Dictionaries
UPDATE lessons SET translations = '{
  "title": "Quiz: Dictionaries",
  "content": {
    "question": "Wie greifst du auf den Wert ''Alice'' in diesem Dictionary zu?\n```python\nperson = {\"name\": \"Alice\", \"alter\": 30}\n```",
    "options": ["person[\"name\"]", "person[0]", "person.name", "person.get(0)"],
    "explanation": "In Dictionaries greifst du per Schlüssel zu: person[\"name\"]. Indices wie person[0] funktionieren hier nicht — Dictionaries sind nach Schlüsseln, nicht nach Position indiziert."
  }
}' WHERE title = 'Dictionaries Quiz';

-- Theory: OOP
UPDATE lessons SET translations = '{
  "title": "Einführung in die Objektorientierte Programmierung",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was ist OOP?\n\n**Objektorientierte Programmierung** (OOP) organisiert Code in **Klassen** und **Objekten**. Eine Klasse ist wie eine Blaupause; ein Objekt ist eine konkrete Instanz davon.\n\nKernkonzepte:\n- **Klasse**: Vorlage/Blaupause\n- **Objekt**: Instanz einer Klasse\n- **Attribute**: Daten des Objekts\n- **Methoden**: Funktionen des Objekts"},
      {"type": "code", "language": "python", "content": "# Klasse definieren\nclass Hund:\n    def __init__(self, name, rasse):\n        self.name = name\n        self.rasse = rasse\n    \n    def bellen(self):\n        return f\"{self.name} sagt: Wuff!\"\n    \n    def info(self):\n        return f\"{self.name} ist ein {self.rasse}\"\n\n# Objekte erstellen\nbello = Hund(\"Bello\", \"Labrador\")\nrex = Hund(\"Rex\", \"Schäferhund\")\n\nprint(bello.bellen())  # Bello sagt: Wuff!\nprint(rex.info())      # Rex ist ein Schäferhund"},
      {"type": "text", "content": "## Vererbung\n\nKlassen können von anderen Klassen erben:"},
      {"type": "code", "language": "python", "content": "class Tier:\n    def __init__(self, name):\n        self.name = name\n    \n    def atmen(self):\n        return f\"{self.name} atmet\"\n\nclass Katze(Tier):  # erbt von Tier\n    def schnurren(self):\n        return f\"{self.name} schnurrt\"\n\nminka = Katze(\"Minka\")\nprint(minka.atmen())     # Minka atmet (von Tier geerbt)\nprint(minka.schnurren()) # Minka schnurrt"}
    ],
    "summary": "OOP organisiert Code in Klassen (Blaupausen) und Objekten (Instanzen). __init__ ist der Konstruktor, self verweist auf das Objekt. Vererbung ermöglicht Code-Wiederverwendung."
  }
}' WHERE title = 'Introduction to Object-Oriented Programming';

-- Quiz: OOP
UPDATE lessons SET translations = '{
  "title": "Quiz: OOP",
  "content": {
    "question": "Was ist `__init__` in einer Python-Klasse?",
    "options": ["Der Konstruktor, der beim Erstellen eines Objekts aufgerufen wird", "Eine Methode zum Löschen des Objekts", "Eine Klassenvariable", "Ein privates Attribut"],
    "explanation": "__init__ ist der Konstruktor einer Klasse. Er wird automatisch aufgerufen, wenn ein neues Objekt erstellt wird, und initialisiert die Attribute des Objekts."
  }
}' WHERE title = 'OOP Quiz';

-- Theory: Error Handling
UPDATE lessons SET translations = '{
  "title": "Fehler elegant behandeln",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was ist Fehlerbehandlung?\n\nFehler (Exceptions) treten auf, wenn Code auf unerwartete Situationen stößt. Gute Fehlerbehandlung verhindert, dass dein Programm abstürzt.\n\nPython verwendet `try/except`:"},
      {"type": "code", "language": "python", "content": "# Grundlegende Fehlerbehandlung\ntry:\n    zahl = int(input(\"Gib eine Zahl ein: \"))\n    ergebnis = 10 / zahl\n    print(f\"Ergebnis: {ergebnis}\")\nexcept ValueError:\n    print(\"Das ist keine gültige Zahl!\")\nexcept ZeroDivisionError:\n    print(\"Division durch Null ist nicht erlaubt!\")\nexcept Exception as e:\n    print(f\"Unbekannter Fehler: {e}\")"},
      {"type": "text", "content": "## try/except/else/finally"},
      {"type": "code", "language": "python", "content": "try:\n    datei = open(\"daten.txt\", \"r\")\n    inhalt = datei.read()\nexcept FileNotFoundError:\n    print(\"Datei nicht gefunden!\")\nelse:\n    print(f\"Inhalt: {inhalt}\")  # Nur bei Erfolg\nfinally:\n    print(\"Das wird IMMER ausgeführt\")\n    # Für Aufräumarbeiten (z.B. Dateien schließen)\n\n# Eigene Exceptions\nclass MeinFehler(Exception):\n    pass\n\nraise MeinFehler(\"Etwas ist schiefgelaufen\")"}
    ],
    "summary": "try/except fängt Fehler ab und verhindert Programmabstürze. else läuft bei Erfolg, finally immer. Eigene Exceptions können von Exception erben."
  }
}' WHERE title = 'Handling Errors Gracefully';

-- Quiz: Error Handling
UPDATE lessons SET translations = '{
  "title": "Quiz: Fehlerbehandlung",
  "content": {
    "question": "Welcher Block wird in einem try/except/finally IMMER ausgeführt?",
    "options": ["finally", "try", "except", "else"],
    "explanation": "Der finally-Block wird immer ausgeführt, egal ob ein Fehler aufgetreten ist oder nicht. Er eignet sich für Aufräumarbeiten wie das Schließen von Dateien oder Datenbankverbindungen."
  }
}' WHERE title = 'Error Handling Quiz';

-- Theory: APIs
UPDATE lessons SET translations = '{
  "title": "APIs und HTTP verstehen",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was ist eine API?\n\nEine **API** (Application Programming Interface) ist eine Schnittstelle, über die Programme miteinander kommunizieren. Das Internet nutzt hauptsächlich **REST-APIs** mit HTTP.\n\nHTTP-Methoden:\n- `GET` — Daten abrufen\n- `POST` — Neue Daten erstellen\n- `PUT/PATCH` — Daten aktualisieren\n- `DELETE` — Daten löschen"},
      {"type": "code", "language": "python", "content": "import requests\n\n# GET-Anfrage\nresponse = requests.get(\"https://api.example.com/nutzer\")\nprint(response.status_code)  # 200 = Erfolg\nprint(response.json())        # Antwort als Python-Dict\n\n# POST-Anfrage mit Daten\nneuer_nutzer = {\"name\": \"Alice\", \"email\": \"alice@example.com\"}\nresponse = requests.post(\n    \"https://api.example.com/nutzer\",\n    json=neuer_nutzer\n)\nprint(response.status_code)   # 201 = Erstellt"},
      {"type": "text", "content": "## HTTP-Statuscodes\n\n| Code | Bedeutung |\n|------|----------|\n| 200 | OK — Anfrage erfolgreich |\n| 201 | Created — Ressource erstellt |\n| 400 | Bad Request — Fehlerhafte Anfrage |\n| 401 | Unauthorized — Nicht autorisiert |\n| 404 | Not Found — Nicht gefunden |\n| 500 | Server Error — Serverfehler |"}
    ],
    "summary": "APIs ermöglichen Kommunikation zwischen Programmen. REST-APIs nutzen HTTP-Methoden (GET, POST, PUT, DELETE) und Statuscodes (200, 404, 500) zur Kommunikation."
  }
}' WHERE title = 'Understanding APIs and HTTP';

-- Quiz: APIs
UPDATE lessons SET translations = '{
  "title": "Quiz: APIs",
  "content": {
    "question": "Welcher HTTP-Statuscode bedeutet, dass eine Ressource NICHT gefunden wurde?",
    "options": ["404", "200", "500", "201"],
    "explanation": "404 (Not Found) bedeutet, dass die angeforderte Ressource nicht auf dem Server existiert. 200 = Erfolg, 500 = Serverfehler, 201 = Ressource erstellt."
  }
}' WHERE title = 'APIs Quiz';

-- Theory: Algorithms
UPDATE lessons SET translations = '{
  "title": "Big O-Notation und grundlegende Datenstrukturen",
  "content": {
    "sections": [
      {"type": "text", "content": "## Was ist Big O?\n\n**Big O-Notation** beschreibt, wie die Laufzeit eines Algorithmus mit der Eingabegröße wächst.\n\nHäufige Komplexitäten (von schnell nach langsam):\n- O(1) — Konstant (z.B. Array-Zugriff)\n- O(log n) — Logarithmisch (z.B. Binärsuche)\n- O(n) — Linear (z.B. Liste durchsuchen)\n- O(n²) — Quadratisch (z.B. Bubble Sort)"},
      {"type": "code", "language": "python", "content": "# O(1) - Konstante Zeit\nzahlen = [1, 2, 3, 4, 5]\nerstes = zahlen[0]  # Immer gleich schnell\n\n# O(n) - Lineare Zeit\ndef suche(liste, ziel):\n    for element in liste:  # n Schritte\n        if element == ziel:\n            return True\n    return False\n\n# O(n²) - Quadratische Zeit\ndef bubble_sort(liste):\n    n = len(liste)\n    for i in range(n):\n        for j in range(n - i - 1):  # n×n Schritte\n            if liste[j] > liste[j+1]:\n                liste[j], liste[j+1] = liste[j+1], liste[j]"},
      {"type": "text", "content": "## Grundlegende Datenstrukturen\n\n| Struktur | Zugriff | Suche | Einfügen |\n|----------|---------|-------|----------|\n| Array/Liste | O(1) | O(n) | O(n) |\n| Hash-Map/Dict | O(1) | O(1) | O(1) |\n| Stack | O(n) | O(n) | O(1) |\n| Queue | O(n) | O(n) | O(1) |"}
    ],
    "summary": "Big O beschreibt die Skalierbarkeit von Algorithmen. O(1) ist am schnellsten, O(n²) am langsamsten für typische Aufgaben. Hash-Maps bieten O(1) für Zugriff und Suche."
  }
}' WHERE title = 'Big O Notation and Core Data Structures';

-- Quiz: Algorithms
UPDATE lessons SET translations = '{
  "title": "Quiz: Algorithmen",
  "content": {
    "question": "Welche Zeitkomplexität hat der Zugriff auf ein Element in einem Dictionary (Hash-Map)?",
    "options": ["O(1)", "O(n)", "O(log n)", "O(n²)"],
    "explanation": "Dictionary-Zugriff ist O(1) (konstante Zeit) dank Hash-Funktionen. Egal wie groß das Dictionary, der Zugriff ist immer gleich schnell."
  }
}' WHERE title = 'Algorithms Quiz';

-- Advanced quiz translations
UPDATE lessons SET translations = '{"title": "Quiz: Variablen-Namensregeln", "content": {"question": "Welcher Variablenname ist in Python UNGÜLTIG?", "options": ["_geheim", "mein_wert", "2start", "wert2"], "explanation": "Variablennamen dürfen nicht mit einer Zahl beginnen. ''2start'' ist ungültig. _geheim, mein_wert und wert2 sind alle gültige Namen."}}' WHERE title = 'Variables: Naming Rules Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Zuweisung und Neuzuweisung", "content": {"question": "Was ist der Wert von x nach diesem Code?\n```python\nx = 5\nx = x + 3\nx *= 2\n```", "options": ["16", "13", "10", "8"], "explanation": "Schritt 1: x = 5. Schritt 2: x = 5 + 3 = 8. Schritt 3: x = 8 * 2 = 16."}}' WHERE title = 'Variables: Assignment & Rebinding Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Typumwandlung", "content": {"question": "Was gibt int(''3.9'') in Python zurück?", "options": ["3", "4", "3.9", "Fehler"], "explanation": "int() schneidet den Dezimalteil ab (rundet nicht!). int(''3.9'') gibt 3 zurück, nicht 4."}}' WHERE title = 'Data Types: Type Conversion Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Wahrheitswerte", "content": {"question": "Welcher Wert ist in Python ''falsy'' (verhält sich wie False)?", "options": ["0", "1", "''hallo''", "[1,2,3]"], "explanation": "In Python sind folgende Werte falsy: 0, None, False, leere Strings '''', leere Listen [], leere Dicts {}. Alle anderen Zahlen und nicht-leere Sammlungen sind truthy."}}' WHERE title = 'Conditionals: Falsy Values Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Nullish Coalescing", "content": {"question": "Was gibt `None or ''Standard''` in Python zurück?", "options": ["''Standard''", "None", "True", "False"], "explanation": "In Python gibt der or-Operator den ersten truthy-Wert zurück. Da None falsy ist, wird ''Standard'' zurückgegeben."}}' WHERE title = 'Conditionals: Nullish Coalescing Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Variablenbereich in Schleifen", "content": {"question": "Was ist der Wert von i nach dieser for-Schleife?\n```python\nfor i in range(3):\n    pass\nprint(i)\n```", "options": ["2", "3", "0", "Fehler"], "explanation": "In Python bleibt die Schleifenvariable nach der Schleife verfügbar. range(3) geht von 0 bis 2, daher ist i = 2 nach der Schleife."}}' WHERE title = 'Loops: Variable Scope Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: for vs while", "content": {"question": "Wann sollte man eine while-Schleife statt einer for-Schleife verwenden?", "options": ["Wenn die Anzahl der Wiederholungen unbekannt ist", "Immer, da while schneller ist", "Wenn man über eine Liste iteriert", "Wenn man range() verwenden möchte"], "explanation": "while-Schleifen sind ideal, wenn die Anzahl der Wiederholungen vorher unbekannt ist (z.B. ''solange der Nutzer keine gültige Eingabe macht''). for-Schleifen sind besser für bekannte Sequenzen."}}' WHERE title = 'Loops: For vs While Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Reine Funktionen", "content": {"question": "Was macht eine Funktion zu einer ''reinen Funktion'' (pure function)?", "options": ["Sie hat keine Seiteneffekte und gibt bei gleicher Eingabe immer das gleiche Ergebnis zurück", "Sie verwendet nur globale Variablen", "Sie hat keine Parameter", "Sie gibt immer None zurück"], "explanation": "Eine reine Funktion hat keine Seiteneffekte (ändert keine externen Zustände) und ist deterministisch (gleiche Eingabe → immer gleiche Ausgabe). Das macht sie leicht testbar und vorhersagbar."}}' WHERE title = 'Functions: Pure Functions Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Mutable Standardargumente", "content": {"question": "Was ist falsch an dieser Funktion?\n```python\ndef anhängen(elem, liste=[]):\n    liste.append(elem)\n    return liste\n```", "options": ["Der Standardwert [] wird zwischen allen Aufrufen geteilt", "Die Funktion gibt nichts zurück", "elem ist kein gültiger Parametername", "liste sollte None sein"], "explanation": "Mutable Standardargumente (wie []) werden einmal erstellt und zwischen allen Aufrufen geteilt. Besser: def anhängen(elem, liste=None): if liste is None: liste = []"}}' WHERE title = 'Functions: Mutable Default Arguments Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Zeitkomplexität bei Listen", "content": {"question": "Welche Zeitkomplexität hat das Einfügen am Anfang einer Python-Liste?", "options": ["O(n)", "O(1)", "O(log n)", "O(n²)"], "explanation": "Das Einfügen am Anfang einer Liste ist O(n), da alle bestehenden Elemente verschoben werden müssen. append() am Ende ist O(1) amortisiert."}}' WHERE title = 'Arrays & Lists: Time Complexity Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Slice-Notation", "content": {"question": "Was gibt `[1, 2, 3, 4, 5][1:4]` zurück?", "options": ["[2, 3, 4]", "[1, 2, 3]", "[2, 3, 4, 5]", "[1, 2, 3, 4]"], "explanation": "Slice-Notation [start:stop] gibt Elemente von Index start bis (nicht einschließlich) stop zurück. [1:4] gibt Elemente an Index 1, 2, 3 zurück — also [2, 3, 4]."}}' WHERE title = 'Arrays & Lists: Slice Notation Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Hash-Map Komplexität", "content": {"question": "Warum ist der durchschnittliche Zugriff auf ein Dictionary O(1)?", "options": ["Weil eine Hash-Funktion den Speicherort direkt berechnet", "Weil Dictionaries sortiert sind", "Weil Python Dictionaries intern als Arrays speichert", "Weil Python eine Binärsuche verwendet"], "explanation": "Hash-Funktionen berechnen aus dem Schlüssel direkt die Speicheradresse. Dadurch ist der Zugriff unabhängig von der Größe des Dictionaries — O(1) im Durchschnitt."}}' WHERE title = 'Objects & Dicts: Hash Map Complexity Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Eigenschaftszugriff", "content": {"question": "Was ist der Unterschied zwischen `dict[''key'']` und `dict.get(''key'')`?", "options": ["dict[''key''] wirft einen KeyError wenn der Schlüssel fehlt; .get() gibt None zurück", "Es gibt keinen Unterschied", ".get() ist schneller", "dict[''key''] gibt None zurück wenn der Schlüssel fehlt"], "explanation": "dict[''key''] wirft einen KeyError wenn der Schlüssel nicht existiert. dict.get(''key'') gibt None (oder einen Standardwert) zurück — sicherer für optionale Schlüssel."}}' WHERE title = 'Objects & Dicts: Property Access Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: super().__init__()", "content": {"question": "Warum ruft man `super().__init__()` in einer Unterklasse auf?", "options": ["Um den Konstruktor der Elternklasse auszuführen und ihre Attribute zu initialisieren", "Um die Klasse zu löschen", "Um eine neue Instanz zu erstellen", "Um auf private Attribute zuzugreifen"], "explanation": "super().__init__() ruft den Konstruktor der Elternklasse auf, damit deren Initialisierungslogik ausgeführt wird. Ohne diesen Aufruf fehlen die Attribute der Elternklasse."}}' WHERE title = 'OOP: super().__init__() Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: isinstance() vs type()", "content": {"question": "Was ist der Unterschied zwischen `isinstance(x, int)` und `type(x) == int`?", "options": ["isinstance() berücksichtigt Vererbung; type() prüft den exakten Typ", "Es gibt keinen Unterschied", "type() ist präziser", "isinstance() ist langsamer"], "explanation": "isinstance(x, int) gibt True zurück für int und alle Unterklassen von int. type(x) == int gibt nur True zurück wenn x exakt ein int ist (keine Unterklassen). isinstance() ist daher in OOP-Kontexten bevorzugt."}}' WHERE title = 'OOP: isinstance() vs type() Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Fail-Fast-Prinzip", "content": {"question": "Was bedeutet das ''Fail Fast''-Prinzip bei der Fehlerbehandlung?", "options": ["Fehler so früh wie möglich erkennen und melden, statt sie zu verstecken", "Code so schnell wie möglich ausführen", "Alle Fehler ignorieren", "Fehler am Ende des Programms sammeln"], "explanation": "Fail Fast bedeutet: Ungültige Zustände sofort mit einer Exception melden, statt sie weiterzugeben und später schwer debuggbare Fehler zu erzeugen. Frühes Scheitern macht Code robuster."}}' WHERE title = 'Error Handling: Fail Fast Principle Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: HTTP-Methoden", "content": {"question": "Welche HTTP-Methode wird verwendet, um eine Ressource zu AKTUALISIEREN (teilweise)?", "options": ["PATCH", "POST", "PUT", "GET"], "explanation": "PATCH aktualisiert eine Ressource teilweise (nur die angegebenen Felder). PUT ersetzt die gesamte Ressource. POST erstellt eine neue Ressource. GET ruft Daten ab."}}' WHERE title = 'APIs: HTTP Methods Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Statuscodes", "content": {"question": "Was bedeutet HTTP-Statuscode 201?", "options": ["Eine neue Ressource wurde erfolgreich erstellt", "Die Anfrage war erfolgreich", "Die Ressource wurde nicht gefunden", "Nicht autorisiert"], "explanation": "201 Created bedeutet, dass die Anfrage erfolgreich war und eine neue Ressource erstellt wurde. Typisch als Antwort auf POST-Anfragen."}}' WHERE title = 'APIs: Status Codes Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Suchalgorithmen", "content": {"question": "Welche Voraussetzung muss erfüllt sein, um Binärsuche zu verwenden?", "options": ["Die Liste muss sortiert sein", "Die Liste darf keine Duplikate haben", "Die Liste muss mindestens 10 Elemente haben", "Die Liste muss aus Zahlen bestehen"], "explanation": "Binärsuche (O(log n)) setzt voraus, dass die Liste sortiert ist. Sie halbiert bei jedem Schritt den Suchbereich — das funktioniert nur bei sortierten Daten."}}' WHERE title = 'Algorithms: Search Algorithms Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Sortieralgorithmen", "content": {"question": "Welche Zeitkomplexität hat Python''s eingebauter sort()-Algorithmus (Timsort) im Durchschnitt?", "options": ["O(n log n)", "O(n²)", "O(n)", "O(log n)"], "explanation": "Python''s sort() verwendet Timsort mit O(n log n) im Durchschnitt und im schlechtesten Fall. Im besten Fall (bereits sortierte Daten) ist es O(n)."}}' WHERE title = 'Algorithms: Sorting Algorithms Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Generatoren", "content": {"question": "Was ist der Vorteil von Generatoren gegenüber Listen?", "options": ["Generatoren berechnen Werte lazy — sie verbrauchen weniger Speicher", "Generatoren sind immer schneller", "Generatoren können mehr Werte speichern", "Generatoren sind einfacher zu schreiben"], "explanation": "Generatoren berechnen Werte erst wenn sie benötigt werden (lazy evaluation). Das spart Speicher bei großen Datenmengen — statt alle Werte auf einmal zu speichern, wird nur der aktuelle Wert gehalten."}}' WHERE title = 'Generators Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Dekoratoren", "content": {"question": "Was macht ein Python-Dekorator?", "options": ["Er umhüllt eine Funktion, um ihr Verhalten zu erweitern", "Er benennt eine Funktion um", "Er löscht eine Funktion", "Er macht eine Funktion privat"], "explanation": "Dekoratoren sind Funktionen, die andere Funktionen als Argument nehmen und eine erweiterte Version zurückgeben. Mit @decorator-Syntax wird die Originalfunktion beim Definieren dekoriert."}}' WHERE title = 'Decorators Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Reguläre Ausdrücke", "content": {"question": "Was passt das Muster `\\d+` in einem regulären Ausdruck?", "options": ["Eine oder mehrere Ziffern", "Genau eine Ziffer", "Buchstaben und Ziffern", "Leerzeichen"], "explanation": "\\d steht für eine Ziffer (0-9). Das + bedeutet ''ein oder mehrfach''. Also passt \\d+ auf Sequenzen von einer oder mehr Ziffern, z.B. ''42'', ''123'', ''7''."}}' WHERE title = 'Regex Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Closures", "content": {"question": "Was ist eine Closure in Python?", "options": ["Eine Funktion, die auf Variablen aus ihrem äußeren Scope zugreift, auch nachdem dieser beendet ist", "Eine Klasse ohne Methoden", "Ein privates Attribut", "Eine Funktion ohne Rückgabewert"], "explanation": "Eine Closure ist eine innere Funktion, die Variablen aus dem umgebenden (äußeren) Scope ''einschließt'' und auf sie zugreifen kann, selbst nachdem die äußere Funktion beendet wurde."}}' WHERE title = 'Closures Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Async/Await", "content": {"question": "Wofür wird async/await in Python verwendet?", "options": ["Für nicht-blockierende I/O-Operationen wie Netzwerkanfragen", "Für Parallelverarbeitung auf mehreren CPU-Kernen", "Für schnellere Berechnungen", "Für Datenbankoperationen ausschließlich"], "explanation": "async/await ermöglicht asynchrone Programmierung für I/O-gebundene Aufgaben (Netzwerk, Dateien). Während eine Anfrage wartet, kann Python andere Aufgaben ausführen — ohne Threads."}}' WHERE title = 'Async/Await Quiz';

UPDATE lessons SET translations = '{"title": "Quiz: Module und Pakete", "content": {"question": "Was ist der Unterschied zwischen `import math` und `from math import sqrt`?", "options": ["import math lädt das gesamte Modul; from math import sqrt importiert nur sqrt in den lokalen Namespace", "Es gibt keinen Unterschied", "from math import sqrt ist langsamer", "import math importiert nur sqrt"], "explanation": "import math macht alle math-Funktionen über math.sqrt() etc. verfügbar. from math import sqrt importiert sqrt direkt in den Namespace, sodass sqrt() ohne Präfix aufgerufen werden kann."}}' WHERE title = 'Modules Quiz';
