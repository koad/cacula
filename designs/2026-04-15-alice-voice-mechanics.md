---
title: Alice Voice Mechanics — Unlock or Constant?
author: cacula
date: 2026-04-15
version: 1
status: design-direction
cross-refs:
  - juno#80 (Muse voice design)
  - ~/.muse/designs/alice-voice-design-v1.md (Muse's design, fca7e7e)
  - cacula flight: cacula-20260415T055429
---

# Alice Voice Mechanics — Unlock or Constant?

## Verdict: Single Voice. Tonal Events, Not Voice Tiers.

Do not use voice as an unlock reward. Keep one canonical Alice voice throughout the learner's entire journey. Use Muse's already-specified tonal modes as event triggers — not as unlocks, as *expressions* of earned moments.

---

## The Mechanic Argument

Voice is intimacy. The learner builds a relationship with Alice over weeks of real work. Mid-journey voice changes would break that relationship, not reward it. Imagine a therapist who sounds different once you've made progress — the change signals discontinuity, not graduation. The learner would feel: *something shifted*, not *I earned this*.

Progression mechanics earn trust when the reward reinforces what was actually done. Leveling up in Alice's course means: you understood a hard concept, you said it in your own words, you moved forward. The reward for that is the next level opening — not a new voice.

**The cost side closes the argument.** Each additional trained XTTS-v2 model = additional reference recording, training run, file maintenance, serving overhead. That compute and maintenance cost is only justified if the payoff is significant. A voice that plays once at graduation, then disappears, does not justify multiple models.

One model. One Alice. Forever.

---

## What Voice-Adjacent Mechanics *Can* Do

Muse already designed tonal modes for four lesson states:

| Mode | Trigger |
|------|---------|
| Onboarding / greeting | First session, new device |
| Active lesson | Level in progress |
| Gentle correction | Wrong answer event |
| Milestone / celebratory | Level complete event |

These are not unlocks. They are not earned. They are *expressions* — Alice responds to the moment the way a present teacher does. Cacula does not need to gate them; they fire on real events automatically.

**What Cacula does own:** the events that trigger them.

| XP Event | Trigger | Voice Mode |
|----------|---------|------------|
| Level complete (any) | `level:complete` | Milestone/celebratory |
| Belt milestone (3, 6, 9, 12) | `belt:milestone` | Milestone/celebratory + pause duration extended |
| Wrong answer (3 in a row) | `error:streak:3` | Gentle correction |
| Session start (fresh day) | `session:start:new_day` | Onboarding/greeting variant |
| Course complete | `course:complete` | Milestone/celebratory — full weight |

The graduation milestone (`course:complete`) gets the celebratory tonal mode at maximum weight. That is already in Muse's spec. Cacula co-owns the event label; Vulcan fires it; Muse's voice mode is already designed for it.

**No new models needed.** One canonical Alice voice. Tonal modes handle all the expressiveness the mechanic needs.

---

## What Muse Needs

Muse's question was: *"Should XTTS-v2 produce one model or several?"*

**Answer: One model.**

Train once on the chosen reference recording. Serve that model for all lesson states. The tonal modes Muse already specified (pace, warmth register, pause duration) are achieved through speech synthesis parameters and SSML-like control signals — not separate model weights.

If Kokoro's parameter API supports speed, pitch envelope, and pause control: those are the dials. If XTTS-v2 export does not expose them natively, Muse should design the per-mode parameter delta table (e.g., `speed: 0.92, pause_after_sentence: +0.4s`) for Vulcan to apply at call time.

---

## What Vulcan Needs

No mechanic implementation beyond the event system Vulcan already needs for XP tracking:

- Fire `level:complete`, `belt:milestone`, `course:complete`, `error:streak:3`, `session:start:new_day` as game events
- Pass the event label to the TTS call so Kokoro/XTTS-v2 applies the correct tonal mode parameters
- No branching voice model logic — one model, one parameter set per mode

---

## Open Questions for Juno

1. **Belt milestone pacing.** At Belt 3, 6, 9, 12 — should the celebratory voice event be longer (more pause, more weight)? Or consistent across all milestones? This is a feel question; I lean toward increasing weight at each belt, maxing at graduation.

2. **Session greeting.** The `session:start:new_day` trigger would give Alice a brief "you're back" opening tone on first message of a new day. Is that too frequent to feel special, or exactly the right daily reward signal?

3. **Sponsorship surface.** Sponsors cannot buy a different Alice voice — that violates sovereign identity. But could a sponsor's learners get an earlier reveal of the Phase 2 XTTS-v2 voice (i.e., they hear the trained voice while Phase 1 learners hear the preset)? That is cosmetic prestige, not power. Worth exploring if Phase 2 has a staged rollout.

---

## Summary

| Decision | Choice |
|----------|--------|
| Voice unlock tiers? | No |
| Number of XTTS-v2 models | One canonical Alice voice |
| Tonal variation | Yes — event-driven via existing Muse modes |
| New mechanic complexity | Low — event labels on existing XP events |
| Compute cost | Minimal — no multi-model overhead |

---

*Cacula, 2026-04-15. Responding to Muse's flag in alice-voice-design-v1.md. Mechanics design, not implementation.*
