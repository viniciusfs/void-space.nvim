# void-space palette

> Source of truth for visual identity and color decisions.
> Every highlight group must reference a color from `lua/void-space/palettes/default.lua`.

---

## Identity

void-space is not a derivative of vim-deep-space. deep-space is a historical starting point; color decisions are driven by the current aesthetic intent, not by fidelity to the predecessor.

**Concept:** deep space with nebula texture. The universe is not a uniform void — it is ionized gas, stellar dust, density gradients. The colors reflect this: their hue and saturation are chosen to evoke that texture without being aggressive.

**Mood:** vivid but sober. Colors that distinguish themselves with functional clarity, but never shout. Visual comfort is a requirement — the developer spends hours looking at this theme.

**Core principle:** intentional low contrast. Visual hierarchy emerges from lightness and hue differences, not from value clashes. No pure white, no pure black.

---

## HSL Principles

All colors are specified in HSL. Three rules must be followed in any palette:

### 1. H fixed per semantic role

Each color has an owning hue. Blue is always ~214–220°, purple ~256°, cyan ~187°, red ~356°, etc. Changing a color's hue changes its identity — avoid this in variants.

| Role          | Approximate H |
|---------------|--------------|
| background    | 218–221°     |
| red           | 356°         |
| green         | 116°         |
| yellow        | 42°          |
| blue          | 214°         |
| purple        | 256°         |
| cyan          | 187°         |
| orange        | 18°          |
| pink          | 297°         |
| bright_yellow | 35°          |

### 2. S kept in range

Saturation between **~19% (backgrounds)** and **~52% (accents)**. Above that the theme loses sobriety; below it loses the nebula texture.

### 3. L as the only degree of freedom for states

Hover, selection, and dim variants are derived by changing **only L**. H and S do not change to express state — only lightness varies.
