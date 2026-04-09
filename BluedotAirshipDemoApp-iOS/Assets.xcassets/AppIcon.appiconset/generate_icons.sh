#!/bin/bash
set -euo pipefail

# Create 1024x1024 source icon with Airship label from provided style.
sips -s format png /tmp/copilot_input_icon.png --resampleHeightWidth 1024 1024 --out appicon-1024-base.png >/dev/null

# Draw AIRSHIP text using macOS built-in Python + Pillow fallback via Quartz not available,
# so use sips only workflow by overlaying pre-rendered text generated with Swift script.
cat > /tmp/make_text.swift <<'SWIFT'
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()
NSColor.clear.setFill()
NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

let paragraph = NSMutableParagraphStyle()
paragraph.alignment = .center
let attrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 145, weight: .bold),
    .foregroundColor: NSColor.white,
    .paragraphStyle: paragraph,
    .strokeColor: NSColor.black.withAlphaComponent(0.25),
    .strokeWidth: -3.0
]

let text = NSAttributedString(string: "AIRSHIP", attributes: attrs)
let textRect = NSRect(x: 60, y: 60, width: 904, height: 200)
text.draw(in: textRect)

image.unlockFocus()

if let tiff = image.tiffRepresentation,
   let bitmap = NSBitmapImageRep(data: tiff),
   let data = bitmap.representation(using: .png, properties: [:]) {
    try data.write(to: URL(fileURLWithPath: "/tmp/airship_text_overlay.png"))
}
SWIFT

swift /tmp/make_text.swift >/dev/null

cat > /tmp/composite.swift <<'SWIFT'
import AppKit
let base = NSImage(contentsOfFile: "appicon-1024-base.png")!
let overlay = NSImage(contentsOfFile: "/tmp/airship_text_overlay.png")!
let out = NSImage(size: NSSize(width: 1024, height: 1024))
out.lockFocus()
base.draw(in: NSRect(x: 0, y: 0, width: 1024, height: 1024))
overlay.draw(in: NSRect(x: 0, y: 0, width: 1024, height: 1024))
out.unlockFocus()
if let tiff = out.tiffRepresentation,
   let bitmap = NSBitmapImageRep(data: tiff),
   let data = bitmap.representation(using: .png, properties: [:]) {
    try data.write(to: URL(fileURLWithPath: "appicon-1024.png"))
}
SWIFT

swift /tmp/composite.swift >/dev/null

make_icon () {
  local pts="$1"
  local scale="$2"
  local name="$3"
  local px
  px=$(python3 - <<PY
size=float("$pts")
scale=int("$scale")
print(int(round(size*scale)))
PY
)
  sips -s format png appicon-1024.png --resampleHeightWidth "$px" "$px" --out "$name" >/dev/null
}

make_icon 20 2 Icon-App-20x20@2x.png
make_icon 20 3 Icon-App-20x20@3x.png
make_icon 29 2 Icon-App-29x29@2x.png
make_icon 29 3 Icon-App-29x29@3x.png
make_icon 40 2 Icon-App-40x40@2x.png
make_icon 40 3 Icon-App-40x40@3x.png
make_icon 60 2 Icon-App-60x60@2x.png
make_icon 60 3 Icon-App-60x60@3x.png
make_icon 20 1 Icon-App-20x20@1x-ipad.png
make_icon 20 2 Icon-App-20x20@2x-ipad.png
make_icon 29 1 Icon-App-29x29@1x-ipad.png
make_icon 29 2 Icon-App-29x29@2x-ipad.png
make_icon 40 1 Icon-App-40x40@1x-ipad.png
make_icon 40 2 Icon-App-40x40@2x-ipad.png
make_icon 76 1 Icon-App-76x76@1x.png
make_icon 76 2 Icon-App-76x76@2x.png
make_icon 83.5 2 Icon-App-83.5x83.5@2x.png
cp appicon-1024.png Icon-App-1024x1024@1x.png

rm -f /tmp/make_text.swift /tmp/composite.swift /tmp/airship_text_overlay.png appicon-1024-base.png
