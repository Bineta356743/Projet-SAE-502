# Projet SAÉ 5.02 – Système de sauvegarde automatisé avec Ansible

## Introduction

Dans ce projet de la SAÉ 5.02, j’ai mis en place un système de sauvegarde automatisé entre plusieurs machines en utilisant Ansible.  
L’idée était d’automatiser tout le processus : installation, configuration, création des dossiers, exécution des sauvegardes, etc.

J’ai travaillé dans une machine Ubuntu 24.04 sous VMware, et j’ai utilisé Docker pour créer un environnement composé de trois conteneurs :  
- un contrôleur Ansible, 
- un client qui envoie les sauvegardes, 
- un serveur qui les stocke.

---

## Objectifs

Les objectifs principaux du projet étaient :

- déployer automatiquement les outils nécessaires (rsync, ssh, cron, etc.)
- configurer les connexions SSH entre les machines
- mettre en place un script de sauvegarde côté client
- créer un serveur qui reçoit les sauvegardes
- automatiser tout avec Ansible
- sécuriser les clés SSH avec Ansible Vault
- tester la restauration

---

### Multi-clients
- Plusieurs clients peuvent être ajoutés simplement dans l’inventaire Ansible
- Chaque client est sauvegardé vers le serveur central
- Le système est extensible à de nouveaux postes
---
### Sécurité
- Connexions SSH sans mot de passe
- Clés SSH déployées automatiquement
- Utilisation d’**Ansible Vault** pour protéger les secrets
- Les fichiers sensibles ne sont pas versionnés sur GitHub
---
### Supervision web
- Interface web légère (Apache + HTML)
- Affichage de l’état actuel des sauvegardes par client
- Vue claire et lisible (OK uniquement)
- Logs stockés côté serveur
## Architecture du projet
---
Voici comment l’infrastructure est organisée :

Ansible Controller → Backup Client → Backup Server

- Le contrôleur déploie la configuration sur les deux autres.
- Le client envoie ses fichiers vers le serveur via rsync.
- Le serveur stocke les sauvegardes dans un dossier dédié.


- Affichage de l’état actuel des sauvegardes par client
- Vue claire et lisible (OK uniquement)
- Logs stockés côté serveur
---


## Structure du dépôt


├── ansible.cfg
├── inventory.ini
├── playbooks/
│ └── site.yml
├── roles/
│ ├── common/
│ ├── backup_server/
│ └── client_backup/
├── supervision/
│ ├── index.html
│ └── generate_dashboard.sh
└── README.md
### Rôle *common*  
Installe les paquets nécessaires, active SSH et cron, crée le dossier `.ssh`, et déploie les clés à partir du fichier Vault.

### Rôle *backup_server*  
Crée le dossier où les sauvegardes seront stockées : `/data/backups`.

### Rôle *client_backup*  
Crée `/data/source`, copie le script de sauvegarde, et ajoute une tâche cron pour exécuter automatiquement le script.

---

## Déploiement

Pour lancer toute la configuration, il suffit d’exécuter :



ansible-playbook playbooks/site.yml


Ansible va alors :

- mettre à jour les machines, 
- installer les paquets,
- démarrer SSH et cron,
- déployer les clés,
- créer les dossiers nécessaires,
- installer le script de sauvegarde,
- configurer le cron.

---

## Fonctionnement de la sauvegarde

Le client possède un script :



run_backup.sh


Ce script utilise rsync pour copier le contenu du dossier `/data/source` vers le serveur.  
Une tâche cron déclenche automatiquement ce script à interval régulier.

Les sauvegardes sont stockées dans :



/data/backups/


sur le serveur.

---

## Restauration

Pour tester la restauration, j’ai simplement inversé le rsync, par exemple :



rsync -avz root@backup_server:/data/backups/ /data/restored/


Cela permet de vérifier que les données sauvegardées peuvent être récupérées.

---

## Sécurité

J’ai utilisé Ansible Vault pour stocker la clé privée SSH et la clé publique dans `secrets.yml`.  
Ce fichier est chiffré, ce qui permet de ne pas exposer les clés dans le dépôt GitHub.  
Un `.gitignore` a aussi été ajouté pour éviter d’envoyer des fichiers sensibles.

---

## Tests réalisés

- Test de connexion SSH entre les machines :  
- Test rsync du client vers le serveur :  
- Test du script et du cron : 
- Vérification des dossiers créés automatiquement : 
- Test de restauration :  
- Le playbook peut être relancé sans casser la configuration (idempotent)

---

---

## Conclusion

Ce projet m’a permis d’apprendre à automatiser un système complet avec Ansible, à gérer les clés SSH de façon sécurisée et à travailler avec des conteneurs Docker.  
Le système fonctionne entièrement de manière automatisée et peut être étendu facilement pour sauvegarder plusieurs machines.
