# Privateer Website

This is the website for the Privateer project, hosted at [privateerproj.com](https://privateerproj.com).

## Technology Stack

- **Hugo** (extended version 0.104.3) - Static site generator
- **Docsy Theme** - Hugo theme for technical documentation
- **Netlify** - Hosting and CI/CD

## Prerequisites

- Hugo extended version 0.104.3 or later
- Go 1.19.2 or later
- Node.js (for PostCSS processing)
- Docker (optional, for containerized development)

## Local Development

### Using Hugo directly

1. Install dependencies:
   ```bash
   npm install
   hugo mod get
   ```

2. Run the development server:
   ```bash
   hugo server
   ```

3. Open `http://localhost:1313` in your browser

### Using Docker

1. Build and run with Docker Compose:
   ```bash
   docker-compose up --build
   ```

2. Open `http://localhost:1313` in your browser

## Building

To build the site:

```bash
hugo
```

The output will be in the `public/` directory.

## Deployment

The site is automatically deployed to Netlify when changes are pushed to the `main` branch.

## License

See LICENSE file for details.

