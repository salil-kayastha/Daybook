"""Regenerates the Android notification small icon (ic_stat_daybook) — see
README "Notification icon". Requires Pillow: pip install Pillow.

Run from anywhere; paths are resolved relative to this script's location:
    python3 tool/gen_notification_icon.py
"""

import os

from PIL import Image, ImageDraw

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(REPO_ROOT, "android", "app", "src", "main", "res")
WORK = 384  # draw large, downsample for crisp anti-aliasing at small sizes

def draw_glyph(size):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    margin = int(size * 0.14)
    fold = int(size * 0.28)  # dog-ear corner size

    # Page body: rounded rect with the top-right corner cut off (folded
    # corner), drawn as a polygon so the fold reads clearly even at 24px.
    radius = int(size * 0.10)
    left, top, right, bottom = margin, margin, size - margin, size - margin

    page = [
        (left + radius, top),
        (right - fold, top),
        (right, top + fold),
        (right, bottom - radius),
        (right - radius, bottom),
        (left + radius, bottom),
        (left, bottom - radius),
        (left, top + radius),
    ]
    d.polygon(page, fill=(255, 255, 255, 255))
    # Round the four non-fold corners.
    d.pieslice([left, top, left + 2 * radius, top + 2 * radius], 180, 270, fill=(255, 255, 255, 255))
    d.pieslice([right - 2 * radius, bottom - 2 * radius, right, bottom], 0, 90, fill=(255, 255, 255, 255))
    d.pieslice([left, bottom - 2 * radius, left + 2 * radius, bottom], 90, 180, fill=(255, 255, 255, 255))

    # Punch the dog-ear triangle out (transparent) so the fold is visible
    # as a notch, not just a straight cut.
    notch = [
        (right - fold, top),
        (right, top + fold),
        (right - fold, top + fold),
    ]
    d.polygon(notch, fill=(0, 0, 0, 0))

    # A bold horizontal "task line" punched through the lower half reads
    # as a list/page at a glance, standard for note/planner notification
    # glyphs, and stays legible at 24px.
    line_h = max(2, int(size * 0.07))
    line_y = int(size * 0.60)
    line_left = left + int(size * 0.10)
    line_right = right - int(size * 0.10)
    d.rectangle([line_left, line_y, line_right, line_y + line_h], fill=(0, 0, 0, 0))

    return img

master = draw_glyph(WORK)

dirs = {
    "drawable-mdpi": 24,
    "drawable-hdpi": 36,
    "drawable-xhdpi": 48,
    "drawable-xxhdpi": 72,
    "drawable-xxxhdpi": 96,
}
for dirname, px in dirs.items():
    out_dir = os.path.join(OUT_DIR, dirname)
    os.makedirs(out_dir, exist_ok=True)
    resized = master.resize((px, px), Image.LANCZOS)
    out_path = os.path.join(out_dir, "ic_stat_daybook.png")
    resized.save(out_path)
    print("wrote", out_path, resized.size)
