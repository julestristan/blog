# julestristan.fr — blog

Site statique (Hugo + thème PaperMod), servi par nginx derrière Traefik,
hébergé sur mon PC.

## Architecture

```
fichiers locaux
   └─> docker compose up -d --build
         ├─ build image Docker multi-stage (hugo build -> nginx:alpine)
         └─ 3 réplicas nginx derrière Traefik -> https://julestristan.fr

git push main
   └─> GitHub Actions : vérifie que le site compile
                        + publie ghcr.io/julestristan/blog:latest
```

Le site en ligne est construit à partir des fichiers locaux, pas depuis GHCR
(`pull_policy: build` dans `compose.yaml`).

## Workflow

```bash
# 1. Écrire / modifier, avec aperçu en direct :
docker compose -f compose.dev.yaml up      # http://localhost:1313, live reload

# 2. Mettre en ligne :
docker compose up -d --build

# 3. Garder l'historique :
git add . && git commit -m "..." && git push
```

## Contenu

- `content/posts/*.md` — articles
- `content/about.md` — page À propos
- `hugo.toml` — config (menu, réseaux sociaux, thème)
- `assets/css/extended/custom.css` — surcharges visuelles du thème

## Configuration

`.env` (voir `.env.example`) : `BLOG_HOST` et `HUGO_BASEURL`.
Le réseau Docker `web` (partagé avec Traefik) doit exister.
