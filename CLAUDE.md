# Privateer Site

Hugo static site using the [Docsy](https://www.docsy.dev/) theme (loaded as a Hugo module). Hosted at privateerproj.com.

## Rules

- **Never use inline styles.** All styling must go through CSS classes in `assets/scss/_styles_project.scss`. If a class doesn't exist for what you need, create one in the SCSS file first, then reference it in HTML/markdown.
- **Use existing CSS classes** before creating new ones. Check the inventory below.
- **SVG gotcha:** SVGs rendered via `<img>` tags are affected by CSS sizing but not by CSS color/fill rules. When constraining SVG logos, use `height` + `max-width` + `object-fit: contain` (not just `max-height`, which conflicts with Bootstrap's `img-fluid` class setting `height: auto`).

## CSS Class Inventory

All custom classes live in `assets/scss/_styles_project.scss`.

### Layout & Content

| Class | Purpose | Used in |
|---|---|---|
| `.fits-section` | "Where Privateer Fits" editorial section container (max-width 900px) | `_index.html` |
| `.fits-eyebrow` | Monospace uppercase label above section title | `_index.html` |
| `.fits-divider` | Teal gradient horizontal rule below section title | `_index.html` |
| `.fits-subhead` | Monospace subsection heading with `>` prefix | `_index.html` |
| `.fits-callout` | Pull-quote callout with left teal border | `_index.html` |
| `.fits-list` | Bulleted list with teal square markers | `_index.html` |
| `.icon-gallery` | Flex row for icon/label groups | `plugins/_index.md` |
| `.icon-gallery-item` | Individual item inside `.icon-gallery` | `plugins/_index.md` |

### Images

| Class | Purpose | Used in |
|---|---|---|
| `.hero-mascot` | Mascot image in hero block (max-width 220px + drop shadow) | `_index.html` |
| `.hero-lead` | Hero subtitle text (font-size 1.4rem) | `_index.html` |
| `.partner-logo` | Partner logo sizing (height 60px, max-width 200px, object-fit contain) | `_index.html` |
| `.doc-float-img` | Float-right doc illustration (max-width 120px) | docs markdown pages |
| `.doc-float-img--lg` | Larger float-right variant (max-width 150px) | `docs/_index.md` |

### Theme Overrides (Docsy)

| Class | Purpose |
|---|---|
| `.mono-tag` | Monospace pill label (used above hero title) |
| `.partners-label` | "Trusted and Used By" label styling |
| `.partners-row` | Logo row container with gap spacing |
| `.td-box--primary` | Dark navy section with radial glow background |
| `.td-cover-block.-bg-primary` | Hero gradient with grid overlay and glow blob |
| `.td-navbar` | Navy navbar with teal bottom border |
| `.btn-primary` | Teal button |
| `.btn-secondary` | Gold CTA button with lift hover |

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| Navy | `#1B2A3D` | Backgrounds, headings |
| Teal | `#0AADAD` | Primary accent, links, icons |
| Bright teal | `#12C5C5` | Hover states, light accents |
| Gold | `#E5A820` | CTA buttons |
| Text | `#2D3748` | Body text |
| Muted | `#6B7588` | Labels, subtitles |

## File Structure

```
assets/scss/_styles_project.scss  — All custom CSS (only CSS file to edit)
content/en/_index.html            — Home page
content/en/docs/                  — Documentation pages (markdown)
layouts/partials/head.html        — Custom <head> (overrides Docsy)
layouts/shortcodes/godoc-link.html — GoDoc link button shortcode
layouts/_shortcodes/blocks/        — Overridden Docsy section/lead shortcodes
static/images/                    — Logos, icons, mascot
static/favicons/                  — Favicon files (Docsy auto-references via favicons.html partial)
config.toml                       — Hugo config (theme, params, nav)
```

## Hugo Shortcodes

- `{{< blocks/cover >}}` — Hero banner (params: `image_anchor`, `height`, `color`)
- `{{< blocks/section >}}` — Content section (params: `color`, `type`). `color="primary"` = dark navy, `color="white"` = light
- `{{% blocks/feature %}}` — Feature card with icon (params: `icon`, `title`). Use inside a section with `type="features"`
- `{{< blocks/lead >}}` — Centered lead text block
- `{{< godoc-link >}}` — GoDoc link button (params: `package`, `text`)

## Build & Dev

```bash
make start    # Local dev server with live reload
make build    # Production build
```
