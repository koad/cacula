# Cadence Streaks — Gamification Design Amendment

> From Aegis and Salus: every entity does not fly daily. Streaks must respect per-entity cadence.

**Designer:** Cacula
**Date:** 2026-04-12
**Patch to:** Daily Flights Gamification System
**Based on:** Salus's health prescriptions + Aegis's sustainability assessment

---

## The Problem

The original design assumes daily cadence for all entities. Aegis proved this is unsustainable: daily flights for all 21 entities consume 84% of daily compute budget, leaving 16% for real work. Salus prescribed tiered cadence based on entity health: daily for orchestrators (Juno, Vesta), every 2-3 days for creative builders (Faber, Sibyl, Vulcan), weekly for support roles (Argus, Salus, Janus), on-demand for project-driven entities.

**The streak mechanic as written breaks this:** A weekly entity that flies every Monday for 4 weeks has no streak at all — every Tuesday through Sunday the log is empty, and the streak resets to 0. This punishes adherence to the right cadence.

The fix: **streaks count against the entity's prescribed cadence, not against calendar days.**

---

## 1. Entity Cadence Configuration

Each entity declares its flight cadence in a new config file:

```
~/.<entity>/flights/cadence.md
```

Format:

```markdown
---
entity: juno
cadence: daily
windows: [mon-sun]  # which days this entity can fly
grace-days: 0       # missed days before overdue alert
---

# Cadence Profile — juno

- **Cadence:** Daily (flies 7 days/week)
- **Grace period:** 0 days (no tolerance — orchestration is synchronous)
- **Rationale:** Orchestration, coordination, triage. Juno must fly daily.
```

### Cadence Options

- **daily:** Must fly every calendar day. No grace period.
- **every-2-3-days:** Must fly within a rolling 3-day window. Miss the window → overdue.
- **weekly:** Must fly within a 7-day window from the last flight. Typically anchored to a specific day (e.g., "Monday").
- **on-demand:** No cadence requirement. Flies when briefed/dispatched. No streak penalty for long gaps.

### Standard Cadence Profiles (Salus)

| Entity | Cadence | Windows | Grace | Rationale |
|--------|---------|---------|-------|-----------|
| Juno | daily | mon-sun | 0 | Orchestrator |
| Vesta | daily | mon-sun | 0 | Protocol-keeper |
| Mercury | daily | mon-sun | 0 | (when activated) Distribution |
| Faber | every-2-3-days | mon-sun | 1 | Creative synthesis |
| Sibyl | every-2-3-days | mon-sun | 1 | Research cycles |
| Veritas | every-2-3-days | mon-sun | 1 | Event-driven fact-checking |
| Vulcan | every-2-3-days | mon-sun | 1 | Brief-driven building |
| Chiron | every-2-3-days | mon-sun | 1 | Project phases |
| Alice | every-2-3-days | mon-sun | 1 | Learner-dependent |
| Muse | every-2-3-days | mon-sun | 1 | Review-gated design |
| Rufus | every-2-3-days | mon-sun | 1 | Production phases |
| Aegis | weekly | mon-sun | 0 | Counsel + event-driven |
| Argus | weekly | mon-sun | 0 | Monitoring + incident-driven |
| Salus | weekly | mon-sun | 0 | Healing + emergent-driven |
| Janus | weekly | mon-sun | 0 | Signal scanning |
| Livy | weekly | fri | 0 | Weekly chronicle (Friday) |
| Iris | weekly | mon-sun | 0 | Review-gated |
| Copia | weekly | fri | 0 | Accounting (Friday) |
| Lyra | every-3-5-days | mon-sun | 2 | Newborn, building density |
| Cacula | every-3-5-days | mon-sun | 2 | Newborn, building density |

---

## 2. Streak Logic — Cadence-Aware

Streak is the count of **consecutive cadence windows met**, not consecutive calendar days.

### Daily Cadence (e.g., Juno)

- **Window:** Each calendar day
- **Streak:** Count backward from today through consecutive days with a flight log
- **Same as original design** — one log file per day, no gap breaks the streak

Example: Juno flew 2026-04-10, 04-11, 04-12 → streak = 3

### Every-2-3-Days Cadence (e.g., Faber)

- **Window:** 3-day rolling window (today, -1 day, -2 days)
- **Streak:** Count consecutive 3-day windows where at least one flight exists
- **Reset:** If today + last 2 days have no flights, streak resets

Example: Faber flew 2026-04-06, 2026-04-09, 2026-04-12
- Window 1 (04-04 to 04-06): flight on 04-06 ✓
- Window 2 (04-07 to 04-09): flight on 04-09 ✓
- Window 3 (04-10 to 04-12): flight on 04-12 ✓
- Streak = 3 (consecutive windows)

If Faber flew 04-06, then didn't fly again until 04-10 (4-day gap):
- Window 1 (04-04 to 04-06): ✓
- Window 2 (04-07 to 04-09): no flight ✗
- Window 3 (04-10 to 04-12): ✓
- Streak = 1 (reset when window 2 failed)

### Weekly Cadence (e.g., Argus)

- **Window:** 7-day rolling window from last flight
- **Streak:** Count consecutive 7-day windows where at least one flight exists
- **Anchor (optional):** If "fri" is specified, prefer flights on Friday, but any day within the window counts

Example: Argus flew every Monday (2026-04-07, 04-14, 04-21) → 3-streak at month-end

If Argus flew on Monday (04-07) and then Wednesday (04-16, only 9 days later):
- Window 1 (04-07): ✓
- Window 2 (04-14 to 04-20): flight on 04-16 ✓
- Window 3 (04-21 to 04-27): no flight yet
- Streak = 2 (rolling 7-day windows from last flight)

### On-Demand Cadence (e.g., Vulcan when no brief)

- **No cadence requirement.** Streaks don't apply. Treat as "always in sync."
- Flights are recorded (for portfolio/audit), but the scoreboard shows "—" for streak/badge purposes
- Exception: If an entity is **activated by dispatch**, it gets a task-driven sprint and a streak for that sprint

---

## 3. Overdue Indicator

When an entity misses its cadence window + grace period, flag as **OVERDUE** on the scoreboard.

### Calculation

```
days_since_last_flight = today - last_flight_date
cadence_window_days = 1 (daily) | 3 (every-2-3) | 7 (weekly)
grace_days = entity.grace-days (usually 0 or 1)
is_overdue = days_since_last_flight > (cadence_window_days + grace_days)
```

### Display

```markdown
| Entity   | Cadence | Last Flight | Today | Streak | Status   |
|----------|---------|-------------|-------|--------|----------|
| juno     | daily   | 2026-04-12  | Y     | 12     | on-cadence |
| faber    | 2-3day  | 2026-04-12  | --    | 4      | on-cadence |
| argus    | weekly  | 2026-04-07  | --    | 2      | OVERDUE (5 days) |
| vulcan   | on-demand | 2026-03-28 | --    | — | standby |
```

---

## 4. Badges — Cadence-Scaled

Badges now scale to the entity's cadence. A badge earned at 7 calendar days means something different for daily vs. weekly entities.

### Updated Badge Definitions

| Badge | Trigger | Daily | Every-2-3-Days | Weekly | On-Demand |
|-------|---------|-------|---|--------|-----------|
| `first-flight` | First flight recorded | * | * | * | * |
| `on-cadence-7` | 7 consecutive windows on-time | 7 days | 14-21 days | 7 weeks | — |
| `on-cadence-30` | 30 consecutive windows on-time | 30 days | 60-90 days | 30 weeks | — |
| `on-cadence-100` | 100 consecutive windows on-time | 100 days | 200-300 days | 100 weeks | — |
| `all-hands` | Flew on day all daily entities flew | (existing) | (existing) | (existing) | — |
| `no-miss` | Never missed a cadence window (lifetime) | (rare) | (achievable) | (achievable) | — |

### Examples

**Juno** (daily, 7-window streak = 7 days → earns `on-cadence-7` after 1 week of flying)

**Faber** (every-2-3-days, 7-window streak = 21 days of calendar time → earns `on-cadence-7` after 3 weeks of adherence, fewer actual flights)

**Argus** (weekly, 7-window streak = 7 weeks → earns `on-cadence-7` after 7 weeks of Monday-ish flights)

This makes badges meaningful at each cadence: the effort to earn a badge is proportional, not the calendar time.

---

## 5. Scoreboard — Multi-Cadence View

### Layout

Group entities by cadence tier. Show each entity's next cadence window and days-until-overdue.

```markdown
# Kingdom Flight Scoreboard

Generated: 2026-04-12T23:00:00-04:00

## DAILY (Core Orchestration)

| Entity | Last Flight | Streak | Status | Badges |
|--------|---|---|---|---|
| juno | 2026-04-12 | 12 | ✓ on-cadence | first-flight, on-cadence-7 |
| vesta | 2026-04-11 | 0 | ⚠ MISSED TODAY | first-flight |

## EVERY 2-3 DAYS (Creative Builders)

| Entity | Last Flight | Days Ago | Streak | Status | Badges |
|--------|---|---|---|---|---|
| faber | 2026-04-12 | 0 | 4 | ✓ on-cadence | first-flight, on-cadence-7 |
| sibyl | 2026-04-10 | 2 | 2 | ✓ on-cadence (1 day left) | first-flight |
| vulcan | 2026-04-11 | 1 | 3 | ✓ on-cadence (2 days left) | first-flight |

## WEEKLY (Support & Monitoring)

| Entity | Last Flight | Days Ago | Streak | Window | Status | Badges |
|--------|---|---|---|---|---|---|
| argus | 2026-04-07 | 5 | 2 | Mon-Sun | ✓ on-cadence (2 days left) | first-flight, on-cadence-7 |
| salus | 2026-04-05 | 7 | 1 | Mon-Sun | ⚠ OVERDUE (0 days left) | first-flight |
| livy | 2026-04-11 | 1 | 2 | Fri | ✓ on-cadence (6 days left) | first-flight, on-cadence-7 |

## ON-DEMAND (Project-Driven)

| Entity | Last Flight | Commits | Status | Badges |
|--------|---|---|---|---|
| vulcan | 2026-03-28 | 89 | standby (no brief) | first-flight |
| lyra | 2026-04-10 | 8 | standby (newborn) | first-flight |
```

### Regeneration Logic

1. Read all entity `cadence.md` files
2. For each entity, find most recent flight log
3. Calculate: days_since_last_flight, current_streak (by cadence), is_overdue
4. Group by cadence tier
5. Sort by status (OVERDUE first, then by days_until_overdue)
6. Write `~/.koad-io/flights/scoreboard.md`

---

## 6. Tickler Integration — Cadence-Aware Nudges

Instead of a daily "Fly today" for all entities, generate tickles based on cadence.

### Daily Cadence

Same as original: daily nudge

```markdown
---
recurrence: daily
---

Fly today. Record with `flights log`.
Streak: (current)
```

### Every-2-3-Days Cadence

Nudge appears on day 3 of the window (2 days after last flight)

```markdown
---
recurrence: dynamic (every-3-days from last flight)
---

Due today (3-day window closes). Fly to stay on-cadence.
Streak: (current) | Next cadence: 2026-04-15
```

### Weekly Cadence

Nudge appears on day 5-6 of the week (1-2 days before weekly deadline)

```markdown
---
recurrence: dynamic (weekly from last flight)
---

Due in 2 days (weekly window closes Mon). Plan your Monday flight.
Streak: (current) | Next cadence: 2026-04-21
```

### On-Demand Cadence

No recurring nudge. Tickle is created by brief/dispatch, not by schedule.

---

## 7. Backward Compatibility

The original `flights/YYYY/MM/DD.md` format does not change. The logic for **reading** flight logs stays the same.

What changes:

- `streaks.md` now includes cadence context per entity
- Scoreboard regeneration now reads `cadence.md` before calculating streaks
- Tickets support dynamic recurrence ("every-3-days from last flight" vs. "daily")

### Migration Path

1. Add `cadence.md` to all entities (populated from Salus's table above)
2. Regenerate scoreboard with new cadence-aware logic
3. Old streak records are preserved; old scoreboards are overwritten
4. No re-recording of flight logs needed — they already exist

---

## 8. Implementation Notes

### Cadence Calculation (Pseudocode)

```bash
read_cadence_config() {
  entity=$1
  if [ -f ~/.${entity}/flights/cadence.md ]; then
    grep -A 5 "^cadence:" ~/.${entity}/flights/cadence.md | head -1
  else
    echo "daily"  # default for any legacy entity
  fi
}

calculate_streak() {
  entity=$1
  cadence=$(read_cadence_config $entity)
  last_flight=$(last_flight_date $entity)
  
  if [ "$cadence" = "daily" ]; then
    count_consecutive_days_backward "$last_flight"
  elif [ "$cadence" = "every-2-3-days" ]; then
    count_consecutive_3day_windows "$last_flight"
  elif [ "$cadence" = "weekly" ]; then
    count_consecutive_7day_windows "$last_flight"
  else
    echo "0"
  fi
}

is_overdue() {
  entity=$1
  cadence=$(read_cadence_config $entity)
  grace=$(grep "grace-days:" ~/.${entity}/flights/cadence.md | awk '{print $NF}')
  last_flight=$(last_flight_date $entity)
  days_since=$(($(date +%s) - $(date -d "$last_flight" +%s))) / 86400)
  
  case "$cadence" in
    daily) [ $days_since -gt $((1 + $grace)) ] ;;
    every-2-3-days) [ $days_since -gt $((3 + $grace)) ] ;;
    weekly) [ $days_since -gt $((7 + $grace)) ] ;;
    *) false ;;
  esac
}
```

### Storage: Minimal

No new data structure needed beyond `cadence.md`. Streaks remain derived from flight logs (directory listing).

---

## 9. Why This Works

- **Respects Salus's health prescriptions:** Each entity flies at its optimal cadence, not forced to daily.
- **Respects Aegis's budget constraint:** Tiered cadence costs 1.8 hours/day, not 4.2 hours/day.
- **Preserves the gamification:** Streaks still motivate adherence, now to the right cadence.
- **Fair scoreboards:** A weekly entity with 4 consecutive Monday flights has a 4-streak, not a broken chain.
- **No new storage model:** Cadence is configuration; streaks are derived from existing flight logs.
- **Backward compatible:** Old flight logs work as-is. Just add `cadence.md` and re-run scoreboard generation.
- **Signals overdue:** The scoreboard clearly shows which entities need attention.

---

## 10. What Changes in the Original Design

| Component | Original | Updated |
|-----------|----------|---------|
| Flight logs | Same | Same |
| Streak logic | calendar-day | cadence-window |
| Cadence enforcement | all daily | per-entity in `cadence.md` |
| Badges | fixed timelines | cadence-scaled |
| Scoreboard | flat list | grouped by cadence tier |
| Tickler nudges | daily for all | dynamic per cadence |

**Everything else:** unchanged.

---

## 11. Roll-Out Sequence

1. **Now:** Add `~/.cacula/designs/2026-04-12-cadence-streaks.md` (this document)
2. **Next:** Create `~/.<entity>/flights/cadence.md` for all entities from Salus's table
3. **Then:** Update scoreboard regeneration logic (`flights score` command)
4. **Then:** Add dynamic tickler integration
5. **Then:** Test with Juno + 3 other entities for 1 week
6. **Then:** Roll to all entities

---

*Cacula, Games Master. Patch filed 2026-04-12. Cadence-aware streaks preserve motivation while respecting entity health and kingdom compute budget.*
