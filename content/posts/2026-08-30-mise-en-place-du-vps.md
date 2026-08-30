---
title: "Mise en place de mon VPS"
date: 2026-08-30
tags: ["vps", "docker", "traefik", "ssh"]
summary: "Point de départ : un VPS OVH, Docker Compose, Traefik pour le TLS, et un peu de durcissement SSH."
---

Premier article, surtout pour valider la chaîne de publication.

## L'existant

- VPS OVH, Ubuntu, DNS `julestristan.fr` pointé sur l'IP.
- Docker + Compose v2, un réseau `web` partagé entre les stacks.
- Traefik v3 en reverse-proxy : redirection 80 → 443, certificats Let's Encrypt
  automatiques (challenge TLS-ALPN), en-têtes de sécurité via un fichier de
  configuration dynamique.
- Dashboard Traefik exposé uniquement en local (`127.0.0.1:8080`), accessible
  par tunnel SSH.

## Durcissement SSH

Piège rencontré : `PasswordAuthentication no` dans `sshd_config` était **écrasé**
par un fichier `sshd_config.d/50-cloud-init.conf`. Dans sshd, la première
directive gagne, et les drop-ins sont inclus avant. La seule vérification fiable :

```bash
sudo sshd -T | grep -i passwordauthentication
```

Ensuite : `ufw` (deny incoming sauf 22/80/443) et `fail2ban` sur le jail `sshd`.

## La suite

- Remplacer le blog par ce site Hugo (fait).
- CI/CD GitHub Actions → image Docker → GHCR → déploiement SSH (fait).
- Sauvegardes externalisées, puis IaC et observabilité.
