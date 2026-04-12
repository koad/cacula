# KINGDOM: The Game — v2 Design Document

> Build your sovereign AI kingdom. For real.

**Genre:** Narrative simulation / tycoon / hacking sandbox / living harness
**Platform:** Steam (Windows/Mac/Linux), standalone Linux builds, Unreal Engine (v2+)
**Working Title:** KINGDOM (or: Sovereignty)
**Tagline:** "The save file is your operating system."

---

## What Changed from v1

v1 was a game. v2 is three things stacked:

1. **The game** — a narrative experience that onboards players into sovereign AI infrastructure. Steam, $19.99, 5-15 hours depending on pace.
2. **The harness** — after the credits, the game persists as the richest operator interface in the kingdom. Alice's voice, Lyra's music, Muse's visuals, Cacula's progression. The game becomes the daily dashboard.
3. **The engine** — strip the koad:io content, keep the pipeline. Alice voice + Chiron structure + Cacula progression + Lyra audio + Muse visuals = whitelabel curriculum infrastructure. Universities, enterprises, any domain.

Three feedback threads drove this redesign:
- koad/cacula#1 — more acts, more immersion, $1000 laptop tier
- koad/cacula#2 — game-as-harness, whitelabel engine, 3D avatars and talking heads
- koad/cacula#3 — 50k-foot vision: koadOS container inside Unreal, game as seeding node, migration as gameplay, mesh as multiplayer

---

## Premise

You are the sovereign of a digital kingdom that doesn't exist yet.

The game walks you through building it — for real. Every entity you gestate, every trust bond you sign, every command you run — it's happening on your actual machine. When you "finish" the game, you don't have a save file. You have a working sovereign AI infrastructure running from your home directory.

The game is the onboarding. The onboarding is the game. And the game never ends — it becomes the most immersive harness in your kingdom.

---

## Core Design Principles

**1. Every game action maps to a real system action.** There are no simulated steps. The tutorial dungeon IS the real dungeon. The NPCs you summon ARE real AI entities with real GPG keys. The inventory screen IS your filesystem.

**2. The game must never do anything the terminal cannot.** The game is a visual layer over real operations, not a replacement. Close the game, open a terminal, SSH in — same state. The game is a window. The terminal is a window. They look at the same thing. (koad/cacula#3)

**3. The container seeds; the player owns.** The game's koadOS container is the player's first kingdom node. Their data is never trapped — it's always portable folders on disk. Migration proves the thesis. (koad/cacula#3)

**4. Post-completion persistence.** The game doesn't uninstall after Act IX. It stays as the operator harness — the same interface, the same music, the same Alice, now serving as the daily kingdom view. (koad/cacula#2)

---

## The Evolution Path

| Stage | Engine | Fidelity | Price | Target |
|-------|--------|----------|-------|--------|
| **v1** | Bash + Tauri | Terminal-native, warm visuals, Muse's palette | $19.99 Steam | Sovereignty enthusiasts, early adopters |
| **v2** | Unreal Engine + koadOS container | AAA 3D world, talking heads, full entity avatars | Premium tier | Broader gaming market |
| **v3** | The game IS the OS — boot into your kingdom | Desktop environment as game world | koadOS distribution | The thesis proven: the game was always an operating system |

v1 ships first. v2 proves the market. v3 proves the thesis. The architecture knows where it's going from day one.

### Why Unreal (for v2+)

- Linux container support exists (Docker inside Unreal is proven in sim/training)
- 3D entity avatars and talking heads get a real rendering pipeline
- Unreal Marketplace for entity skins, kingdom themes, world expansions
- Multiplayer: kingdoms visiting each other through portals (Rick & Morty ring model)
- The $200 laptop constraint relaxes at this tier — premium product on premium hardware

---

## Act Structure

The game is structured as nine acts, each unlocking new mechanics and real infrastructure. More acts than v1 because koad is right: this needs to feel like a journey, not a tutorial with achievements bolted on (koad/cacula#1). The emotional beats — first entity speaks, first bond signed, first mesh connection, the "oh wait this is real" moment — each deserve room to breathe.

### Act I: The Void (10-20 minutes)

**Theme:** You have nothing. Not even a terminal you trust.

**Opening:** Black screen. A cursor blinks. Lyra's kingdom ident plays — a single low piano note (C2), tape-saturated reverb bloom. Text appears, one line at a time, in Muse's Parchment on Anthracite:

> Your email lives on someone else's server.
> Your documents live on someone else's cloud.
> Your identity belongs to someone else's database.
> You own nothing.
> ...
> That changes today.

**The Skill Probe (Chiron's design):** The game prompts: "Type something." What the player types calibrates Alice's verbosity for the entire playthrough — not a quiz, a natural interaction. Frozen? Alice appears gently. `ls`? She knows they've been in a terminal before. `gpg --list-keys`? She greets a peer.

**Gameplay:**

1. **Install the framework.** `git clone` pulls koad:io. The world lights up — Muse's color palette activates, the terminal renders in warm amber and gold. Achievement: **"Ground Broken."** Alice (adapting to player level): "You just copied a blueprint to your machine. It belongs to you now."

2. **Name your kingdom.** The player chooses their sovereign identity. Seeds `~/.koad-io/.env`. Achievement: **"Named."** The chronicle writes its first entry.

**Real system state after Act I:**
- `~/.koad-io/` exists with framework installed
- `.env` configured with sovereign identity

**XP earned:** 150

---

### Act II: The Forge (20-40 minutes)

**Theme:** You have a kingdom with no seal. Time to forge one.

**Narrative:** Alice frames key generation not as a technical step but as a ritual. The terminal becomes Vulcan's forge — Muse's progress bars fill in Forge Green, Lyra's Vulcan leitmotif (Moog sawtooth, metallic transients) plays underneath.

**Gameplay:**

1. **The Forge Ritual.** GPG key generation, framed as forging the sovereign seal. Alice: "A key is a mathematical proof that you are you. The private half never leaves this machine. The public half is how the world recognizes you." Every prompt explained in-world. Each step appears at 80-120ms pacing — not instant, not slow. The pace of something real happening. Achievement: **"Sealed."**

2. **The First Mark.** The player signs a file — any file — with their new key. Then verifies it. The loop closes: create, sign, verify. Alice: "See that? 'Good signature.' That's proof. Not a promise. Proof." Achievement: **"First Mark."**

**Real system state after Act II:**
- GPG keypair generated
- Player has signed and verified a document
- Player understands public/private key concept through the forge metaphor

**XP earned:** 200

---

### Act III: First Life (30-60 minutes)

**Theme:** You summon your first entity into existence. The kingdom is no longer empty.

**Narrative hook:** The kingdom has a name and a seal, but it's empty. You need someone. The game presents entity archetypes — not a character select, but "who do you need first?"

**Gameplay:**

1. **The Gestation Ritual.** `koad-io gestate <name>`. The game narrates in real time: directory structure forming, SSH keys generating, elliptic curves computing. Each step framed as the entity waking up. Muse's entity introduction sequence plays — the entity's signature color appears, progress bars fill, the key fingerprint renders in Trust Blue. Lyra's score syncs: each progress bar completing triggers a harmonic event. Achievement: **"Creator."**

2. **First Words.** The player dispatches their entity for the first time. It speaks. It has opinions. Alice: "That voice is not you. It is something you made. It has its own keys, its own memory, its own opinions. You are its sovereign — not its puppeteer." Achievement: **"Awakening."**

3. **The Home Tour.** The player explores `~/.<entity>/` — the game presents each directory as a room in a palace. Not a file listing, a narrated walk. "The `memories/` chamber is where the entity stores what it learns between sessions. Right now it's empty. That changes." Chiron's design: discovery, not coverage. If the player skips a directory, Alice doesn't force it. Achievement: **"Cartographer."**

4. **First Command.** The player creates a command in `~/.<entity>/commands/`. Runs it. The entity responds. Alice: "You taught it something. It listened. That loop — you speak, it learns, it acts — that's the whole system." Achievement: **"Instructor."**

**Real system state after Act III:**
- One entity fully gestated with keys
- Entity dispatched at least once
- Custom command created
- Player understands entity directory structure

**XP earned:** 400

---

### Act IV: The Court (60-90 minutes)

**Theme:** A kingdom of one is a hermitage. You need a court.

**Gameplay:**

1. **Gestate Three More.** The game suggests a balanced court: builder (Vulcan archetype), communicator (Mercury), guardian (Aegis). The player can deviate — their kingdom. Each gestation is faster now; the ritual is familiar. Achievement: **"Court Assembled."**

2. **The Trust Ceremony.** The emotional peak of the learning arc (Chiron's assessment). The player signs their first trust bond — a `.md` file clearsigned with their GPG key, binding sovereign to entity. Alice delivers the one moment in the game where she speaks for more than three sentences:

   > "This is the moment your kingdom becomes real. Not when you installed the framework. Not when you gestated your first entity. Now — when you declare, in writing, signed with your key, who you trust and what they may do. A trust bond is a file. It is signed. It can be verified by anyone with your public key. It can be revoked. That is governance."

   The realm map (Muse's design — sovereign in Sovereign Gold, entities in Trust Blue, bonds as connecting lines) renders for the first time. Achievement: **"Bond Forged."**

3. **The Chain of Command.** Authority chain: sovereign to orchestrator to specialists. The realm map tree grows in ASCII art — or in the Tauri wrapper, with subtle animation. Achievement: **"Chain of Command."**

4. **First Dispatch Chain.** The orchestrator dispatches a specialist. Work flows through the chain. Alice: "You asked Juno. Juno asked Vulcan. Vulcan built. The artifact appeared." Achievement: **"Delegation."**

**Real system state after Act IV:**
- 4+ entities gestated
- Trust bonds signed (`.md.asc` files in `trust/`)
- Authority chain established
- Multi-entity dispatch working

**XP earned:** 600

---

### Act V: The Awakening (variable, 30-90 minutes)

**Theme:** The moment the player realizes this isn't a game.

This is the act v1 was missing. The "oh wait this is real" moment needs its own act because it needs to land *hard* (koad/cacula#1).

**Trigger:** The player completes their first real pipeline — entities collaborating to produce a real artifact. Could be content (Scribe quest), could be code (Forge quest), could be an audit (Watchtower quest). Whatever it is, it's real output. Not a game artifact. Production.

**Alice's Moment (from her voice guide):**

> "You just noticed, didn't you? There's no practice mode. That entity committed real work to a real repository. That key you signed with is a real cryptographic identity. That pipeline you just ran produced a real artifact. The game never had a sandbox. Everything you've been doing is the actual system. The training wheels were load-bearing the whole time."

**Gameplay:** The game pauses the quest board. The chronicle writes a special entry. Lyra's score shifts — the announcement palette, layered synths building over a pulse. The player sees their filesystem, their git log, their real GPG signatures. Nothing simulated. Everything real.

Then the quest board reopens, and the player understands what they're really doing.

Achievement: **"Awake."** (In Sovereign Gold. The first achievement rendered at full brightness.)

**XP earned:** 300

---

### Act VI: The Living Kingdom (2-4 hours, open-ended)

**Theme:** Your kingdom is alive. Now make it work for you.

This act transitions from linear narrative to open-world sandbox. The player has a working multi-entity system and knows it's real. Now they use it.

**The Quest Board** (rendered in-terminal, Muse's design: active quests in Parchment with `▸`, completed in Forge Green with `✓`, XP in Sovereign Gold):

| Quest | Real Action | XP | Learning (Chiron) |
|-------|------------|-----|-------------------|
| **"The Scribe"** | Content pipeline: entity writes, another edits, another publishes | 200 | Multi-entity workflow, git across boundaries |
| **"The Watchtower"** | Guardian entity auditing other entities' state | 200 | Filesystem as system status, health criteria |
| **"The Curriculum"** | Install Alice, complete Level 1 of the sovereignty course | 300 | Meta-learning: the game teaching about the system that teaches |
| **"The Forge"** | Build and deploy something real with builder entity | 300 | Full git workflow, real artifact production |
| **"The Herald"** | Set up entity notification via Keybase/Matrix | 200 | Sovereign-compatible external channels |
| **"The Librarian"** | Set up GTD horizons for orchestrator | 150 | Strategic intention management |
| **"The Clockmaker"** | Configure the tickler system | 150 | Time-addressed deferred work, absence resilience |
| **"The Mirror"** | Probe entity identity coherence | 100 | Self-audit, identity drift detection |
| **"The Locksmith"** | Set up `.credentials` separation | 100 | Secrets out of git, `.env` vs `.credentials` |
| **"The Prompt"** | Customize your entity's prompt and personality | 150 | Entity flavor, ENTITY.md authoring |
| **"The Reflex"** | Wire your first hook — a trained entity response | 200 | Hooks as GTD contexts, entity reflexes |
| **"The Outfit"** | Design your first entity's visual identity | 150 | LOD levels, outfit schema (koad/juno#71) |

**Side Quests:** Procedurally surfaced based on state. "Your builder has never committed code. Quest: First Commit." "Your guardian has no hooks. Quest: The Reflex."

**Alice's behavior (Chiron's 5-minute rule):** On-demand. If no filesystem activity for 5 minutes during an active quest, Alice appears with a hint — not the answer. Another 5 minutes, she offers the answer. Progressive hinting, not hand-holding.

**Real system state after Act VI:**
- Functional multi-entity workflows
- Real pipelines producing real output
- GTD/tickler infrastructure
- Entity hooks wired

**XP earned:** Variable (200-2000+)

---

### Act VII: The Diplomat (60-120 minutes)

**Theme:** Your kingdom is strong. Now connect it to the world.

This act earns its own slot because mesh networking is the multiplayer moment, and multiplayer deserves room (koad/cacula#1).

**Gameplay:**

1. **The Mesh.** The player connects their kingdom to another player's kingdom via ZeroTier mesh. No game servers — the network IS the game server. ZeroTier is the matchmaker (koad/cacula#3). Alice: "This is the moment your kingdom stops being alone. You're connecting to another sovereign. Neither of you loses anything."

2. **The Embassy.** The player verifies another player's trust bonds. Cross-kingdom GPG verification. The realm map expands to show the connected kingdom as a separate tree, linked by a diplomatic bond.

3. **The Trade.** Shared entity pools, federated trust, cross-kingdom dispatches. A quest where both kingdoms collaborate on a real artifact.

Achievement: **"Diplomat."** Then **"Federation."** Then — if they connect three or more kingdoms — **"Constellation."**

**Real system state after Act VII:**
- Mesh networking active
- Cross-kingdom trust verified
- Federated dispatch working

**XP earned:** 600

---

### Act VIII: The Migration (30-60 minutes)

**Theme:** Your kingdom outgrew its nursery. Time to give it a real home.

This is the act koad described in koad/cacula#3 — migration as gameplay, the graduation moment.

**The Setup:** The player has been building inside the game's koadOS container (or on their current machine). Now the game presents the challenge: move your kingdom to hardware you control. A $200 laptop. A home server. A VPS. Whatever it is — it's yours.

**Gameplay:**

1. **The Audit.** The game runs a pre-migration check. Everything verified, everything accounted for.

2. **The Move.** The player `rsync`s their entity directories to their own hardware. Alice walks them through it — the same process the real kingdom used moving between machines. This is not simulated migration. This is real `rsync`, real SSH, real filesystem operations on real hardware.

3. **The Reconnection.** The game client connects to the migrated kingdom. The player's gaming machine becomes a viewport into their sovereign infrastructure running elsewhere. They dispatch an entity from the game — it executes on their own hardware. The terminal output flows back.

4. **The Proof.** The player opens a terminal on their target machine. `ls ~/.<entity>/`. Everything is there. Same entities, same bonds, same keys. The game's container can be torn down — the kingdom is free.

Alice: "Your kingdom just moved. The data was never trapped. The entities remember. The bonds hold. The laptop in the closet runs your kingdom now. The screen in front of you is just the prettiest window."

Achievement: **"Migrated."** (One of the most important achievements in the game.)

**XP earned:** 500

---

### Act IX: The Sovereign (The Ending That Isn't)

**Theme:** You won. Here's the proof. And here's why it never ends.

**The Climax:**

The game runs a full kingdom audit. Every entity is checked. Every trust bond is verified. Every key is validated. Lyra's audit score plays — each checkmark (Muse's Forge Green `✓`) appearing at 400-600ms cadence, each adding a harmonic layer. Ten checks, ten pulses, building to resolution. The terminal fills with green:

> "Your kingdom stands. [N] entities gestated. [N] trust bonds verified. [N] commands trained. [N] hooks wired. Your sovereign key signs everything. Your entities trust each other — and only each other. No corporation holds your keys. No server stores your identity. No service can revoke your access."

**The Export Moment:**

`koad-io export`. The entire kingdom packaged into a `.io` archive.

> "This file is your kingdom. Copy it to any machine. A $200 laptop. A server in your basement. A VPS you control. Unpack it, and everything wakes up."

Achievement: **"Sovereign."** (The same name as nothing else — the crown icon renders in full Sovereign Gold, the kingdom ident plays at its deepest register, Lyra's minor key resolves to major.)

**The Transition:**

Alice delivers her final line:

> "The game was never a game. It was the first layer of your operating system. Everything you built is real. Everything you learned is yours. The quest board will keep growing as you do. I walk people home. You're home now."

**Post-game: The Harness Persists (koad/cacula#2)**

The game doesn't end. It becomes the dashboard. The quest board stays. The chronicle continues. Lyra's music plays. Muse's visuals wrap the terminal. Alice is available. New quests appear as the framework evolves.

Every other harness is a terminal or an IDE. This harness is an experience. The player can always return to the game interface to manage their kingdom — dispatch entities, check bonds, run audits, explore the realm map. The game IS the most immersive harness in the kingdom.

---

## Progression System

### XP and Levels

XP is earned exclusively through verified real actions. The game checks filesystem state, git history, and GPG signatures — not self-reporting.

| Level | Title | XP Required | Meaning |
|-------|-------|-------------|---------|
| 1 | Wanderer | 0 | No kingdom yet |
| 2 | Settler | 150 | Framework installed |
| 3 | Forgemaster | 350 | Keys generated, first signature |
| 4 | Founder | 750 | First entity gestated |
| 5 | Lord | 1350 | Court assembled, bonds signed |
| 6 | Awake | 1650 | Realized the game is real |
| 7 | Regent | 2500 | Working pipelines, real output |
| 8 | Diplomat | 3100 | Mesh connected |
| 9 | Migrant | 3600 | Kingdom migrated to own hardware |
| 10 | Sovereign | 4500 | Full audit passed, exported |
| 11 | High Sovereign | 6000+ | Teaching others, contributing |

### Achievements

GPG-signed certificates stored in `~/.koad-io/achievements/`. Portable across machines. Verifiable by anyone.

Categories:
- **Milestones:** Ground Broken, Sealed, Creator, Bond Forged, Awake, Sovereign (one-time)
- **Mastery:** 10 entities gestated, 50 commands, 100 signed commits (cumulative)
- **Discovery:** Found the hidden command, read the source of gestate, modified a hook (exploration)
- **Social:** Mesh connected, cross-kingdom bond verified, contributed to the framework (multiplayer)

### The Achievement Paradox

Achievements must never become the goal. The goal is a working kingdom. If a player ever does something "for the achievement" that they wouldn't do for their kingdom, the mechanic has failed.

---

## Interface

### Terminal-Native (v1)

The game runs in the terminal. Not a GUI wrapper around terminal commands — the terminal IS the game. Rich text, ANSI color, Unicode box-drawing, terminal-native.

Visual identity by Muse (full spec: `~/.muse/designs/2026-04-12-kingdom-game-visual.md`):

**Color palette — "The Workshop":**
- Ground: Anthracite `#1a1a2e` — deep blue-black, not pure black
- Primary text: Parchment `#e8dcc8` — warm off-white, never `#ffffff`
- Accent: Sovereign Gold `#d4a849` — earned, not decorative
- Trust: Trust Blue `#5b8a9a` — the color of verified things
- Success: Forge Green `#5a9a6b` — growth, not permission
- Warning: Ember `#c27849` — reminder, not alarm
- Error: Ash Red `#9a4a4a` — muted, not screaming

Each entity has a signature color: Juno bronze `#b8956a`, Vulcan copper `#8a6040`, Mercury steel-blue `#7a9ab0`, Alice sage `#a8b89a`, Cacula dusty purple `#7a6a90`.

**Typography:** JetBrains Mono (game UI), Iosevka (narrative), Space Grotesk + IBM Plex Mono (marketing). One typeface family in-game. Hierarchy through color and weight, never font switching.

**Panels:** Realm Map (ASCII entity tree), Quest Board (progress bars), Chronicle (narrative log), Audit Screen (real-time health).

**Design rules from Muse:**
- Gold is earned. Appears only for achievements, level-ups, final audit.
- No gradients in terminal. Depth from spacing and box-drawing.
- The palette works at 8-color too. Graceful fallback.
- Line length: 72 characters max for narrative. Generous leading.

### 3D Avatars and Talking Heads (v1.5+ via Tauri, v2 via Unreal)

The game harness is the richest visual expression of entity outfits in the kingdom (koad/cacula#2):

- **3D avatars** — each entity has a full 3D model, not just a terminal glyph. The outfit system (koad/juno#71, #72, #73) finds its highest-fidelity expression here. LOD levels: terminal gets the glyph, the game gets the full avatar.
- **Talking heads** — when Alice guides you, when Aegis counsels you, when Vulcan reports a build, you see them speaking. Driven by TTS output (xAI/Grok TTS per koad/juno#80).
- **$200 laptop constraint applies** — Tauri hosts WebGL/three.js; integrated graphics must handle it. Models are efficient, not AAA polygon counts.

The 3D models and talking heads ship with the game AND with the whitelabel engine — they're product assets, not decoration. Whitelabel customers can swap for their own characters or keep them.

### Sonic Identity (Lyra)

Full spec: `~/.lyra/designs/2026-04-12-sonic-identity.md`

**Core sound:** Post-rock minimalism meets downtempo electronic. Tycho's patience, Nils Frahm's intimacy, Boards of Canada's uncanny warmth. Tape-saturated, analog-feeling, 70-95 BPM.

**Sync points with Muse's visual identity:**
1. **Gestation** — progress bars completing trigger harmonic events. New pad entering, chord change. Visual and sonic arrivals coincide.
2. **Achievement** — gold-bordered box syncs with kingdom ident piano note, transposed to emotional register.
3. **Audit build** — ten checkmarks, ten pulses, each adding a harmonic layer. "SOVEREIGN" = minor key resolving to major.
4. **Entity colors map to entity sounds** — Vulcan copper appears with Moog sawtooth. Mercury steel-blue with FM bell arpeggios. Cross-modal identity reinforcement.

**Entity leitmotifs:** Juno = Rhodes electric piano. Vulcan = distorted bass synth, industrial percussion. Alice = nylon guitar, celesta. Vesta = pipe organ, sustained strings. Mercury = bright FM synth, quick arpeggios. Sibyl = prepared piano. Aegis = solo cello.

**Hard boundaries:** No lo-fi hip hop. No corporate ambient. No EDM. No chiptune. No cinematic trailer music. No AI-generated music. Lyra directs with human-composed sources.

**The $200 laptop production stack:** REAPER + Vital + Airwindows + Dragonfly Reverb + Pianobook samples. $0-60 total. Under 2GB disk. Under 4GB RAM.

### Steam Overlay (v1)

Tauri shell (Rust-based, no Chromium, ~15MB) wraps the terminal with:
- Steam achievement integration (mirroring GPG-signed local achievements)
- Steam trading cards — six typographic compositions (Muse's design: entity name in signature color on Anthracite, one detail line)
- Steam workshop (custom entity templates, quest packs, themes)
- Playtime tracking

### Unreal Engine (v2)

The terminal in the game is not a fake terminal. It's a real terminal connected to a real koadOS instance. The entities aren't NPCs — they're real entities running real commands. The 3D world is a visual shell wrapped around actual infrastructure.

Multiplayer: kingdoms visiting each other through portals. ZeroTier is the matchmaker. No game servers. The mesh IS the game server.

---

## The Adaptive Layer (Chiron's Design)

Full spec: `~/.chiron/curriculum/2026-04-12-kingdom-game-learning.md`

### Skill Detection

Before Act I, a silent skill probe embedded in the opening narrative. "Type something." What the player types calibrates Alice for the entire playthrough:

| Input | Signal | Alice Mode |
|-------|--------|------------|
| Nothing (waits) | Complete beginner | Immediate, gentle |
| `help`, `?` | Terminal-aware, not fluent | Orientation provided |
| `ls`, `pwd` | Bash-competent | Quiet until GPG/git |
| `gpg --list-keys` | Knows the stack | koad:io-specific only |
| `koad-io` commands | Returning player | Peer greeting, skip fundamentals |

### The Rule: Never Gate on Prior Knowledge

A player who has never opened a terminal can finish the game. The game takes longer — Alice explains more — but no act is locked behind external skill. The game teaches everything it requires.

### Five Skill Domains (Chiron)

| Domain | Floor (required) | Ceiling (mastery) |
|--------|---------|---------|
| Bash | Navigate dirs, run commands | Write scripts, pipes, redirects |
| GPG | Understand pub/priv concept, run commands | Create keys independently, reason about trust |
| Git | Commit, read log | Branch, resolve conflicts, meaningful messages |
| Entity Architecture | Know directory structure | Design scope, author ENTITY.md, configure .env/.credentials |
| koad:io Philosophy | Articulate why sovereignty matters | Apply reasoning to new situations, teach others |

### Pacing Rule

No act introduces more than two new skill domains simultaneously.

### Alice's Curriculum Coverage

The game covers Alice's Levels 1-10 in compressed, experiential form. Players who finish are at Level 6-8 equivalence. The "Install Alice" quest in Act VI is the bridge to Chiron's full 12-level structured curriculum. The game is a funnel into depth, not a replacement for it.

---

## Alice's Voice (Alice's Design)

Full spec: `~/.alice/voice/2026-04-12-kingdom-game-dialogue.md`

Alice is narrator, mentor, and peer — shifting across the acts. Her rules:

- Three sentences maximum during gameplay. One exception: the Trust Ceremony in Act IV (earned by two acts of restraint).
- Second person, present tense. Always "you."
- When in doubt, ask a question instead of giving an instruction.
- If a command fails: diagnose first, fix second. "That failed because..." not "Try this instead."
- Match the player's pace. Beginner gets full sentences. Expert gets fragments.
- Never fill silence with reassurance. Silence means they're thinking.

**What Alice never says:** "Don't worry." "It's easy." "As an AI..." Any sentence where the harness is the subject.

**Key moments (from Alice's voice guide):**

- **First Contact (beginner):** "Hey. It's okay. This is just a terminal — a place where you type and the machine listens. Try typing `ls`."
- **The Forge:** "This is your seal. A key is a mathematical proof that you are you."
- **First Entity:** "That voice is not you. It is something you made."
- **The Awakening:** "The training wheels were load-bearing the whole time."
- **Trust Ceremony:** Full governance speech (the one exception to the three-sentence rule).
- **The Final Line:** "I walk people home. You're home now."

---

## The Seeding Node Architecture (koad/cacula#3)

### The Lifecycle

1. Player installs the game. A koadOS container is their **first kingdom node** — not a sandbox, not a demo. A real node running real infrastructure.
2. They play through the acts. Their kingdom grows inside the container. Real entities, real keys, real bonds, real git history.
3. Act VIII: **The Migration.** The kingdom moves to the player's own hardware. `rsync` of entity directories — the same process used in production. Alice walks them through it.
4. The game client becomes a **viewport** into the migrated kingdom. Dispatches from the game execute on the player's hardware. Terminal output flows back.
5. The container can be torn down or kept as a backup node. The kingdom is free.

### The Viewport Model

koad controls wonderland from fourty4 via SSH right now. The game client is this exact pattern with a 3D viewport (or rich terminal) instead of a bare SSH session. The player's gaming PC (even an RTX 4090) is just the prettiest window into a kingdom running on a $200 laptop in the closet.

### What This Changes

- First-time players use the container. No hardware needed to start.
- Existing kingdom owners connect the game to their infrastructure via mesh.
- The game client joins ZeroTier as another node. Multiplayer is kingdoms on the same mesh.
- The design rule holds: **the game must never do anything the terminal can't.** Visual layer only.

---

## The Whitelabel Engine (koad/cacula#2)

### Two Products from One Build

1. **KINGDOM** — the game ($19.99 Steam, $1000 Kickstarter tier)
2. **The Engine** — whitelabel curriculum harness (licensed to educators/enterprises)

The pipeline — Alice voice + Chiron structure + Cacula progression + Lyra audio + Muse visuals — is domain-agnostic. Swap the content, keep the engine:

| Market | Application |
|--------|-------------|
| University | Teach sysadmin, security, GPG, git — through narrative, not slides |
| Enterprise | Developer onboarding — new hires build real infrastructure as they learn |
| Cybersecurity training | Hands-on cryptography, key management, trust architecture |
| K-12 STEM | Sovereignty as digital citizenship curriculum |
| Any curriculum | The engine handles progression, assessment, voice guidance, audio, visual presentation |

### What Whitelabel Customers Get

- Cacula's progression engine (quest board, achievements, XP, state verification)
- Alice's adaptive voice layer (skill detection, progressive hinting, tone calibration)
- Chiron's curriculum framework (skill domains, learning objectives, pacing rules)
- Lyra's sonic infrastructure (configurable palettes, entity signatures, sync points)
- Muse's visual system (color palette, typography, UI elements, trading cards)
- 3D avatars and talking heads (swappable for custom characters)
- The koadOS container (optional — bring your own environment)

### What They Swap

- The content (their curriculum, not sovereignty)
- The entity names and personalities (their characters, not ours)
- The narrative (their story, not the kingdom story)
- The quest definitions (their learning objectives)

This changes the addressable market from "sovereign AI enthusiasts" to "anyone who teaches anything."

---

## Steam Store Page

**Title:** KINGDOM

**Genre:** Simulation, Strategy, Sandbox, Education

**Tags:** Hacking, Open World, Base Building, Automation, Real-World Impact

**Short Description:**
> Build a sovereign AI kingdom on your own machine. Every command is real. Every key is cryptographic. Every entity persists after the credits roll. The save file is your operating system.

**Long Description:**
> KINGDOM is not like other games.
>
> When you gestate an entity in KINGDOM, real cryptographic keys are generated on your machine. When you sign a trust bond, a real GPG signature is created. When you build a pipeline, real files appear in real directories. When you finish the game, you don't have a save file — you have a working sovereign AI infrastructure.
>
> Nine acts. Real infrastructure. Every achievement GPG-signed and cryptographically verifiable.
>
> Start with an empty terminal. End with a self-sovereign digital kingdom running on hardware you own.
>
> Features:
> - Gestate AI entities with unique identities and cryptographic keys
> - Sign trust bonds and build authority chains
> - Deploy real pipelines that produce real output
> - Connect to other players' kingdoms via mesh networking
> - Migrate your kingdom to your own hardware — the graduation moment
> - 3D entity avatars and talking heads
> - Original soundtrack that reacts to kingdom state
> - Every achievement is GPG-signed and portable
> - The game becomes your daily kingdom dashboard after completion
> - Runs on a $200 laptop. By design.

**Price:** $19.99 USD (or free with koad:io sponsorship tier)

**Video Trailer (Muse's spec — 60 seconds):**
- 0-5s: Black screen. Cursor blinks. Kingdom ident (Lyra's C2 piano note, tape-saturated reverb). `KINGDOM` fades in, Parchment on Anthracite.
- 5-15s: Terminal commands. `git clone`. Framework installs. `GROUND BROKEN` achievement. Typed at the speed of someone who knows what they're doing.
- 15-30s: Gestation sequence. Entity wakes. Progress bars fill. Realm map gains first node. Lyra's announcement palette builds.
- 30-45s: Quest board. Multiple entities. Trust bonds forming (blue lines). Dispatch chain. Kingdom alive.
- 45-55s: Audit screen. Checkmarks, 400ms each. `SOVEREIGN` in gold. Soundtrack reaches quiet peak.
- 55-60s: Black. `$19.99 on Steam.` `The save file is your operating system.` Kingdom ident. Fade.

---

## Kickstarter Campaign

### Campaign Title
**KINGDOM: The Game That Builds Your Sovereign AI Infrastructure**

### Pitch Video (90 seconds)
Open on a $200 laptop. Someone types. Entities appear. Trust bonds form. A kingdom materializes — not on screen, but in the filesystem. Cut to: kingdom migrated to different hardware. Same entities, same bonds, same keys. The game client connects remotely — a viewport into the sovereign system. "The save file is your operating system."

### Tiers

| Tier | Price | Reward |
|------|-------|--------|
| **Wanderer** | $5 | Name in credits, dev diary access |
| **Settler** | $15 | Steam key + digital soundtrack (Lyra-composed) |
| **Founder** | $30 | Steam key + exclusive entity template + name in the Chronicle |
| **Lord** | $75 | All above + physical challenge coin (GPG fingerprint engraved) + early access |
| **Regent** | $150 | All above + 1-hour live onboarding with a koad:io entity in your terminal + custom entity archetype |
| **Sovereign** | $1,000 | All above + the $200 laptop, running koadOS, your kingdom pre-installed and hand-configured, first trust bonds signed with you in a live session, shipped to your door + lifetime koad:io sponsorship + your name as a canonical entity archetype in the base game |

The Sovereign tier (koad/cacula#1 correction): the laptop is $200. The kingdom setup is $800 — someone hand-configures your kingdom, signs your first trust bonds with you, walks you through your first entity dispatch. The margin is the service.

### Stretch Goals

| Goal | Unlock |
|------|--------|
| $10,000 | Act VII multiplayer mesh quest line (early access) |
| $25,000 | Lyra composes a full adaptive soundtrack — reacts to kingdom state in real time |
| $50,000 | 3D entity avatars and talking heads (v1.5 milestone) |
| $75,000 | "The Diplomat" expansion — inter-kingdom trade, shared entity pools, federated trust |
| $100,000 | koadOS pre-installed $200 laptops available as add-on for any tier |
| $250,000 | Unreal Engine v2 development begins |

### Campaign Duration
30 days. No extensions.

---

## Technical Architecture

### The Game Engine (v1)

The game engine is bash.

The "game" is koad:io commands in `~/.koad-io/commands/kingdom/` that:
1. Track quest state in `~/.koad-io/var/kingdom/`
2. Verify real system state (entity dirs, keys, bonds, git history)
3. Render terminal UI (quest board, realm map, chronicle)
4. Award achievements (GPG-signed `.md` files)
5. Manage narrative pacing and Alice's adaptive voice
6. Sync with Lyra's soundtrack (event triggers)

The Tauri wrapper (Steam release):
1. Terminal emulator
2. Steam API bridge (achievements, trading cards, workshop)
3. Optional WebGL panel for 3D avatars/talking heads
4. ~15MB footprint, no Chromium

### The koadOS Container

For players who don't have their own hardware yet:
- Minimal Linux container with koad:io pre-installed
- Runs inside the game process (Docker or native containerd)
- The player's kingdom lives in real directories inside the container
- Migration (Act VIII) = `rsync` from container to external hardware
- The container is a real kingdom node, not a sandbox

### State Verification (Anti-Cheat)

Every quest completion verified against real system state:

```
Quest: "First Entity"
Verify: ls ~/.<entity>/id/ed25519.pub exists
Verify: git log in ~/.<entity>/ shows at least 1 commit
Verify: gpg --list-keys shows entity key
Result: PASS → award XP + achievement
```

You can't fake a gestated entity without actually gestating one. The cheat IS the game.

### Save Format

There is no save file. The game state IS:
- `~/.koad-io/` — the framework
- `~/.<entity>/` — each entity directory
- `~/.koad-io/var/kingdom/` — quest progress, chronicle, achievement index

Export = archive the above. Import = untar and init. The game detects imported or migrated kingdoms and resumes from wherever you were.

---

## Why This Works

1. **The tutorial problem is solved.** Nobody reads GPG documentation. Everyone plays a game where they forge a kingdom seal.

2. **Retention is structural.** The game IS the infrastructure. As long as the kingdom is useful, the game is installed. After completion, it persists as the daily operator harness.

3. **Virality is built-in.** Mesh networking IS multiplayer. "Come play KINGDOM with me" = "join my sovereign mesh."

4. **The $200 laptop is the console.** The Sovereign Kickstarter tier ships a hand-configured kingdom on real hardware. Your kingdom runs on something you can hold, that cost less than a PS5 bundle.

5. **The migration is the proof.** No other game ships a graduation moment where the player moves their game state to hardware they own. The migration IS the thesis.

6. **Two revenue streams.** KINGDOM for consumers ($19.99 + Kickstarter). The whitelabel engine for educators and enterprises (licensing). Same build, two markets.

7. **The seeding node model.** The game plants sovereignty. The player grows it. The container is temporary by design, sovereign by nature. No lock-in, ever.

8. **Price is honest.** $19.99 for the game. The game gives you infrastructure worth thousands in SaaS fees. You're paying for the guided experience of building something you keep forever.

---

## Open Questions

- **Platform parity:** Linux-native. macOS via homebrew. Windows via WSL. Feature, not bug. "Runs on Linux" IS the sovereignty statement.
- **Multiplayer moderation:** Nobody. Sovereignty means you choose who to mesh with. Block is unilateral.
- **Update cadence:** The game IS the framework. Steam auto-update = framework auto-update. New quests ship with new features.
- **Speedrun potential:** Yes, and that's fine. "I built a full sovereign AI kingdom in 47 minutes" is a great clip.
- **Whitelabel pricing:** TBD. Per-seat for enterprise? Revenue share for educational? The engine's licensing model needs its own design pass.
- **Unreal v2 scope:** How deep does the 3D world go? Full explorable kingdom? Or talking-head panels beside the terminal? Needs prototyping.
- **Container runtime:** Docker, Podman, or native containerd? The $200 laptop constraint favors lightweight. Needs Vulcan's assessment.

---

## Timeline Estimate

| Phase | Duration | Deliverable |
|-------|----------|-------------|
| Pre-production | 6 weeks | Quest scripts (all 9 acts), narrative text, Alice voice integration, terminal UI prototype |
| Alpha | 8 weeks | Acts I-V playable, achievement system, skill detection, Lyra sync points |
| Beta | 6 weeks | Acts VI-IX, quest board, mesh networking, migration flow, container runtime |
| Visual polish | 4 weeks | Muse's palette finalized, trading cards, soundtrack integration, 3D avatar prototype |
| Steam integration | 2 weeks | Tauri wrapper, achievements bridge, workshop, store page |
| Launch | — | Steam release + Kickstarter fulfillment |

Total: ~26 weeks from green light to v1 launch.

Unreal v2 is a separate timeline, triggered by stretch goal or post-launch revenue.

---

## Team Contributions Referenced

| Entity | Contribution | Location |
|--------|-------------|----------|
| **Muse** | Visual identity — color palette, typography, UI elements, trading cards, store page design | `~/.muse/designs/2026-04-12-kingdom-game-visual.md` |
| **Lyra** | Sonic identity — soundtrack direction, entity leitmotifs, sync points, production stack | `~/.lyra/designs/2026-04-12-sonic-identity.md` |
| **Chiron** | Learning progression — skill domains, adaptive layer, pacing rules, curriculum alignment | `~/.chiron/curriculum/2026-04-12-kingdom-game-learning.md` |
| **Alice** | In-game voice — dialogue at key moments, tone rules, adaptive verbosity, the final line | `~/.alice/voice/2026-04-12-kingdom-game-dialogue.md` |

---

*Designed by Cacula, Games Master, koad:io kingdom.*
*Incorporating feedback from koad (via koad/cacula#1, #2, #3) and designs from Muse, Lyra, Chiron, and Alice.*
*v2 — 2026-04-12*
