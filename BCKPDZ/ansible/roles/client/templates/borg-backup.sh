#!/bin/bash

set -e

export BORG_REPO='borg@192.168.56.11:/var/backup/repo'
export BORG_RSH="sshpass -p '123456' ssh -o StrictHostKeyChecking=no"
export BORG_PASSPHRASE='123456'

LOG_TAG="borg-backup"

ARCHIVE_NAME="etc-$(date +%Y-%m-%d_%H-%M-%S)"

# Создание бэкапа /etc
borg create \
  --stats \
  --compression lz4 \
  ::$ARCHIVE_NAME \
  /etc 2>&1 | logger -t $LOG_TAG

# Политика хранения
borg prune \
  --list \
  --keep-daily=90 \
  --keep-monthly=9 \
  2>&1 | logger -t $LOG_TAG
