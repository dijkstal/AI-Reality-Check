# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **static, zero-dependency web application** for an AI Readiness Assessment tool ("AI Readiness Scan") built for Polestar Company. The tool helps Dutch-speaking organizational leaders assess their AI maturity through a guided questionnaire and delivers a scored profile result. All content is in Dutch (Nederlands).

There is no build process, no package manager, no test suite, and no CI/CD pipeline. To "run" the app, open any `index.html` in a browser.

## Repository Structure

Three self-contained versions exist side by side:

| Path | Version | Key changes |
|------|---------|-------------|
| `index.html` | v1 | Original 12-question "AI Reality Check" |
| `v2/index.html` | v2 | Renamed to "AI Readiness Scan", 6 dimensions, reorganized |
| `v3/index.html` | v3 | 18 questions (3/dimension), equal weighting, NIS2 compliance focus — **current/canonical** |

Each `index.html` is fully self-contained: HTML structure, all CSS (inline `<style>`), and all JavaScript (inline `<script>`) in a single file. There is no external dependency, no API call, and no persistent state.

## Architecture: Single-File SPA Pattern

Each version follows the same internal architecture:

**Data layer (top of `<script>`):**
- `QS[]` — question objects `{ dim, q }` mapping each question to a dimension index
- `ANS[]` — 5-point Likert scale labels
- `PROFILES[]` — maturity profile definitions `{ name, color, range, desc, actions }`
- `DIM_LABELS[]`, `DIM_DESCS[]` — dimension metadata

**Screen flow:**
```
Landing page  →  [Start scan]  →  Dimension intro overlay
                                         ↓
                               Question screens (one at a time)
                                         ↓
                               [Lead capture modal]  →  Results screen
```

Screen visibility is toggled via CSS class manipulation (`showScreen(id)`). There is no router.

**Scoring pipeline (`calcScore(ans)`):**
1. Average the 3 answers per dimension → 6 dimension scores
2. Average the 6 dimension scores → overall score
3. Apply threshold caps (v3 logic):
   - `Urgentie ≤ 2.0` → maximum profile capped at *Zoekend*
   - `Visie ≤ 2.0` or `Compliance ≤ 2.0` → maximum profile capped at *Aftastend*
4. Match overall score to a `PROFILES[]` entry by `range`

**Gauge visualization:**
- SVG semicircular gauge built by `buildGaugeSVG()` at runtime
- 60 thin arc segments create a smooth gradient across 6 color stops (one per maturity profile)
- Needle position is animated via `animateGauge()` using an easing function

## v3 Dimensions & Profiles (Current)

**6 Dimensions** (3 questions each, indices 0–5):
0. Visie — AI vision & ownership
1. Urgentie — sector disruption readiness
2. Compliance — data governance, EU AI Act, NIS2
3. Actiebereidheid — organizational willingness to change
4. Executie — identifying & running AI use cases
5. Opschaling — scaling pilots to production

**5 Maturity Profiles** (ascending score):
1. De Onwetende Organisatie — 1.0–2.0 (red)
2. De Zoekende Organisatie — 2.1–2.8 (amber)
3. De Aftastende Organisatie — 2.9–3.5 (yellow)
4. De Startklare Organisatie — 3.6–4.2 (light green)
5. De Versnellende Organisatie — 4.3–5.0 (dark green)

## Key Conventions

**Making content changes:** Edit the data arrays at the top of the `<script>` block. Questions, answer labels, profile descriptions, and dimension text are all declared there — not scattered through the HTML.

**Adding a new version:** Copy the latest `v3/index.html` into a new `v4/` directory alongside a copy of `logo.svg`. Versions are never modified after release; new development always goes into a new version directory.

**Styling:** All styles are in the inline `<style>` block. CSS custom properties (`:root` variables) define the color palette and spacing tokens. Use `clamp()` for typography to maintain responsive scaling.

**Lead capture:** Uses a `mailto:` link assembled in `submitLead()` — there is no backend. The recipient address is hardcoded in that function.

**Social sharing:** `shareLI()` opens a LinkedIn share URL; `shareEmail()` opens a `mailto:`; `copyLink()` writes to the clipboard. All three are wired to buttons in the results screen.
