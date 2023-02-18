#!/usr/local/Cellar/python@3.11/3.11.2/bin/python3.11

import sys
import os
import random
import moviepy.editor as mp
from moviepy.audio.fx.audio_fadein import audio_fadein
from moviepy.audio.fx.audio_fadeout import audio_fadeout
from moviepy.audio.fx.audio_left_right import audio_left_right
from moviepy.audio.fx.audio_loop import audio_loop
from moviepy.audio.fx.audio_normalize import audio_normalize
from moviepy.audio.fx.volumex import volumex

from moviepy.video.fx.accel_decel import accel_decel
from moviepy.video.fx.blackwhite import blackwhite
from moviepy.video.fx.blink import blink
from moviepy.video.fx.colorx import colorx
from moviepy.video.fx.crop import crop
from moviepy.video.fx.even_size import even_size
from moviepy.video.fx.fadein import fadein
from moviepy.video.fx.fadeout import fadeout
from moviepy.video.fx.freeze import freeze
from moviepy.video.fx.freeze_region import freeze_region
from moviepy.video.fx.gamma_corr import gamma_corr
from moviepy.video.fx.headblur import headblur
from moviepy.video.fx.invert_colors import invert_colors
from moviepy.video.fx.loop import loop
from moviepy.video.fx.lum_contrast import lum_contrast
from moviepy.video.fx.make_loopable import make_loopable
from moviepy.video.fx.margin import margin
from moviepy.video.fx.mask_and import mask_and
from moviepy.video.fx.mask_color import mask_color
from moviepy.video.fx.mask_or import mask_or
from moviepy.video.fx.mirror_x import mirror_x
from moviepy.video.fx.mirror_y import mirror_y
from moviepy.video.fx.painting import painting
from moviepy.video.fx.resize import resize
from moviepy.video.fx.rotate import rotate
from moviepy.video.fx.scroll import scroll
from moviepy.video.fx.speedx import speedx
from moviepy.video.fx.supersample import supersample
from moviepy.video.fx.time_mirror import time_mirror
from moviepy.video.fx.time_symmetrize import time_symmetrize

# Check for correct usage
if len(sys.argv) < 2 or len(sys.argv) > 4:
    script_name = os.path.basename(sys.argv[0])
    print(f"Usage: python {script_name} <original_video_file> [<output_file_prefix>] [<num_copies>]")
    sys.exit(1)

# Get input arguments
original_video_file = sys.argv[1]
if not os.path.exists(original_video_file):
    print(f"Error: {original_video_file} does not exist")
    sys.exit(1)

output_file_prefix = os.path.splitext(original_video_file)[0] if len(sys.argv) < 3 else sys.argv[2]
num_copies = int(sys.argv[3]) if len(sys.argv) == 4 else 5

# Define bitrate range
min_bitrate = 700
max_bitrate = 1200

# Define noise sigma range
min_noise_sigma = 1
max_noise_sigma = 20

# Generate video copies with noise
for i in range(1, num_copies+1):
    # Print progress message
    print(f"{i} from {num_copies} ready")

    # Define output file name
    output_file = f"{output_file_prefix}_{i}.mp4"

    # Define random bitrate and noise sigma
    bitrate = random.randint(min_bitrate, max_bitrate)
    noise_sigma = random.randint(min_noise_sigma, max_noise_sigma)
    noise_clip = mp.VideoFileClip(original_video_file).fx(mp.vfx.volumex, 0).fx(mp.vfx.lumax, noise_sigma)

    # Load original video and add noise
    video = mp.VideoFileClip(original_video_file)
    video_with_noise = video.fx(mp.vfx.volumex, 1).fx(mp.vfx.lumax, noise_clip)

    # Save video copy with noise
    video_with_noise.write_videofile(output_file, bitrate=f"{bitrate}k")

