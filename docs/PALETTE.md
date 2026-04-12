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
| background    | 217–221°     |
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

Saturation between **~19% (backgrounds)** and **~55% (accents)**. Above that the theme loses sobriety; below it loses the nebula texture.

### 3. L as the only degree of freedom for states

Hover, selection, and dim variants are derived by changing **only L**. H and S do not change to express state — only lightness varies.

---

## Background stack

The six tones share H≈219° and S≈21% (±2%) — only L changes meaningfully. The L progression (10→67%) is a spatial depth gradient: from the darkness of the void to a readable foreground.

```
bg_dark   #141820  H=220 S=23% L=10%  ← borders, inactive windows
bg        #1a1f28  H=219 S=21% L=13%  ← main background
bg_float  #232936  H=221 S=21% L=17%  ← cursor line, popups
sel       #323c4d  H=218 S=21% L=25%  ← selection, prominent borders
fg_dim    #5f7090  H=219 S=21% L=47%  ← comments, dimmed text
fg        #99a7be  H=217 S=22% L=67%  ← main foreground, operators
```

The small H (±2°) and S (±2%) variations are rounding artifacts of the hex approximation, not intentional design decisions — the system targets a uniform L gradient.
