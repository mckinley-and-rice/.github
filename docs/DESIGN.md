# Design

한국어: [DESIGN.ko.md](./DESIGN.ko.md)

The canonical source of these values is the shipping stylesheet of our own site,
`redrob-labs/app/globals.css`. Everything below is transcribed from it, not remembered.

**Transcribe, never retype from memory.** A remembered near-value (`#2440ff` where the
canonical is `#2b52ff`) looks almost right on one surface and visibly wrong beside another.
When you need a token, open the canonical file and copy the value.

## The two channels

Two themes come off one pair of channels rather than two palettes.

- `--ink` is whatever writes on the page.
- `--paper` is the page itself.

They are stored as space-separated RGB components so a tint keeps its meaning when the two
swap: `rgb(var(--ink) / 0.5)` is "half-strength text" in both themes. Anything that is dark
in both themes, such as a terminal card, keeps its own literal colors and does not use these.

## Tokens

| Token | Light | Dark |
|---|---|---|
| `--ink` | `10 10 10` | `237 237 235` |
| `--paper` | `255 255 255` | `13 13 15` |
| `--background` | `#ffffff` | `#0d0d0f` |
| `--foreground` | `#0a0a0a` | `#ededeb` |
| `--muted` | `#6b7280` | `#9b9ba4` |
| `--accent` | `#0a0a0a` | `#ededeb` |
| `--surface` | `#f9f8f6` | `#16161a` |
| `--surface-veil` | `rgb(249 248 246 / 0.92)` | `rgb(22 22 26 / 0.92)` |
| `--code-bg` | `#f4f4f5` | `#17171a` |
| `--pill-border` | `#d5d9e2` | `#33333c` |
| `--border` | `rgb(var(--ink) / 0.08)` | same expression |
| `--shadow` | `15 23 42` | `0 0 0` |

**The accent is monochrome.** It is `--foreground` in both themes. Blue appears in the logo
artwork and nowhere else. There is no brand-colored button, and adding one is a brand
decision, not a component decision.

**`--muted` is a text color, not a surface.** This is the opposite of the shadcn convention,
where `--muted` is a surface and `--muted-foreground` is the text on it. If you import a
shadcn component or token set into one of our trees, reconcile that first: redefining
`--muted` as a surface turns every label using it into white text on white.

Dark mode responds to `prefers-color-scheme` and to an explicit `data-theme` attribute, and
the explicit attribute wins. Ship both paths, so a user override works.

## Type

```css
--font-sans: "Pretendard", "Apple SD Gothic Neo", "Noto Sans KR", sans-serif;
--font-mono: "IBM Plex Mono", "SFMono-Regular", Menlo, Consolas, monospace;
```

Pretendard ships as a variable font (`PretendardVariable.woff2`, weight axis `45 920`) with
`font-display: swap`. It covers Latin and Korean in one family, which is why there is no
separate Korean face.

**Vendor the font file. Do not load it from a CDN.** A CDN font arrives after first paint,
which is a visible reflow on every cold load.

Korean and English are set differently, and both are needed:

```css
:lang(ko) { letter-spacing: -0.015em; word-break: keep-all; overflow-wrap: break-word; }
:lang(en) { letter-spacing: -0.01em; }
html:lang(ko) { line-height: 1.75; }
html:lang(en) { line-height: 1.5; }
```

`word-break: keep-all` is what stops Korean breaking mid-word. The looser Korean line height
is not a preference: Hangul needs the room.

**Set line height on the root only.** Setting it per element made a heading's children
inherit the body value, so a heading that wrapped across both a `<br>` and a soft wrap got
two different line spacings in one block.

Mono is for code, identifiers, versions, counts and money. If a number is meant to be
compared with the number under it, it is mono.

## Radius

Measured across the canonical stylesheet: `9999px` on 19 rules, `1rem` on 9, `0.75rem` on 6,
`16px` on 5.

- Pills and anything capsule-shaped: `9999px`.
- Cards and panels: `0.75rem` to `1rem`.
- Avatars: `50%`.

Pick from that set rather than introducing a fourth card radius. Two radii in one component
read as a mistake even when both are in the list.

## Motion

The interaction duration is `0.15s`, which is the most common value in the canonical
stylesheet by a wide margin. Entrances and larger movements run `300ms` to `700ms`. Ambient
loops (a marquee, a pulse) run in seconds and must not draw the eye.

The easing for anything that enters or settles:

```css
cubic-bezier(0.16, 1, 0.3, 1)
```

It starts fast and settles slowly, which reads as responsive rather than decorative.

**Every animation needs a `prefers-reduced-motion` branch.** The canonical stylesheet has
five. Reduced motion means the state change still happens instantly; it does not mean the
element never appears.

Animate `transform` and `opacity`. Animating layout properties (`width`, `height`, `top`,
`margin`) makes the browser re-lay-out every frame.

## Surfaces and depth

Depth comes from a hairline border, not a drop shadow. `--border` is an 8% tint of `--ink`,
so it holds in both themes without a second token.

`--surface` is the raised plane, `--background` the page. `--surface-veil` is the same
surface at 92% for anything that sits over content and needs to stay legible, such as a
sticky header.

Do not put a texture, dot grid or pattern behind content. A 22px dot grid was shipped once
on a product surface and put texture under every card and label; it was removed by measuring
the count of distinct colors in the background region, which is how you tell texture from a
flat fill.

## Verifying a design change

**Look at the built screen.** Not the diff, not the source, not a component in isolation. A
green build has shipped a dead button, a grey fill nobody wanted, an invisible label, and a
mode toggle that did nothing, all with the CSS reading correctly.

Where a reference exists, measure the pixels rather than eyeballing them: color at a
coordinate, bounding box, letter-spacing, radius. Then compare the two images side by side,
because per-element measurement only checks size and cannot see a missing badge, a static
literal where a dynamic name belongs, or an empty section with no placeholder.

Two limits worth stating before you start: a macOS reference and a Linux build cannot match
at the glyph-raster level (different hinting, gamma and subpixel rendering), so match
typeface, size, weight and geometry and stop. And a screenshot of a window whose process
died looks identical to a screenshot of a change that did not apply, so confirm the process
is alive and the window title is what you expect before you conclude anything from two
identical frames.

## Order of work

Define the token, then build against it. Choosing a value inline and documenting it
afterwards is backwards, and it produces a second source of truth that immediately drifts.

Declaring tokens without changing what the screen looks like is also not finished work. The
token exists to be used.
