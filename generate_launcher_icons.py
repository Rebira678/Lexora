import math
from PIL import Image, ImageDraw, ImageFilter

sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

# High-res base canvas 1024x1024
BASE = 1024
img = Image.new("RGBA", (BASE, BASE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 1. Rounded obsidian background with subtle radial sheen
corner_radius = 240
# Dark background polygon
bg_color = (10, 12, 16, 255) # Deep Obsidian
draw.rounded_rectangle([20, 20, BASE-20, BASE-20], radius=corner_radius, fill=bg_color)

# 2. Sleek metallic slate border
border_color = (43, 51, 73, 220)
draw.rounded_rectangle([20, 20, BASE-20, BASE-20], radius=corner_radius, outline=border_color, width=14)

# 3. Soft indigo ambient glow in center
center = (BASE // 2, BASE // 2)
glow_overlay = Image.new("RGBA", (BASE, BASE), (0, 0, 0, 0))
glow_draw = ImageDraw.Draw(glow_overlay)
glow_draw.ellipse([center[0]-320, center[1]-320, center[0]+320, center[1]+320], fill=(99, 102, 241, 40))
glow_overlay = glow_overlay.filter(ImageFilter.GaussianBlur(80))
img = Image.alpha_composite(img, glow_overlay)
draw = ImageDraw.Draw(img)

# 4. Premium Geometric "L" Crest with diamond facets
# Vertical pillar of L
pillar = [
    (320, 240),
    (420, 240),
    (420, 680),
    (320, 680),
]
# Base arm of L
base_arm = [
    (320, 680),
    (740, 680),
    (740, 780),
    (320, 780),
]
# Golden accent facet on top corner
top_facet = [
    (320, 240),
    (420, 240),
    (370, 190),
]

# Primary indigo/purple gradient simulation
draw.polygon(pillar, fill=(99, 102, 241, 255))
draw.polygon(base_arm, fill=(79, 70, 229, 255))

# Golden accent bar on base arm tip
gold_accent = [
    (660, 680),
    (740, 680),
    (740, 780),
    (660, 780),
]
draw.polygon(gold_accent, fill=(245, 158, 11, 255))

# Top diamond finial
draw.polygon([(370, 170), (440, 240), (370, 310), (300, 240)], fill=(245, 158, 11, 255))
# Glowing inner diamond
draw.polygon([(370, 200), (410, 240), (370, 280), (330, 240)], fill=(255, 255, 255, 240))

# Sub-facet line
draw.line([(420, 240), (420, 680)], fill=(129, 140, 248, 255), width=8)
draw.line([(320, 680), (740, 680)], fill=(129, 140, 248, 255), width=8)

# Right finial point
draw.polygon([(740, 680), (790, 730), (740, 780)], fill=(245, 158, 11, 255))

for folder, dim in sizes.items():
    resized = img.resize((dim, dim), Image.Resampling.LANCZOS)
    path = f"android/app/src/main/res/{folder}/ic_launcher.png"
    resized.save(path, "PNG")
    print(f"Saved {path} ({dim}x{dim})")

print("All launcher icons successfully generated!")
