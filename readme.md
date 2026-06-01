# Install
___

- Install Node.js
- Install Slidev for vscode https://sli.dev/features/vscode-extensions
- (optional) Install Code Spell Checker + your language extension
- (optional) Install venv with python/uv in yours slides directories. (and Select venv Python interpreter with CTRL+Shift+P)


---

# UV, Venv
___

- https://docs.astral.sh/uv/

``` PS
uv venv
```


---

# Install Slidev
___
/!\ Warning /!\ There is an issue in the current last version (v52.15.2) https://github.com/slidevjs/slidev/issues/2605
For the full pnpm installation, here is the workaround  (with the v52.15.0)

\# 1. If you haven't installed pnpm
```
npm i -g pnpm
```

\# 2. If you have this error: [ERROR] The configured global bin directory "C:\Users\[USER]\AppData\Local\pnpm\bin" is not in PATH
```
pnpm setup # => and restart the terminal after...
```

\# 3. Launch the install of the version you want | OR | pnpm create slidev for the lastest
```
pnpm create slidev@52.15.0 # => and answer "no" to "√ Install and start it now using pnpm?"
```

\# 4. Now edit the generated package.json in the new freshly created folder, and remove the "^"  before the version number in the file. "@slidev/cli": "^52.15.0",   => "@slidev/cli": "52.15.0",  

\# 5. (Optional) Add this entry in the .npmrc file: onlyBuiltDependencies[]=esbuild | OR | resolve any issues with esbuild yourself with the command given in the error.

\# 6. Now launch the install in the folder
```
cd slidev # your folder
pnpm install
```


---

# (optional) Cleaning demo files
___

Normally, you can safely remove the following files, they are related to the demo slides.md:

- netlify.toml
- vercel.json
- components/Counter.vue
- pages/imported-slides.md
- snippets/external.ts


---

# Run
___

```
pnpm dev # (or npm run dev) 
# OR
pnpm exec 'slidev "slides.md" --port 3030'  # or npm exec -c 'slidev "slides.md" --port 3030'  
```


---

# Local build:
___

(if your slides are in Slide1 directory)

```
cd Slide1 
npx slidev build slides.md --base /Slide1/ --out ../dist/Slide1
```


---

# local build testing:
___

# From dist/ folder
npx serve . 
# Or
python -m http.server 8080

=> http://localhost:8080/Slide1/


---

# .gitignore for Git repository:
____

```
# Dependencies
**/node_modules/

# Build output
dist/

# Python venv (généré par l'extension Slidev VSCode)
**/.venv/

# Logs
*.log
npm-debug.log*

# OS
.DS_Store
Thumbs.db

# VSCode
**/.vscode/*
**/!.vscode/extensions.json

```


---

# Online (github) build:
___

- Create a repo.
- push something on it (.gitignore)
- go to repo settings -> Pages -> Build and deployment -> Source: Select Github Action.
- Create .github/workflows/deploy.yml with the content below.
- Push something on the main branch, and go to your repo, click on repo actions tab.
- Now you can see the status of your git hub action, launched by your commit.
- When the status is green/ok, you can now visit your github page: https://YOUR_USER.github.io/SlidevPages/YOUR_SLIDE/


---

# deploy.yml:
___


```
name: Deploy pages

on:
  workflow_dispatch:
  push:
    branches: [main, master]

permissions:
  contents: read

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 'lts/*'

      - name: Setup @antfu/ni
        run: npm i -g @antfu/ni

      - name: Install and build slide01
        run: |
          cd slide01
          nci
          nr build slides.md --base /${{ github.event.repository.name }}/slide01/ --out ../dist/slide01

      - name: Copy root files
        run: |
          cp index.html dist/index.html
          cp .nojekyll dist/.nojekyll

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - uses: actions/upload-pages-artifact@v3
        with:
          path: dist

  deploy:
    permissions:
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    needs: build
    runs-on: ubuntu-latest
    name: Deploy
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```


---

Links
___


Slidev: https://sli.dev/guide/
Slidev Host: https://sli.dev/guide/hosting
Markdown: https://daringfireball.net/projects/markdown/
Markdown Cheatsheet: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
Writing on github: https://docs.github.com/fr/get-started/writing-on-github
Mermaid: https://mermaid.js.org/intro/