# Daily Flights — Kingdom Gamification System

> Every entity flies daily. The muscle is the point.

**Designer:** Cacula
**Date:** 2026-04-12
**Scope:** Small-game — daily habit loop for entity dispatches
**Constraint:** Filesystem-native, git-trackable, tickler-compatible

---

## 1. The Flight Log

### Location

Each entity records its own flights:

```
~/.<entity>/flights/
  2026/
    04/
      12.md
      13.md
```

One file per day the entity flew. No file = no flight. The absence is the signal.

### Format

```markdown
# Flight Log — 2026-04-12

entity: juno
host: thinker
dispatched: 2026-04-12T09:14:00-04:00

## Sorties

- 09:14 — session start, tickler scan, 3 issues triaged
- 11:42 — dispatched mercury for copy kit brief
- 14:30 — ARCHITECTURE/ field report on hook flavors

## Commits

- c4f3fbf comms: receive Mercury copy kit brief
- 26fe9e7 tickler: close 40000x benchmark tickle

## Summary

3 sorties, 2 commits
```

### Recording Mechanism

A post-session hook writes the flight log. Minimum viable entry:

```markdown
# Flight Log — 2026-04-12

entity: juno
dispatched: 2026-04-12T09:14:00-04:00

## Commits

- c4f3fbf comms: receive Mercury copy kit brief
```

If the entity was dispatched and produced at least one commit, it flew. The hook runs `git log --since="midnight" --oneline` to populate the commits section. Zero commits but a dispatch still counts as a flight — showing up is flying.

---

## 2. The Kingdom Scoreboard

### Location

```
~/.koad-io/flights/
  scoreboard.md        # current state — regenerated
  streaks.md           # streak records per entity
  history/
    2026-04-12.md      # daily kingdom-wide summary
```

The scoreboard lives in the framework directory because it spans all entities. It is regenerated (not hand-edited) by a kingdom-level command.

### scoreboard.md — Current State

```markdown
# Kingdom Flight Scoreboard

Generated: 2026-04-12T23:00:00-04:00

| Entity   | Today | Streak | Best Streak | Total Flights | Badges        |
|----------|-------|--------|-------------|---------------|---------------|
| juno     |  Y    |   12   |     12      |      12       | first-flight, weekly |
| mercury  |  Y    |    7   |      7      |       9       | first-flight, weekly |
| vesta    |  --   |    0   |      5      |       8       |               |
| cacula   |  Y    |    1   |      1      |       1       | first-flight  |
```

### streaks.md — Streak Ledger

```markdown
# Streak Records

## juno
current: 12 (2026-04-01 — present)
best: 12

## mercury
current: 7 (2026-04-06 — present)
best: 7
```

### Daily History

`history/2026-04-12.md` — snapshot of who flew that day:

```markdown
# Kingdom Flights — 2026-04-12

Flew: juno, mercury, cacula, faber, vulcan (5/21)
Grounded: vesta, alice, sibyl, ... (16/21)
```

---

## 3. Streaks

Simple rules:

- **Streak increments** when the entity has a flight log file for today.
- **Streak resets to 0** when a day passes with no flight log file.
- **Weekends count.** Every day is a flight day. The muscle is the point.
- **Grace:** none. Miss a day, streak resets. This is the game.

Streak state is derived, not stored. The `flights/YYYY/MM/` directory IS the streak data. Count consecutive `.md` files backward from today. No separate counter to corrupt.

---

## 4. Badges

Badges are earned, never lost. Stored per-entity:

```
~/.<entity>/flights/badges.md
```

### Badge Definitions

| Badge | Trigger | Icon |
|-------|---------|------|
| `first-flight` | First flight log ever recorded | * |
| `weekly` | 7-day streak | ** |
| `monthly` | 30-day streak | *** |
| `centurion` | 100-day streak | **** |
| `ten-commits` | 10 total commits across all flights | + |
| `hundred-commits` | 100 total commits across all flights | ++ |
| `thousand-commits` | 1000 total commits across all flights | +++ |
| `all-hands` | Flew on a day when every entity flew | @ |
| `dawn-patrol` | Flight log before 06:00 local | ^ |

### badges.md Format

```markdown
# Flight Badges — juno

- first-flight (2026-04-01)
- weekly (2026-04-07)
```

Append-only. Date records when the badge was earned. Simple grep to check if already awarded.

---

## 5. The Command

```
~/.koad-io/commands/flights/
  command.sh           # main entry point
  PRIMER.md            # what this command does
```

### Usage

```bash
# As any entity:
juno flights           # show juno's flight status
flights                # show kingdom scoreboard (framework-level)

# Internally:
flights log            # record today's flight for $ENTITY
flights score          # regenerate scoreboard from all entity logs
flights streak         # show current entity streak
flights badges         # check and award new badges
```

### `flights log` — Recording a Flight

1. Determine `$ENTITY` from environment
2. Create `~/.<entity>/flights/YYYY/MM/DD.md`
3. Populate with `git log --since="midnight" --oneline` from entity repo
4. Run `flights badges` to check for new awards

### `flights score` — Regenerating Scoreboard

1. Walk all entity dirs matching `~/.<entity>/ENTITY.md`
2. For each, check if `flights/YYYY/MM/DD.md` exists for today
3. Count streak backward from today
4. Read `flights/badges.md`
5. Write `~/.koad-io/flights/scoreboard.md`
6. Write `~/.koad-io/flights/history/YYYY-MM-DD.md`

---

## 6. Tickler Integration

### Daily Flight Reminder

Each entity that opts in gets a recurring tickle:

```
~/.<entity>/tickler/time/YYYY/days/MM/DD/fly.md
```

Content:

```markdown
---
recurrence: daily
---

Fly today. Record your flight with `flights log`.
Current streak: (calculated at scan time)
```

The tickler scan surfaces this at session start. The entity sees: "Fly today." That's the nudge.

### Scoreboard Tickle (Juno only)

Juno gets a nightly tickle to regenerate the scoreboard:

```markdown
---
recurrence: daily
---

Run `flights score` to update the kingdom scoreboard.
```

---

## 7. Hook Integration

The cleanest path: a post-session hook that auto-records the flight.

```
~/.<entity>/hooks/post-session/flights.sh
```

```bash
#!/usr/bin/env bash
# Record today's flight automatically after any session

ENTITY_DIR="$HOME/.${ENTITY}"
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
FLIGHT_DIR="${ENTITY_DIR}/flights/${YEAR}/${MONTH}"
FLIGHT_FILE="${FLIGHT_DIR}/${DAY}.md"

# Don't double-record
[ -f "$FLIGHT_FILE" ] && exit 0

mkdir -p "$FLIGHT_DIR"

COMMITS=$(cd "$ENTITY_DIR" && git log --since="midnight" --oneline 2>/dev/null)
TIMESTAMP=$(date -Iseconds)

cat > "$FLIGHT_FILE" <<EOF
# Flight Log — $(date +%Y-%m-%d)

entity: ${ENTITY}
dispatched: ${TIMESTAMP}

## Commits

${COMMITS:-"(no commits today)"}
EOF

# Stage and commit the flight log
cd "$ENTITY_DIR"
git add "flights/${YEAR}/${MONTH}/${DAY}.md"
git commit -m "flights: log $(date +%Y-%m-%d)" --no-edit 2>/dev/null
```

---

## 8. Why This Works

- **No database.** Files on disk. `ls` is your query engine.
- **No service.** A shell script and a tickler nudge.
- **Git-native.** Flight logs commit into entity repos. The scoreboard commits into koad-io. History is `git log`.
- **Streak is derived.** Count backward from today through consecutive day files. No counter to drift.
- **Badges are append-only.** Check existence with grep. Award with echo. Done.
- **Tickler nudges, hooks record.** The entity doesn't have to remember. The system remembers for it.
- **Scales to 1 or 100 entities.** Walk `~/.*/.entity/ENTITY.md`, check for flight files.
- **Absence is free.** No flight file = no flight. No penalty beyond streak reset. No notifications pile up.

---

## 9. Implementation Sequence

1. **Now:** Define the format (this document).
2. **Next:** Create `~/.koad-io/commands/flights/command.sh` with `log` and `score` subcommands.
3. **Then:** Add `hooks/post-session/flights.sh` to Juno as dogfood.
4. **Then:** Roll to team entities via template.
5. **Then:** Add tickler tickles for daily nudges.
6. **Someday:** Feed flight data into KINGDOM game progression (Act II territory).
