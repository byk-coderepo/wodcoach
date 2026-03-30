# WOD Coach — Setup Guide

Follow these steps in order. Total time: ~30 minutes.

---

## STEP 1 — Supabase (Database + API Proxy)

### 1.1 Create your Supabase project
1. Go to https://supabase.com and sign up (free)
2. Click **New Project**
3. Name it `wodcoach`, pick a region close to you (US East or Canada), set a password
4. Wait ~2 minutes for it to provision

### 1.2 Create the database table
1. In your project, click **SQL Editor** in the left sidebar
2. Click **New Query**
3. Open the file `setup.sql` from this folder and paste the entire contents
4. Click **Run**
5. You should see "Success. No rows returned"

### 1.3 Get your API keys
1. Go to **Settings > API** in the left sidebar
2. Copy two values — you'll need them in Step 3:
   - **Project URL** (looks like `https://xyzxyz.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)

### 1.4 Deploy the Edge Function
1. Install the Supabase CLI:
   ```
   npm install -g supabase
   ```
2. In your terminal, navigate to the `wodcoach` folder and run:
   ```
   supabase login
   supabase link --project-ref YOUR_PROJECT_REF
   ```
   (Your project ref is the string after `https://` and before `.supabase.co` in your project URL)

3. Deploy the function:
   ```
   supabase functions deploy anthropic-proxy
   ```

### 1.5 Add your Anthropic API key as a secret
1. In the Supabase dashboard, go to **Edge Functions**
2. Click on `anthropic-proxy`
3. Go to **Secrets** tab
4. Add a new secret:
   - Name: `ANTHROPIC_API_KEY`
   - Value: your Anthropic API key (from https://console.anthropic.com)

---

## STEP 2 — GitHub Repository

### 2.1 Create the repo
1. Go to https://github.com and click **New repository**
2. Name it `wodcoach`
3. Set it to **Public** (required for free GitHub Pages)
4. Click **Create repository**

### 2.2 Upload your files
Option A — via the GitHub web interface (easiest):
1. In your new repo, click **Add file > Upload files**
2. Upload `index.html` from the `wodcoach` folder
3. Commit the changes

Option B — via terminal if you have Git installed:
```
cd wodcoach
git init
git add index.html
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/wodcoach.git
git push -u origin main
```

### 2.3 Enable GitHub Pages
1. In your repo, go to **Settings > Pages**
2. Under **Source**, select **Deploy from a branch**
3. Select branch: `main`, folder: `/ (root)`
4. Click **Save**
5. Wait 1–2 minutes. Your app will be live at:
   `https://YOUR_USERNAME.github.io/wodcoach`

---

## STEP 3 — Connect Everything

### 3.1 Update index.html with your Supabase credentials
Open `index.html` and find these two lines near the bottom of the file (in the `<script>` block):

```javascript
const SUPABASE_URL  = "YOUR_SUPABASE_URL";
const SUPABASE_ANON = "YOUR_SUPABASE_ANON_KEY";
```

Replace the placeholder values with your actual keys from Step 1.3.

### 3.2 Re-upload index.html to GitHub
1. Go back to your GitHub repo
2. Click on `index.html`
3. Click the pencil (edit) icon
4. Replace the content with your updated file (or use the Upload option)
5. Commit the changes
6. GitHub Pages will redeploy automatically in ~1 minute

---

## STEP 4 — Test It

1. Open `https://YOUR_USERNAME.github.io/wodcoach`
2. You should see **"Connected"** in green in the top right
3. Select a day, type in a WOD, and click **Analyze WOD**
4. The recommendation should appear within 5–10 seconds

---

## Troubleshooting

**"DB offline" in the header**
- Double-check your SUPABASE_URL and SUPABASE_ANON values in index.html
- Make sure the `wod_logs` table was created successfully (check Supabase > Table Editor)

**Analyze WOD button returns an error**
- Check that the Edge Function deployed successfully (Supabase > Edge Functions)
- Verify the ANTHROPIC_API_KEY secret was added correctly
- Check the Edge Function logs in Supabase for the specific error

**GitHub Pages not loading**
- Make sure the repo is Public
- Give it a few minutes after enabling Pages — first deploy can take up to 5 minutes

---

## Folder structure of what was generated

```
wodcoach/
├── index.html                          ← Main app (deploy this to GitHub)
├── setup.sql                           ← Run this once in Supabase SQL Editor
├── SETUP.md                            ← This guide
└── supabase/
    └── functions/
        └── anthropic-proxy/
            └── index.ts                ← Edge Function (deploy via Supabase CLI)
```
