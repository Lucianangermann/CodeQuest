import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { CheckCircle, ChevronDown, ChevronUp, Copy, Check, AlertTriangle, Lightbulb, Terminal, GitBranch, Github } from 'lucide-react'

// ── Copy button ───────────────────────────────────────────────────────────────

function CopyBtn({ text }: { text: string }) {
  const [copied, setCopied] = useState(false)
  function copy() {
    navigator.clipboard.writeText(text)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }
  return (
    <button onClick={copy} className="flex items-center gap-1 text-xs text-quest-muted hover:text-quest-text transition-colors px-2 py-0.5 rounded hover:bg-white/5">
      {copied ? <><Check className="w-3 h-3 text-quest-green" />Copied</> : <><Copy className="w-3 h-3" />Copy</>}
    </button>
  )
}

// ── Terminal block ────────────────────────────────────────────────────────────

function Cmd({ children, comment }: { children: string; comment?: string }) {
  return (
    <div className="rounded-xl overflow-hidden border border-quest-border my-3">
      <div className="flex items-center justify-between px-4 py-2 bg-[#1e1e2e] border-b border-quest-border">
        <div className="flex items-center gap-2">
          <Terminal className="w-3.5 h-3.5 text-quest-muted" />
          <span className="text-xs text-quest-muted font-mono">Terminal</span>
          {comment && <span className="text-xs text-quest-muted">·</span>}
          {comment && <span className="text-xs text-blue-400/80">{comment}</span>}
        </div>
        <CopyBtn text={children} />
      </div>
      <pre className="bg-[#0d0d1a] px-4 py-3 text-sm font-mono text-quest-text overflow-x-auto">
        <span className="text-quest-green select-none">$ </span>
        <span className="text-white">{children}</span>
      </pre>
    </div>
  )
}

function MultiCmd({ lines }: { lines: { cmd: string; comment?: string }[] }) {
  const allCmds = lines.map(l => l.cmd).join('\n')
  return (
    <div className="rounded-xl overflow-hidden border border-quest-border my-3">
      <div className="flex items-center justify-between px-4 py-2 bg-[#1e1e2e] border-b border-quest-border">
        <div className="flex items-center gap-2">
          <Terminal className="w-3.5 h-3.5 text-quest-muted" />
          <span className="text-xs text-quest-muted font-mono">Terminal</span>
        </div>
        <CopyBtn text={allCmds} />
      </div>
      <pre className="bg-[#0d0d1a] px-4 py-3 text-sm font-mono overflow-x-auto space-y-1">
        {lines.map((l, i) => (
          <div key={i}>
            <span className="text-quest-green select-none">$ </span>
            <span className="text-white">{l.cmd}</span>
            {l.comment && <span className="text-quest-muted ml-3"># {l.comment}</span>}
          </div>
        ))}
      </pre>
    </div>
  )
}

function Output({ children }: { children: string }) {
  return (
    <pre className="bg-[#0a0a14] border border-quest-border/50 rounded-xl px-4 py-3 text-sm font-mono text-quest-muted overflow-x-auto my-2">
      {children}
    </pre>
  )
}

function Tip({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex gap-3 p-4 rounded-xl bg-quest-purple/10 border border-quest-purple/20 my-3">
      <Lightbulb className="w-4 h-4 text-quest-purple-light flex-shrink-0 mt-0.5" />
      <p className="text-sm text-quest-text">{children}</p>
    </div>
  )
}

function Warning({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex gap-3 p-4 rounded-xl bg-red-500/10 border border-red-500/20 my-3">
      <AlertTriangle className="w-4 h-4 text-red-400 flex-shrink-0 mt-0.5" />
      <p className="text-sm text-quest-text">{children}</p>
    </div>
  )
}

// ── Collapsible section ───────────────────────────────────────────────────────

function Section({
  id, emoji, title, children, defaultOpen = false,
}: {
  id: string; emoji: string; title: string; children: React.ReactNode; defaultOpen?: boolean
}) {
  const [open, setOpen] = useState(defaultOpen)
  const [done, setDone] = useState(() => localStorage.getItem(`gh_done_${id}`) === '1')

  function toggleDone(e: React.MouseEvent) {
    e.stopPropagation()
    const next = !done
    setDone(next)
    localStorage.setItem(`gh_done_${id}`, next ? '1' : '0')
  }

  return (
    <motion.div
      id={id}
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      className={`rounded-2xl border transition-all duration-200 ${
        done ? 'border-quest-green/30 bg-quest-green/5' : 'border-quest-border bg-quest-card'
      }`}
    >
      <button
        onClick={() => setOpen(o => !o)}
        className="w-full flex items-center gap-3 px-6 py-5 text-left"
      >
        <span className="text-2xl flex-shrink-0">{emoji}</span>
        <span className="font-bold text-white flex-1 text-base">{title}</span>
        <button
          onClick={toggleDone}
          className={`w-6 h-6 rounded-full border-2 flex items-center justify-center transition-all flex-shrink-0 mr-2 ${
            done ? 'border-quest-green bg-quest-green/20 text-quest-green' : 'border-quest-border hover:border-quest-purple/50'
          }`}
        >
          {done && <Check className="w-3 h-3" />}
        </button>
        {open ? <ChevronUp className="w-4 h-4 text-quest-muted flex-shrink-0" /> : <ChevronDown className="w-4 h-4 text-quest-muted flex-shrink-0" />}
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.2 }}
            className="overflow-hidden"
          >
            <div className="px-6 pb-6 border-t border-quest-border/50 pt-4 space-y-4 text-sm text-quest-text leading-relaxed">
              {children}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  )
}

// ── Main page ─────────────────────────────────────────────────────────────────

const SECTIONS = [
  { id: 'basics',   emoji: '🟢', title: 'Was ist Git & GitHub?' },
  { id: 'setup',    emoji: '⚙️', title: 'Installation & Konfiguration' },
  { id: 'repo',     emoji: '📁', title: 'Repository erstellen & klonen' },
  { id: 'commits',  emoji: '📝', title: 'Änderungen tracken & committen' },
  { id: 'branches', emoji: '🌿', title: 'Branches' },
  { id: 'remote',   emoji: '🌐', title: 'Remote Repository (Push & Pull)' },
  { id: 'pr',       emoji: '🔀', title: 'Pull Requests' },
  { id: 'workflow', emoji: '⚡', title: 'GitHub Flow — der Standard-Workflow' },
  { id: 'undo',     emoji: '↩️', title: 'Fehler rückgängig machen' },
  { id: 'tips',     emoji: '🛠️', title: 'Nützliche Befehle & Tipps' },
]

export default function GitHubGuide() {
  const [doneCount, setDoneCount] = useState(0)

  useEffect(() => {
    const count = SECTIONS.filter(s => localStorage.getItem(`gh_done_${s.id}`) === '1').length
    setDoneCount(count)
  }, [])

  function scrollTo(id: string) {
    document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="w-10 h-10 rounded-xl bg-quest-border flex items-center justify-center">
            <Github className="w-5 h-5 text-white" />
          </div>
          <h1 className="text-3xl font-bold text-white">Git & GitHub Guide</h1>
        </div>
        <p className="text-quest-muted">
          Von null zum professionellen Git-Workflow — Schritt für Schritt erklärt.
        </p>
        {doneCount > 0 && (
          <div className="mt-3 flex items-center gap-2">
            <div className="flex-1 h-1.5 bg-quest-border rounded-full">
              <div
                className="h-1.5 bg-quest-green rounded-full transition-all duration-500"
                style={{ width: `${(doneCount / SECTIONS.length) * 100}%` }}
              />
            </div>
            <span className="text-xs text-quest-muted">{doneCount}/{SECTIONS.length} gelesen</span>
          </div>
        )}
      </div>

      <div className="flex gap-8">
        {/* Sidebar navigation — desktop only */}
        <div className="hidden lg:block w-56 flex-shrink-0">
          <div className="sticky top-24 space-y-1">
            <p className="text-xs font-semibold text-quest-muted uppercase tracking-wide mb-3">Inhalt</p>
            {SECTIONS.map(s => {
              const done = localStorage.getItem(`gh_done_${s.id}`) === '1'
              return (
                <button
                  key={s.id}
                  onClick={() => scrollTo(s.id)}
                  title={s.title}
                  className="w-full text-left flex items-start gap-2 px-3 py-2 rounded-lg text-sm text-quest-muted hover:text-quest-text hover:bg-quest-border transition-all"
                >
                  {done
                    ? <CheckCircle className="w-3.5 h-3.5 text-quest-green flex-shrink-0 mt-0.5" />
                    : <span className="w-3.5 h-3.5 flex-shrink-0 text-center text-xs mt-0.5">{s.emoji}</span>
                  }
                  <span>{s.title}</span>
                </button>
              )
            })}
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 space-y-4">
          {/* Basics */}
          <Section id="basics" emoji="🟢" title="Was ist Git & GitHub?" defaultOpen>
            <p>
              <strong className="text-white">Git</strong> ist ein <em>Versionskontrollsystem</em> — es speichert jeden Schritt deiner Codearbeit wie ein Zeitstrahl.
              Du kannst jederzeit zu einem früheren Zustand zurückspringen, verschiedene Versionen parallel entwickeln und Änderungen nachvollziehen.
            </p>
            <p>
              <strong className="text-white">GitHub</strong> ist eine Cloud-Plattform für Git-Repositories. Du speicherst deinen Code dort online, arbeitest mit anderen zusammen und zeigst deine Projekte der Welt.
            </p>
            <div className="grid grid-cols-2 gap-3 my-4">
              {[
                { icon: '📸', title: 'Commit', desc: 'Ein Snapshot deines Codes zu einem bestimmten Zeitpunkt' },
                { icon: '🌿', title: 'Branch', desc: 'Eine parallele Version deines Projekts für neue Features' },
                { icon: '🔀', title: 'Merge', desc: 'Zwei Branches zusammenführen' },
                { icon: '☁️', title: 'Remote', desc: 'Dein Repository auf GitHub (online)' },
              ].map(c => (
                <div key={c.title} className="p-3 rounded-xl bg-quest-border/30 border border-quest-border">
                  <span className="text-xl">{c.icon}</span>
                  <p className="font-semibold text-white text-sm mt-1">{c.title}</p>
                  <p className="text-xs text-quest-muted mt-0.5">{c.desc}</p>
                </div>
              ))}
            </div>
          </Section>

          {/* Setup */}
          <Section id="setup" emoji="⚙️" title="Installation & Konfiguration">
            <p><strong className="text-white">1. Git installieren</strong></p>
            <div className="space-y-2">
              <p className="text-quest-muted text-xs uppercase tracking-wide">macOS</p>
              <Cmd>brew install git</Cmd>
              <p className="text-quest-muted text-xs uppercase tracking-wide">Ubuntu / Debian</p>
              <Cmd>sudo apt install git</Cmd>
              <p className="text-quest-muted text-xs uppercase tracking-wide">Windows</p>
              <p className="text-sm text-quest-text">→ Lade <strong className="text-white">Git for Windows</strong> von <code className="text-quest-purple-light">git-scm.com</code> herunter und installiere es.</p>
            </div>

            <p className="mt-4"><strong className="text-white">2. Name & E-Mail setzen</strong> (einmalig, erscheint in jedem Commit)</p>
            <MultiCmd lines={[
              { cmd: 'git config --global user.name "Dein Name"' },
              { cmd: 'git config --global user.email "dein@email.com"' },
            ]} />

            <p className="mt-4"><strong className="text-white">3. Standard-Editor setzen</strong></p>
            <Cmd comment="VS Code als Standard">git config --global core.editor "code --wait"</Cmd>

            <p className="mt-4"><strong className="text-white">4. SSH-Key für GitHub</strong> (damit du ohne Passwort pushen kannst)</p>
            <MultiCmd lines={[
              { cmd: 'ssh-keygen -t ed25519 -C "dein@email.com"', comment: 'Schlüssel generieren' },
              { cmd: 'cat ~/.ssh/id_ed25519.pub', comment: 'Public Key anzeigen' },
            ]} />
            <p>Kopiere den angezeigten Public Key und füge ihn auf GitHub unter <strong className="text-white">Settings → SSH Keys</strong> ein.</p>

            <Tip>Überprüfe deine Konfiguration jederzeit mit: <code className="text-quest-purple-light">git config --list</code></Tip>
          </Section>

          {/* Repo */}
          <Section id="repo" emoji="📁" title="Repository erstellen & klonen">
            <p><strong className="text-white">Neues Repo lokal erstellen</strong></p>
            <MultiCmd lines={[
              { cmd: 'mkdir mein-projekt', comment: 'Ordner anlegen' },
              { cmd: 'cd mein-projekt' },
              { cmd: 'git init', comment: 'Git initialisieren' },
            ]} />
            <Output>Initialized empty Git repository in /mein-projekt/.git/</Output>

            <p className="mt-4"><strong className="text-white">Vorhandenes GitHub-Repo klonen</strong></p>
            <Cmd comment="SSH (empfohlen wenn SSH-Key gesetzt)">git clone git@github.com:username/repo-name.git</Cmd>
            <Cmd comment="HTTPS (funktioniert immer)">git clone https://github.com/username/repo-name.git</Cmd>

            <p className="mt-4"><strong className="text-white">Neues Repo auf GitHub verbinden</strong></p>
            <p>Erstelle das Repo auf GitHub (ohne README), dann:</p>
            <MultiCmd lines={[
              { cmd: 'git remote add origin git@github.com:username/repo-name.git' },
              { cmd: 'git branch -M main' },
              { cmd: 'git push -u origin main' },
            ]} />

            <Tip>
              <code className="text-quest-purple-light">-u</code> (oder <code className="text-quest-purple-light">--set-upstream</code>) verknüpft deinen lokalen Branch mit dem Remote.
              Danach reicht einfach <code className="text-quest-purple-light">git push</code>.
            </Tip>
          </Section>

          {/* Commits */}
          <Section id="commits" emoji="📝" title="Änderungen tracken & committen">
            <p>Der typische Ablauf nach jeder Änderung:</p>

            <p className="mt-3"><strong className="text-white">Status prüfen</strong> — was hat sich geändert?</p>
            <Cmd>git status</Cmd>
            <Output>{`On branch main
Changes not staged for commit:
  modified:   index.js

Untracked files:
  neue-datei.txt`}</Output>

            <p className="mt-3"><strong className="text-white">Dateien stagen</strong> — auswählen, was in den Commit soll</p>
            <MultiCmd lines={[
              { cmd: 'git add index.js', comment: 'einzelne Datei' },
              { cmd: 'git add src/', comment: 'ganzen Ordner' },
              { cmd: 'git add .', comment: 'alles im aktuellen Verzeichnis' },
            ]} />

            <p className="mt-3"><strong className="text-white">Commit erstellen</strong></p>
            <Cmd comment="kurze Commit-Message">git commit -m "feat: Login-Funktion hinzugefügt"</Cmd>

            <p className="mt-3"><strong className="text-white">Commit-Verlauf ansehen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git log --oneline', comment: 'kompakte Ansicht' },
              { cmd: 'git log --oneline --graph --all', comment: 'mit Branch-Grafik' },
            ]} />
            <Output>{`a3f9b21 feat: Login-Funktion hinzugefügt
7c2d4e8 fix: Typo in README behoben
9a1b3f0 init: Projekt initialisiert`}</Output>

            <p className="mt-3"><strong className="text-white">Unterschiede ansehen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git diff', comment: 'ungestaged Änderungen' },
              { cmd: 'git diff --staged', comment: 'gestaged (vor dem Commit)' },
            ]} />

            <div className="p-4 rounded-xl bg-quest-border/30 border border-quest-border mt-4">
              <p className="font-semibold text-white text-sm mb-2">✅ Gute Commit-Messages</p>
              <div className="space-y-1 text-xs font-mono">
                <p className="text-quest-green">✓ feat: Benutzer-Authentifizierung implementiert</p>
                <p className="text-quest-green">✓ fix: Crash beim Laden leerer Listen behoben</p>
                <p className="text-quest-green">✓ docs: README mit Setup-Anleitung erweitert</p>
                <p className="text-red-400 mt-2">✗ update</p>
                <p className="text-red-400">✗ changes</p>
                <p className="text-red-400">✗ asdf</p>
              </div>
            </div>

            <Tip>Nutze Präfixe: <code className="text-quest-purple-light">feat:</code> (neues Feature), <code className="text-quest-purple-light">fix:</code> (Bugfix), <code className="text-quest-purple-light">docs:</code> (Doku), <code className="text-quest-purple-light">refactor:</code> (Code-Umstrukturierung), <code className="text-quest-purple-light">style:</code> (Formatierung)</Tip>
          </Section>

          {/* Branches */}
          <Section id="branches" emoji="🌿" title="Branches">
            <p>
              Ein Branch ist wie eine eigene Arbeitskopie deines Projekts. Du entwickelst Features isoliert, ohne den Hauptcode zu beeinflussen — und mergst erst, wenn alles fertig ist.
            </p>

            <p className="mt-3"><strong className="text-white">Branch erstellen & wechseln</strong></p>
            <MultiCmd lines={[
              { cmd: 'git branch feature/login', comment: 'Branch erstellen' },
              { cmd: 'git checkout feature/login', comment: 'Branch wechseln' },
            ]} />
            <p className="text-quest-muted text-xs mt-1">Oder beides in einem Schritt:</p>
            <Cmd comment="empfohlen">git checkout -b feature/login</Cmd>

            <p className="mt-3"><strong className="text-white">Alle Branches anzeigen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git branch', comment: 'lokale Branches' },
              { cmd: 'git branch -a', comment: 'alle inkl. Remote' },
            ]} />

            <p className="mt-3"><strong className="text-white">Branch mergen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git checkout main', comment: '1. auf main wechseln' },
              { cmd: 'git merge feature/login', comment: '2. Feature-Branch reinmergen' },
            ]} />

            <p className="mt-3"><strong className="text-white">Branch löschen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git branch -d feature/login', comment: 'lokal löschen (nur wenn gemergt)' },
              { cmd: 'git branch -D feature/login', comment: 'lokal löschen (erzwungen)' },
              { cmd: 'git push origin --delete feature/login', comment: 'remote löschen' },
            ]} />

            <p className="mt-3"><strong className="text-white">Merge-Konflikte lösen</strong></p>
            <p>Wenn Git zwei widersprüchliche Änderungen nicht automatisch mergen kann:</p>
            <Output>{`<<<<<<< HEAD
  const message = "Hallo";
=======
  const message = "Hello";
>>>>>>> feature/login`}</Output>
            <p>Bearbeite die Datei, entferne die <code className="text-quest-purple-light">{`<<<`}</code>/<code className="text-quest-purple-light">{`===`}</code>/<code className="text-quest-purple-light">{`>>>`}</code>-Markierungen und behalte die richtige Version. Dann:</p>
            <MultiCmd lines={[
              { cmd: 'git add .', comment: 'Konflikt als gelöst markieren' },
              { cmd: 'git commit', comment: 'Merge abschließen' },
            ]} />

            <Warning>Niemals direkt auf <code>main</code> entwickeln! Nutze immer Feature-Branches.</Warning>
          </Section>

          {/* Remote */}
          <Section id="remote" emoji="🌐" title="Remote Repository (Push & Pull)">
            <p><strong className="text-white">Code hochladen (push)</strong></p>
            <MultiCmd lines={[
              { cmd: 'git push', comment: 'wenn upstream bereits gesetzt' },
              { cmd: 'git push origin feature/login', comment: 'Branch explizit angeben' },
              { cmd: 'git push -u origin feature/login', comment: 'beim ersten Push + upstream setzen' },
            ]} />

            <p className="mt-3"><strong className="text-white">Neueste Änderungen holen (pull)</strong></p>
            <MultiCmd lines={[
              { cmd: 'git pull', comment: 'holt und mergt automatisch' },
              { cmd: 'git pull --rebase', comment: 'holt und rebased (sauberer History)' },
            ]} />

            <p className="mt-3"><strong className="text-white">Änderungen holen ohne zu mergen (fetch)</strong></p>
            <Cmd comment="nützlich um erstmal zu schauen was es Neues gibt">git fetch origin</Cmd>

            <p className="mt-3"><strong className="text-white">Remote-URLs verwalten</strong></p>
            <MultiCmd lines={[
              { cmd: 'git remote -v', comment: 'alle Remotes anzeigen' },
              { cmd: 'git remote set-url origin git@github.com:user/repo.git', comment: 'URL ändern' },
            ]} />

            <Tip>
              Mache immer <code className="text-quest-purple-light">git pull</code> bevor du anfängst zu arbeiten — besonders in Team-Projekten. So vermeidest du unnötige Konflikte.
            </Tip>
          </Section>

          {/* PR */}
          <Section id="pr" emoji="🔀" title="Pull Requests">
            <p>
              Ein <strong className="text-white">Pull Request (PR)</strong> ist eine Anfrage, deinen Branch in einen anderen (meist <code className="text-quest-purple-light">main</code>) zu mergen. Er ermöglicht Code-Reviews, Diskussionen und automatische Tests bevor Code in Production geht.
            </p>

            <p className="mt-4 font-semibold text-white">Ablauf</p>
            <div className="space-y-3 mt-3">
              {[
                { step: '1', text: 'Feature-Branch erstellen und entwickeln', cmd: 'git checkout -b feature/mein-feature' },
                { step: '2', text: 'Regelmäßig committen', cmd: 'git add . && git commit -m "feat: ..."' },
                { step: '3', text: 'Branch auf GitHub pushen', cmd: 'git push -u origin feature/mein-feature' },
                { step: '4', text: 'Auf GitHub: "Compare & pull request" klicken', cmd: null },
                { step: '5', text: 'Titel und Beschreibung ausfüllen, Reviewer hinzufügen', cmd: null },
                { step: '6', text: 'Review-Feedback umsetzen, neue Commits pushen', cmd: null },
                { step: '7', text: 'PR wird gemergt → Branch löschen', cmd: null },
              ].map(({ step, text, cmd }) => (
                <div key={step} className="flex gap-3">
                  <div className="w-6 h-6 rounded-full bg-quest-purple/20 border border-quest-purple/30 flex items-center justify-center text-xs font-bold text-quest-purple-light flex-shrink-0 mt-0.5">
                    {step}
                  </div>
                  <div>
                    <p className="text-sm text-quest-text">{text}</p>
                    {cmd && <Cmd>{cmd}</Cmd>}
                  </div>
                </div>
              ))}
            </div>

            <p className="mt-4"><strong className="text-white">PR über GitHub CLI erstellen</strong></p>
            <MultiCmd lines={[
              { cmd: 'gh pr create --title "feat: Login" --body "Beschreibung des PRs"' },
              { cmd: 'gh pr list', comment: 'offene PRs anzeigen' },
              { cmd: 'gh pr merge 42 --merge', comment: 'PR #42 mergen' },
            ]} />
          </Section>

          {/* Workflow */}
          <Section id="workflow" emoji="⚡" title="GitHub Flow — der Standard-Workflow">
            <p>Der <strong className="text-white">GitHub Flow</strong> ist ein einfacher, leistungsstarker Workflow für Teams jeder Größe:</p>

            <div className="my-4 p-4 rounded-xl bg-quest-border/20 border border-quest-border font-mono text-xs overflow-x-auto">
              <div className="flex items-center gap-2 text-quest-muted mb-3">
                <GitBranch className="w-3.5 h-3.5" />
                <span>Branch-Diagramm</span>
              </div>
              <div className="space-y-1">
                <p><span className="text-quest-green">main</span>   ●───────────────────────────●─── production ready</p>
                <p><span className="text-blue-400">feature</span>       └──●──●──●──┘</p>
                <p className="text-quest-muted ml-8">commit  commit  PR → merge</p>
              </div>
            </div>

            <div className="space-y-4">
              {[
                { title: 'main ist immer deployt', desc: 'main enthält nur stabilen Code. Alles in main kann jederzeit in Production.' },
                { title: 'Feature-Branches für alles', desc: 'Jede Änderung bekommt einen eigenen Branch mit beschreibendem Namen.' },
                { title: 'Commits regelmäßig & klein', desc: 'Viele kleine Commits sind besser als ein riesiger. Leichter zu reviewen, leichter zu revertieren.' },
                { title: 'PR öffnen & reviewen lassen', desc: 'Hole Feedback, bevor du mergst. CI/CD-Tests laufen automatisch gegen deinen PR.' },
                { title: 'Sofort deployen nach Merge', desc: 'Nach dem Merge in main sofort deployen. So bleibt main immer frisch.' },
              ].map((item, i) => (
                <div key={i} className="flex gap-3">
                  <div className="w-5 h-5 rounded-full bg-quest-green/20 border border-quest-green/30 flex items-center justify-center text-xs text-quest-green flex-shrink-0 mt-0.5">✓</div>
                  <div>
                    <p className="font-semibold text-white text-sm">{item.title}</p>
                    <p className="text-quest-muted text-xs mt-0.5">{item.desc}</p>
                  </div>
                </div>
              ))}
            </div>

            <p className="mt-4 font-semibold text-white">Kompletter Ablauf in Befehlen</p>
            <MultiCmd lines={[
              { cmd: 'git checkout main && git pull', comment: '1. main aktualisieren' },
              { cmd: 'git checkout -b feature/neues-feature', comment: '2. Branch erstellen' },
              { cmd: 'git add . && git commit -m "feat: ..."', comment: '3. Entwickeln & committen' },
              { cmd: 'git push -u origin feature/neues-feature', comment: '4. Pushen' },
              { cmd: '# → GitHub: PR erstellen, reviewen lassen', comment: '5. PR auf GitHub' },
              { cmd: '# → Nach Merge: Branch löschen', comment: '6. Aufräumen' },
              { cmd: 'git checkout main && git pull', comment: '7. main aktualisieren' },
              { cmd: 'git branch -d feature/neues-feature', comment: '8. lokalen Branch löschen' },
            ]} />
          </Section>

          {/* Undo */}
          <Section id="undo" emoji="↩️" title="Fehler rückgängig machen">
            <p><strong className="text-white">Letzten Commit bearbeiten</strong> (noch nicht gepusht)</p>
            <MultiCmd lines={[
              { cmd: 'git commit --amend -m "bessere Nachricht"', comment: 'Commit-Message ändern' },
              { cmd: 'git commit --amend --no-edit', comment: 'Dateien hinzufügen ohne Message zu ändern' },
            ]} />
            <Warning>Niemals <code>--amend</code> auf bereits gepushten Commits! Das überschreibt die History für alle anderen.</Warning>

            <p className="mt-4"><strong className="text-white">Staged Dateien zurückziehen</strong></p>
            <Cmd>git restore --staged datei.js</Cmd>

            <p className="mt-4"><strong className="text-white">Lokale Änderungen verwerfen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git restore datei.js', comment: 'einzelne Datei zurücksetzen' },
              { cmd: 'git restore .', comment: 'alle Änderungen verwerfen' },
            ]} />

            <p className="mt-4"><strong className="text-white">Commits rückgängig machen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git revert HEAD', comment: 'letzten Commit umkehren (sicherer Weg, neuer Commit)' },
              { cmd: 'git reset --soft HEAD~1', comment: 'Commit rückgängig, Dateien bleiben gestaged' },
              { cmd: 'git reset --mixed HEAD~1', comment: 'Commit rückgängig, Dateien unstaged' },
              { cmd: 'git reset --hard HEAD~1', comment: '⚠️ Commit + Änderungen komplett löschen' },
            ]} />
            <Warning><code>git reset --hard</code> löscht Änderungen unwiderruflich. Nutze lieber <code>git revert</code> für bereits gepushte Commits.</Warning>

            <p className="mt-4"><strong className="text-white">Stash — Änderungen zwischenspeichern</strong></p>
            <p>Wenn du schnell den Branch wechseln musst, aber noch nicht committen willst:</p>
            <MultiCmd lines={[
              { cmd: 'git stash', comment: 'Änderungen beiseitelegen' },
              { cmd: 'git stash pop', comment: 'Änderungen wiederherstellen' },
              { cmd: 'git stash list', comment: 'alle Stashes anzeigen' },
              { cmd: 'git stash drop', comment: 'letzten Stash löschen' },
            ]} />
          </Section>

          {/* Tips */}
          <Section id="tips" emoji="🛠️" title="Nützliche Befehle & Tipps">
            <p><strong className="text-white">.gitignore — Dateien von Git ausschließen</strong></p>
            <p>Erstelle eine <code className="text-quest-purple-light">.gitignore</code>-Datei im Projektroot:</p>
            <div className="rounded-xl overflow-hidden border border-quest-border my-3">
              <div className="flex items-center justify-between px-4 py-2 bg-[#1e1e2e] border-b border-quest-border">
                <span className="text-xs text-quest-muted font-mono">.gitignore</span>
                <CopyBtn text={`node_modules/\n.env\n.DS_Store\ndist/\n*.log`} />
              </div>
              <pre className="bg-[#0d0d1a] px-4 py-3 text-sm font-mono text-quest-text">{`node_modules/     # Abhängigkeiten (nie committen!)
.env              # Geheime Keys & Passwörter
.DS_Store         # macOS Metadaten
dist/             # Build-Output
*.log             # Log-Dateien`}</pre>
            </div>
            <Tip>Nutze <a href="https://www.toptal.com/developers/gitignore" className="text-quest-purple-light hover:underline" target="_blank" rel="noreferrer">gitignore.io</a> um automatisch eine .gitignore für dein Projekt zu generieren.</Tip>

            <p className="mt-4"><strong className="text-white">Aliases — Befehle abkürzen</strong></p>
            <MultiCmd lines={[
              { cmd: 'git config --global alias.st status' },
              { cmd: 'git config --global alias.co checkout' },
              { cmd: 'git config --global alias.br branch' },
              { cmd: 'git config --global alias.lg "log --oneline --graph --all"' },
            ]} />
            <p>Danach kannst du z.B. <code className="text-quest-purple-light">git lg</code> statt des langen log-Befehls nutzen.</p>

            <p className="mt-4"><strong className="text-white">Datei aus dem letzten Commit</strong></p>
            <Cmd comment="Datei aus einem anderen Branch holen">git checkout main -- pfad/zur/datei.js</Cmd>

            <p className="mt-4"><strong className="text-white">Wer hat diese Zeile geändert?</strong></p>
            <Cmd>git blame datei.js</Cmd>

            <p className="mt-4"><strong className="text-white">Wann wurde ein Bug eingeführt?</strong></p>
            <MultiCmd lines={[
              { cmd: 'git bisect start' },
              { cmd: 'git bisect bad', comment: 'aktueller Commit ist buggy' },
              { cmd: 'git bisect good v1.0', comment: 'dieser Commit war noch gut' },
            ]} />
            <p>Git springt automatisch zur Mitte und fragt ob der Commit gut oder schlecht ist — bis es den genauen Commit gefunden hat.</p>

            <p className="mt-4"><strong className="text-white">Cherry-pick — einzelnen Commit übernehmen</strong></p>
            <Cmd comment="commit-hash findest du mit git log">git cherry-pick a3f9b21</Cmd>

            <div className="mt-4 p-4 rounded-xl bg-quest-border/30 border border-quest-border">
              <p className="font-semibold text-white text-sm mb-3">⚡ Schnell-Referenz</p>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs font-mono">
                {[
                  ['git status', 'Zustand anzeigen'],
                  ['git add .', 'Alles stagen'],
                  ['git commit -m "msg"', 'Committen'],
                  ['git push', 'Pushen'],
                  ['git pull', 'Pullen'],
                  ['git checkout -b name', 'Branch erstellen'],
                  ['git merge branch', 'Branch mergen'],
                  ['git log --oneline', 'Verlauf'],
                  ['git diff', 'Änderungen sehen'],
                  ['git stash', 'Zwischenspeichern'],
                ].map(([cmd, desc]) => (
                  <div key={cmd} className="flex items-center gap-2">
                    <code className="text-quest-purple-light">{cmd}</code>
                    <span className="text-quest-muted">—</span>
                    <span className="text-quest-text">{desc}</span>
                  </div>
                ))}
              </div>
            </div>
          </Section>

          {/* Done banner */}
          {SECTIONS.every(s => localStorage.getItem(`gh_done_${s.id}`) === '1') && (
            <motion.div
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              className="card text-center py-8"
              style={{ borderColor: 'rgba(234,179,8,0.4)', background: 'rgba(234,179,8,0.05)' }}
            >
              <div className="text-5xl mb-3">🏆</div>
              <h2 className="text-xl font-bold text-white">Git & GitHub gemeistert!</h2>
              <p className="text-quest-muted mt-2">Du kennst jetzt alle wichtigen Konzepte. Zeit, sie in echten Projekten einzusetzen.</p>
            </motion.div>
          )}
        </div>
      </div>
    </div>
  )
}
