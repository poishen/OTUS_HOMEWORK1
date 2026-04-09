#!/bin/bash

DISK1="/dev/sdb"
DISK2="/dev/sdc"
MOUNT1="/mnt/disk1"
MOUNT2="/mnt/disk2"

#Форматирование дисков
echo "Форматирование $DISK1 в ext4..."
mkfs.ext4 -F $DISK1

echo "Форматирование $DISK2 в ext4..."
mkfs.ext4 -F $DISK2

# Создание точек монтирования
echo "Создание директорий для монтирования..."
mkdir -p $MOUNT1
mkdir -p $MOUNT2

# Монтирование дисков
echo "Монтирование $DISK1 в $MOUNT1..."
mount $DISK1 $MOUNT1

echo "Монтирование $DISK2 в $MOUNT2..."
mount $DISK2 $MOUNT2

# Добавление записей в /etc/fstab для автоматического монтирования
echo "Добавление записей в /etc/fstab..."
UUID1=$(blkid -s UUID -o value $DISK1)
UUID2=$(blkid -s UUID -o value $DISK2)

# Проверка, что записи ещё не существуют, чтобы избежать дублирования
if ! grep -qs "$MOUNT1" /etc/fstab; then
    echo "UUID=$UUID1 $MOUNT1 ext4 defaults 0 2" >> /etc/fstab
fi

if ! grep -qs "$MOUNT2" /etc/fstab; then
    echo "UUID=$UUID2 $MOUNT2 ext4 defaults 0 2" >> /etc/fstab
fi

echo "Настройка дисков завершена."
