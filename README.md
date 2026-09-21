# CI/CD Pipeline — Node Express App

## Prerequisites

- Node.js v20+
- PM2 (on the self-hosted runner): `npm install -g pm2`

---

## Local Development

```bash
npm install          # install all dependencies
npm run check        # run tests (Mocha + Chai)
npm start            # start server on port 3000
```

Routes:
- `GET /` — serves `src/public/index.html`
- `GET /api` — returns `{ "message": "Hello World" }`

---

## CI/CD Pipeline (GitHub Actions)

The workflow at `.github/workflows/ci-cd.yml` runs on every push/PR to `main`.

### Job 1: `test` (ubuntu-latest)
1. Installs dependencies with `npm ci`
2. Runs `npm run check -- --exit` and pipes output to `test-results.txt`
3. Uploads `test-results.txt` as a downloadable artifact (uploaded even on failure)

### Job 2: `deploy` (self-hosted runner)
1. Downloads the `test-results` artifact and prints it to the log
2. Runs `deploy.sh` which uses PM2 to start/restart the app

---

## Self-Hosted Runner Setup

> Do this once on the machine that will act as the deployment target.

1. Go to your GitHub repo → **Settings → Actions → Runners → New self-hosted runner**
2. Select **Linux**, then follow the displayed commands to download and configure the runner agent
3. When prompted for labels, the default `self-hosted,linux` label is used automatically
4. Start the runner as a background service:
   ```bash
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```
5. Ensure the machine has Node.js 20+ and PM2 installed:
   ```bash
   node -v          # should be v20+
   npm install -g pm2
   ```

Once the runner is online it will appear as **Idle** in the GitHub Runners list and the deploy job will pick it up automatically.
