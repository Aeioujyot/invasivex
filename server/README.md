# InvasiveX API

One serverless function (`api/identify.ts`) that holds the Anthropic API key
and proxies species identification requests from the Flutter app. The key
never ships in the app bundle on any platform.

## Deploy

```sh
cd server
npm install
vercel link          # first time only
vercel env add ANTHROPIC_API_KEY   # paste your key when prompted
vercel deploy --prod
```

Copy the resulting production URL (e.g. `https://invasivex-api.vercel.app`)
into the Flutter app's `lib/config.dart` as `apiBaseUrl`.

## Local dev

```sh
cp .env.example .env.local   # fill in your key
vercel dev
```

Runs at `http://localhost:3000/api/identify` by default.
