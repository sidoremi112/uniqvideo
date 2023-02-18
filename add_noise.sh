#!/bin/bash

# Проверяем, что передано от 1 до 3 аргументов (имя исходного файла, [префикс выходного файла], [количество копий])
if [ $# -lt 1 ] || [ $# -gt 3 ]; then
  echo "Использование: $0 исходный_файл [выходной_префикс] [количество_копий]"
  exit 1
fi

# Проверяем, что исходный файл существует
if [ ! -f "$1" ]; then
  echo "Исходный файл не существует: $1"
  exit 1
fi

# По умолчанию создаем 3 копии файла
num_copies=${3:-3}

# Минимальный и максимальный битрейт для видеофайла (в Kbit/s)
min_bitrate=700
max_bitrate=1000

# Минимальный и максимальный уровень шума для видеофайла
min_noise_level=1
max_noise_level=20

# Определяем имя исходного файла без расширения
input_file=$(basename "$1")
input_file="${input_file%.*}"

# Определяем префикс для выходных файлов (если не задан, используем имя исходного файла без расширения)
output_prefix=${2:-$input_file}

for i in $(seq 1 "$num_copies"); do
  # Генерируем случайный битрейт и уровень шума для каждой копии файла
  bitrate="$((RANDOM % (max_bitrate - min_bitrate) + min_bitrate))"
  noise_level="$((RANDOM % (max_noise_level - min_noise_level) + min_noise_level))"

  # Определяем имя выходного файла с учетом номера копии
  output_file="${output_prefix}${i}.mp4"

  # Выводим на экран команду, которую будем выполнять
  echo "Запускаем команду ffmpeg: ffmpeg -hide_banner -loglevel panic -y -i '$1' -vf 'noise=alls=${noise_level}:allf=t+u' -b:v ${bitrate}k -c:a copy -progress pipe:1 '$output_file' </dev/null >/dev/null 2>&1"

  # Запускаем ffmpeg для создания копии файла
  ffmpeg -hide_banner -loglevel panic -y -i "$1" -vf "noise=alls=${noise_level}:allf=t+u" -b:v "${bitrate}k" -c:a copy -progress pipe:1 "$output_file" </dev/null >/dev/null 2>&1
done

