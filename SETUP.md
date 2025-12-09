# Setup Instructions

## Initial Setup

1. **Install dependencies:**
   ```bash
   npm install
   hugo mod get
   ```

2. **Test the site:**
   ```bash
   hugo server
   ```
   
   Then open `http://localhost:1313` in your browser.

## Fixed Issues

### Google Analytics Template Error (FIXED)

The Google Analytics template compatibility issue between Hugo 0.147+ and Docsy 0.5.1 has been resolved by creating custom template overrides in:
- `layouts/_internal/google_analytics_async.html`
- `layouts/_internal/google_analytics_gtag.html`
- `layouts/partials/head.html`

These overrides ensure compatibility with newer Hugo versions while maintaining Docsy functionality.

## Next Steps

- Add content to `content/en/docs/`
- Customize styling in `assets/scss/_variables_project.scss`
- Add favicons to `static/favicons/`
- Add images to `static/images/`
- Configure Google Analytics if needed (add `[services.googleAnalytics]` section to config.toml)

