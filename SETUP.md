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

## Known Issues

### Google Analytics Template Error

If you encounter an error about `_internal/google_analytics_async.html` when building:

```
Error: html/template:_partials/head.html:52:16: no such template "_internal/google_analytics_async.html"
```

This is a known compatibility issue between Hugo 0.147+ and Docsy 0.5.1. The site should still work with `hugo server` for development. 

**Workarounds:**
1. Use `hugo server` for development (this typically works fine)
2. Update Docsy to a newer version if available
3. Downgrade Hugo to version 0.104.3 (as specified in netlify.toml)

## Next Steps

- Add content to `content/en/docs/`
- Customize styling in `assets/scss/_variables_project.scss`
- Add favicons to `static/favicons/`
- Add images to `static/images/`
- Configure Google Analytics if needed (add `[services.googleAnalytics]` section to config.toml)

