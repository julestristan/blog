# julestristan.fr — blog

Site statique (Hugo + thème PaperMod), servi par nginx, déployé en CI/CD sur le VPS.

## Architecture

```
git push main
   └─> GitHub Actions
         ├─ build image Docker multi-stage (hugo build -> nginx:alpine)
         ├─ push -> ghcr.io/julestristan/blog:latest
         └─ SSH VPS : cd ~/blog && git pull && docker compose pull && up -d
```

Le VPS ne compile rien en prod : il tire une image déjà construite. 

## Développement local

```bash
# avec un conteneur (rien à installer) :
docker compose -f compose.dev.yaml up      # http://localhost:1313, live reload

# ou avec hugo installé :
hugo server -D
```

## Contenu

- `content/posts/*.md` — articles
- `content/about.md` — page À propos
- `hugo.toml` — config (menu, réseaux sociaux, thème)

## Déploiement

Automatique à chaque push sur `main`. Manuel : onglet Actions → *deploy* → *Run workflow*.

### Secrets GitHub requis

| Secret | Valeur |
|---|---|
| `SSH_HOST` | IP du VPS |
| `SSH_USER` | `tristan` |
| `SSH_KEY`  | clé privée de déploiement (publique dans `~/.ssh/authorized_keys` du VPS) |

### Sur le VPS

`~/blog/` est un clone de ce repo. L'image GHCR doit être publique
(Packages → blog → Package settings → Change visibility → Public), sinon
`docker login ghcr.io` sur le VPS.
