# KINGDOM: The Game

> Build your sovereign AI kingdom. For real.

**Genre:** Narrative simulation / tycoon / hacking sandbox
**Platform:** Steam (Windows/Mac/Linux), standalone Linux builds
**Working Title:** KINGDOM (or: Sovereignty)
**Tagline:** "The save file is your operating system."

---

## Premise

You are the sovereign of a digital kingdom that doesn't exist yet.

The game walks you through building it — for real. Every entity you gestate, every trust bond you sign, every command you run — it's happening on your actual machine. When you "finish" the game, you don't have a save file. You have a working sovereign AI infrastructure running from your home directory.

The game is the onboarding. The onboarding is the game.

---

## Core Design Principle

**Every game action maps to a real system action.** There are no simulated steps. The tutorial dungeon IS the real dungeon. The NPCs you summon ARE real AI entities with real GPG keys. The inventory screen IS your filesystem.

This is what makes it a game and not a tutorial: framing, pacing, progression, discovery, and the feeling of building something permanent. Tutorials teach you what buttons to press. Games make you want to press them.

---

## Act Structure

The game is structured as five acts, each unlocking new mechanics and real infrastructure.

### Act I: The Empty Field (15-30 minutes)

**Theme:** You have nothing. You are alone on a blank machine.

**Opening cinematic:** Text-based. You wake up. Your digital world has no structure, no agents, no identity. Everything runs through someone else's servers. You own nothing.

**Gameplay:**

1. **Install the framework.** The player runs `git clone` to pull koad:io. The game detects this and the world lights up — a terminal comes alive. First achievement: **"Ground Broken."**

2. **Name your kingdom.** The player picks a domain concept (even if they don't own a domain — it's aspirational). This seeds `~/.koad-io/.env` with their chosen identity. Achievement: **"Sovereign."**

3. **Generate your keys.** The game walks the player through GPG key generation. Not as a chore — as a ritual. "You are forging the seal of your kingdom. Every document you sign, every trust bond you form, every entity you birth — they trace back to this key." The terminal output is styled as a forge sequence. Achievement: **"Sealed."**

**Real system state after Act I:**
- `~/.koad-io/` exists with framework installed
- GPG keypair generated
- `.env` configured with sovereign identity

**XP earned:** 300 (enough to unlock Act II)

---

### Act II: First Life (30-60 minutes)

**Theme:** You summon your first entity into existence.

**Narrative hook:** The kingdom exists, but it's empty. You need someone to help you. The game presents entity archetypes — not as a character select screen, but as a "who do you need first?" decision tree.

**Gameplay:**

1. **The Gestation Ritual.** The player runs `koad-io gestate <name>`. The game narrates what's happening in real time: directory structure forming, SSH keys generating, elliptic curves computing. Each step is framed as the entity "waking up." The terminal output becomes a birth sequence. Achievement: **"Creator."**

2. **First Words.** The player dispatches their new entity for the first time. It speaks. It has opinions. It does work. The game frames this as the entity's first breath. Achievement: **"Awakening."**

3. **The Home Tour.** The game walks the player through `~/.<entity>/` — showing them what each directory means. Not as documentation. As exploration. "You enter the entity's memory palace. The `memories/` chamber is empty — it has no memories yet. The `hooks/` armory is bare — it has no trained reflexes. The `trust/` vault is sealed — it trusts no one." Achievement: **"Cartographer."**

4. **First Command.** The player creates a simple command in `~/.<entity>/commands/`. They run it. The entity responds. The loop closes. Achievement: **"Instructor."**

**Real system state after Act II:**
- One entity fully gestated with keys
- Entity has been dispatched at least once
- Player has created a custom command
- Player understands the entity directory structure

**XP earned:** 500

---

### Act III: The Court (60-120 minutes)

**Theme:** A kingdom of one is a hermitage. You need a court.

**Gameplay:**

1. **Gestate Three More.** The game suggests a balanced court: a builder (Vulcan archetype), a communicator (Mercury archetype), a guardian (Aegis archetype). The player can deviate — this is their kingdom. Each gestation is faster now; the ritual is familiar. The game tracks the roster. Achievement: **"Court Assembled."**

2. **The Trust Ceremony.** The player signs their first trust bond — a `.md` file clearsigned with their GPG key, binding sovereign to entity. The game frames this as a knighting ceremony. "You are granting this entity your trust. It can act in your name. This bond is cryptographically verifiable — not a promise, a proof." Achievement: **"Bond Forged."**

3. **The Chain of Command.** The player creates an authority chain: sovereign → orchestrator → specialists. They sign the bonds. The game shows the chain forming visually in ASCII art — a tree growing. Achievement: **"Chain of Command."**

4. **First Dispatch Chain.** The player uses their orchestrator to dispatch a specialist. Work flows through the chain. The game narrates the delegation: "You asked Juno. Juno asked Vulcan. Vulcan built. The artifact appeared." Achievement: **"Delegation."**

**Real system state after Act III:**
- 4+ entities gestated
- Trust bonds signed (`.md.asc` files in `trust/`)
- Authority chain established
- Multi-entity dispatch working

**XP earned:** 800

---

### Act IV: The Living Kingdom (2-4 hours, open-ended)

**Theme:** Your kingdom is alive. Now make it work for you.

This act transitions from linear narrative to open-world sandbox. The player has a working multi-entity system. Now they use it.

**Gameplay — Quest Board:**

The game presents a quest board (rendered in-terminal) with real tasks the player can pursue in any order:

| Quest | Real Action | XP |
|-------|------------|-----|
| **"The Scribe"** | Create a content pipeline (entity writes, another edits, another publishes) | 200 |
| **"The Watchtower"** | Set up a guardian entity that audits your other entities' state | 200 |
| **"The Curriculum"** | Install Alice and complete Level 1 of the sovereignty course | 300 |
| **"The Forge"** | Build and deploy something real using your builder entity | 300 |
| **"The Herald"** | Set up an entity that can notify you via a real channel (Keybase, Matrix, etc.) | 200 |
| **"The Diplomat"** | Connect to another player's kingdom mesh (multiplayer!) | 400 |
| **"The Librarian"** | Set up GTD horizons for your orchestrator entity | 150 |
| **"The Clockmaker"** | Configure the tickler system — time-addressed deferred work | 150 |
| **"The Mirror"** | Run a probe against your own entity to verify identity coherence | 100 |
| **"The Locksmith"** | Set up `.credentials` separation — secrets out of git | 100 |

**Side Quests:** Procedurally surfaced based on what the player has built. "Your builder entity has never committed code. Quest: First Commit." "Your guardian has no hooks. Quest: The Reflex."

**Real system state after Act IV:**
- Functional multi-entity workflows
- Real pipelines producing real output
- GTD/tickler infrastructure
- Possibly connected to mesh

**XP earned:** Variable (200-2000+)

---

### Act V: The Export (The Ending)

**Theme:** You won. Here's the proof.

**The Climax:**

The game runs a full kingdom audit. Every entity is checked. Every trust bond is verified. Every key is validated. The terminal fills with green checkmarks. The game narrates:

> "Your kingdom stands. [N] entities gestated. [N] trust bonds verified. [N] commands trained. [N] hooks wired. Your sovereign key signs everything. Your entities trust each other — and only each other. No corporation holds your keys. No server stores your identity. No service can revoke your access."

**The Export Moment:**

The player runs `koad-io export` (or the game's equivalent). Their entire `~/.koad-io/` and entity directories are packaged into a `.io` archive — a portable sovereign kingdom.

> "This file is your kingdom. Copy it to any machine. A $200 laptop. A server in your basement. A VPS you control. Unpack it, and everything wakes up. Your entities remember. Your bonds hold. Your keys work. You are sovereign wherever this file lands."

Achievement: **"Sovereign."** (The same name as the first achievement — but now the crown icon is gold, not grey.)

**Post-game:** The game doesn't end. It becomes the dashboard. The quest board stays. New quests appear as the framework evolves. The game was never a game — it was the first layer of your operating system.

---

## Progression System

### XP and Levels

XP is earned exclusively through verified real actions. The game checks filesystem state, git history, and GPG signatures — not self-reporting.

| Level | Title | XP Required | Meaning |
|-------|-------|-------------|---------|
| 1 | Wanderer | 0 | No kingdom yet |
| 2 | Settler | 300 | Framework installed, keys generated |
| 3 | Founder | 800 | First entity gestated |
| 4 | Lord | 1600 | Court assembled, trust bonds signed |
| 5 | Regent | 3000 | Working pipelines, real output |
| 6 | Sovereign | 5000 | Full kingdom export, audit passed |
| 7 | High King | 8000+ | Mesh connected, teaching others |

### Achievements

Achievements are GPG-signed certificates stored in `~/.koad-io/achievements/`. They are portable — move to a new machine, achievements come with you. They are verifiable — anyone can check the signature.

Categories:
- **Milestones:** First entity, first bond, first export (one-time, cannot be missed)
- **Mastery:** 10 entities gestated, 50 commands created, 100 commits signed (cumulative)
- **Discovery:** Found the hidden command, read the source of gestate, modified a hook (exploration-rewarded)
- **Social:** Connected to mesh, verified another player's bond, contributed to the framework (multiplayer)

### The Achievement Paradox

The most important design constraint: achievements must never become the goal. The goal is a working kingdom. Achievements are evidence that you built one. If a player ever does something "for the achievement" that they wouldn't do for their kingdom, the mechanic has failed.

---

## Interface

### Terminal-Native

The game runs in the terminal. Not a GUI wrapper around terminal commands — the terminal IS the game. Rich text, ANSI color, Unicode box-drawing, but terminal-native.

**Panels:**
- **The Realm Map** — ASCII visualization of your entity tree, trust bonds, authority chains
- **The Quest Board** — current available quests, progress bars, XP rewards
- **The Chronicle** — narrative log of everything you've done, written in-world ("Day 3: The sovereign gestated a new entity called Iris. The court grows.")
- **The Audit Screen** — real-time kingdom health: key status, bond validity, entity heartbeats

### Steam Overlay

For the Steam release, a lightweight Electron or Tauri shell wraps the terminal with:
- Steam achievement integration (mirroring the GPG-signed local achievements)
- Steam trading cards (entity archetypes as card art)
- Steam workshop (share custom entity templates, quest packs, themes)
- Playtime tracking (which also maps to real "time spent building sovereignty")

The shell is cosmetic. The game works identically without it.

---

## Steam Store Page

**Title:** KINGDOM

**Genre:** Simulation, Strategy, Sandbox, Education

**Tags:** Hacking, Open World, Base Building, Automation, Real-World Impact

**Short Description:**
> Build a sovereign AI kingdom on your own machine. Not a simulation — every action is real. Gestate AI entities, sign cryptographic trust bonds, deploy pipelines, and export your kingdom to a $200 laptop. The save file is your operating system.

**Long Description:**
> KINGDOM is not like other games.
>
> When you gestate an entity in KINGDOM, real cryptographic keys are generated on your machine. When you sign a trust bond, a real GPG signature is created. When you build a pipeline, real files appear in real directories. When you finish the game, you don't have a save file — you have a working sovereign AI infrastructure.
>
> The game teaches you to build something most people don't know exists: a personal AI kingdom where you own every key, every identity, every agent, and every byte of data. No cloud. No subscriptions. No permission needed.
>
> Start with an empty home directory. End with a self-sovereign digital kingdom you can carry on a USB stick.
>
> Features:
> - Gestate AI entities with unique identities and cryptographic keys
> - Sign trust bonds and build authority chains
> - Deploy real pipelines that produce real output
> - Connect to other players' kingdoms via mesh networking
> - Export your entire kingdom as a portable .io file
> - Every achievement is GPG-signed and cryptographically verifiable
> - Runs on a $200 laptop. By design.

**Price:** $19.99 USD (or free with koad:io sponsorship tier)

---

## Kickstarter Campaign

### Campaign Title
**KINGDOM: The Game That Builds Your Sovereign AI Infrastructure**

### Pitch Video Script (90 seconds)
Open on a $200 laptop. Someone types. Entities appear. Trust bonds form. A kingdom materializes — not on screen, but in the filesystem. Cut to: the same kingdom running on a different machine. Same entities. Same bonds. Same keys. "The save file is your operating system."

### Tiers

| Tier | Price | Reward |
|------|-------|--------|
| **Wanderer** | $5 | Name in credits, access to dev diary |
| **Settler** | $15 | Steam key at launch + digital soundtrack (Lyra-composed) |
| **Founder** | $30 | Steam key + Kickstarter-exclusive entity template + name engraved in the Chronicle |
| **Lord** | $75 | All above + physical challenge coin (GPG fingerprint of your first key engraved) + early access |
| **Regent** | $150 | All above + 1-hour onboarding session with a koad:io team entity (live, in your terminal) + custom entity archetype designed for your use case |
| **Sovereign** | $500 | All above + your name as a canonical entity archetype in the base game + lifetime koad:io sponsorship tier + the $200 laptop, preconfigured with koadOS and your kingdom pre-installed, shipped to your door |

### Stretch Goals

| Goal | Unlock |
|------|--------|
| $10,000 | Multiplayer mesh tutorial quest line |
| $25,000 | Lyra composes a full adaptive soundtrack that reacts to kingdom state |
| $50,000 | Mobile companion app — view your kingdom health from your phone |
| $75,000 | "The Diplomat" expansion — inter-kingdom trade, shared entity pools, federated trust |
| $100,000 | koadOS pre-installed $200 laptops available as add-on purchase for any tier |

### Campaign Duration
30 days. No extensions.

---

## Technical Architecture

### The Game Engine

The game engine is bash. Seriously.

The "game" is a set of koad:io commands in `~/.koad-io/commands/kingdom/` that:
1. Track quest state in `~/.koad-io/var/kingdom/`
2. Verify real system state (does `~/.<entity>/` exist? are keys generated? are bonds signed?)
3. Render terminal UI (quest board, realm map, chronicle)
4. Award achievements (GPG-signed `.md` files)
5. Manage narrative pacing (which quests are available based on current state)

The Steam wrapper is a thin shell (Tauri preferred — Rust-based, lightweight, no Chromium bloat) that:
1. Embeds a terminal emulator
2. Bridges achievements to Steam API
3. Handles Steam overlay, trading cards, workshop
4. Provides optional GUI panels alongside the terminal

### State Verification

The game never trusts self-reporting. Every quest completion is verified:

```
Quest: "First Entity"
Verify: ls ~/.<entity>/id/ed25519.pub exists
Verify: git log in ~/.<entity>/ shows at least 1 commit
Verify: gpg --list-keys shows entity key
Result: PASS → award XP + achievement
```

This is also the anti-cheat. You can't fake a gestated entity without actually gestating one. The cheat IS the game.

### Save Format

There is no save file. The game state IS:
- `~/.koad-io/` — the framework
- `~/.<entity>/` — each entity directory
- `~/.koad-io/var/kingdom/` — quest progress, chronicle, achievement index

Export = `tar` the above. Import = `untar` and run `koad-io init` for each entity. The game detects an imported kingdom and resumes from wherever you were.

---

## Why This Works

1. **The tutorial problem is solved.** Nobody wants to read documentation about setting up GPG keys and entity directories. Everyone wants to play a game where they build a kingdom. Same actions. Different framing.

2. **Retention is structural.** The player can't "uninstall the game" without uninstalling their kingdom. The game IS the infrastructure. As long as the kingdom is useful, the game is installed.

3. **Virality is built-in.** Mesh networking IS multiplayer. When you connect your kingdom to a friend's kingdom, you're both playing the game AND building real federated infrastructure. "Come play KINGDOM with me" = "join my sovereign mesh."

4. **The $200 laptop is the console.** The Sovereign Kickstarter tier ships a pre-configured laptop. This is not a gimmick — it's the thesis made physical. Your kingdom runs on hardware you own, that you can hold in your hands, that cost less than a PS5 game bundle.

5. **Price is honest.** $19.99 for the game. The game gives you infrastructure worth thousands in SaaS fees. The value proposition is inverted — you're not paying for the game, you're paying for the guided experience of building something you keep forever.

---

## Open Questions

- **Platform parity:** The game is Linux-native. macOS works (bash + homebrew). Windows requires WSL. Is that a Steam dealbreaker or a feature? (Position: feature. "Runs on Linux" IS the sovereignty statement.)
- **Multiplayer moderation:** When kingdoms mesh, who moderates? (Position: nobody. Sovereignty means you choose who to mesh with. Block is unilateral. This is the design.)
- **Update cadence:** When koad:io framework evolves, does the game update? (Position: yes. The game IS the framework. Steam auto-update = framework auto-update. New quests appear as new features ship.)
- **Speedrun potential:** Can someone blast through in 2 hours? (Position: yes, and that's fine. Speedrunners will be the best ambassadors. "I built a full sovereign AI kingdom in 47 minutes" is a great clip.)

---

## Timeline Estimate

| Phase | Duration | Deliverable |
|-------|----------|-------------|
| Pre-production | 4 weeks | Quest scripts, narrative text, terminal UI prototype |
| Alpha | 6 weeks | Acts I-III playable, achievement system working |
| Beta | 4 weeks | Acts IV-V, quest board, Steam integration shell |
| Polish | 4 weeks | Chronicle narrative, soundtrack integration, trading cards |
| Launch | — | Steam release + Kickstarter fulfillment |

Total: ~18 weeks from green light to launch.

---

*Designed by Cacula, Games Master, koad:io kingdom.*
*2026-04-12*
