#!/bin/bash
set -euo pipefail

if [ ! -f "1024.png" ]; then
  echo "Missing 1024.png in AppIcon.appiconset" >&2
  exit 1
fi

sips -s format png "1024.png" --resampleHeightWidth 1024 1024 --out appicon-1024-base.png >/dev/null

cat > /tmp/make_airship_overlay.swift <<'SWIFT'
import AppKit
let canvas = NSSize(width: 1024, height: 1024)
let img = NSImage(size: canvas)
img.lockFocus()
NSColor.clear.setFill()
NSBezierPath(rect: NSRect(origin: .zero, size: canvas)).fill()
let p = NSMutableParagraphStyle(); p.alignment = .center
let attrs: [NSAttributedString.Key: Any] = [
  .font: NSFont.systemFont(ofSize: 138, weight: .heavy),
  .foregroundColor: NSColor.white.withAlphaComponent(0.96),
  .strokeColor: NSColor.black.withAlphaComponent(0.22),
  .strokeWidth: -3.0,
  .paragraphStyle: p
]
NSAttributedString(string: "AIRSHIP", attributes: attrs).draw(in: NSRect(x: 70, y: 54, width: 884, height: 180))
img.unlockFocus()
if let tiff = img.tiffRepresentation,
   let rep = NSBitmapImageRep(data: tiff),
   let png = rep.representation(using: .png, properties: [:]) {
  try png.write(to: URL(fileURLWithPath: "/tmp/airship_overlay.png"))
}
SWIFT
swift /tmp/make_airship_overlay.swift >/dev/null

cat > /tmp/composite_airship.swift <<'SWIFT'
import AppKit
let base = NSImage(contentsOfFile: "appicon-1024-base.png")!
let overlay = NSImage(contentsOfFile: "/tmp/airship_overlay.png")!
let out = NSImage(size: NSSize(width: 1024, height: 1024))
out.lockFocus()
base.draw(in: NSRect(x: 0, y: 0, width: 1024, height: 1024))
overlay.draw(in: NSRect(x: 0, y: 0, width: 1024, height: 1024))
out.unlockFocus()
if let tiff = out.tiffRepresentation,
   let rep = NSBitmapImageRep(data: tiff),
   let png = rep.representation(using: .png, properties: [:]) {
  try png.write(to: URL(fileURLWithPath: "Icon-App-1024x1024@1x.png"))
}
SWIFT
swift /tmp/composite_airship.swift >/dev/null

make_icon () {
  local points="$1"; local scale="$2"; local out="$3"
  local px
  px="$(python3 - <<PY
size=float("$points")
scale=int("$scale")
print(int(round(size*scale)))
PY
)"
  sips -s format png Icon-App-1024x1024@1x.png --resampleHeightWidth "$px" "$px" --out "$out" >/dev/null
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

cat > Contents.json <<'JSON'
{
  "images" : [
    { "size" : "20x20", "idiom" : "iphone", "filename" : "Icon-App-20x20@2x.png", "scale" : "2x" },
    { "size" : "20x20", "idiom" : "iphone", "filename" : "Icon-App-20x20@3x.png", "scale" : "3x" },
    { "size" : "29x29", "idiom" : "iphone", "filename" : "Icon-App-29x29@2x.png", "scale" : "2x" },
    { "size" : "29x29", "idiom" : "iphone", "filename" : "Icon-App-29x29@3x.png", "scale" : "3x" },
    { "size" : "40x40", "idiom" : "iphone", "filename" : "Icon-App-40x40@2x.png", "scale" : "2x" },
    { "size" : "40x40", "idiom" : "iphone", "filename" : "Icon-App-40x40@3x.png", "scale" : "3x" },
    { "size" : "60x60", "idiom" : "iphone", "filename" : "Icon-App-60x60@2x.png", "scale" : "2x" },
    { "size" : "60x60", "idiom" : "iphone", "filename" : "Icon-App-60x60@3x.png", "scale" : "3x" },
    { "size" : "20x20", "idiom" : "ipad", "filename" : "Icon-App-20x20@1x-ipad.png", "scale" : "1x" },
    { "size" : "20x20", "idiom" : "ipad", "filename" : "Icon-App-20x20@2x-ipad.png", "scale" : "2x" },
    { "size" : "29x29", "idiom" : "ipad", "filename" : "Icon-App-29x29@1x-ipad.png", "scale" : "1x" },
    { "size" : "29x29", "idiom" : "ipad", "filename" : "Icon-App-29x29@2x-ipad.png", "scale" : "2x" },
    { "size" : "40x40", "idiom" : "ipad", "filename" : "Icon-App-40x40@1x-ipad.png", "scale" : "1x" },
    { "size" : "40x40", "idiom" : "ipad", "filename" : "Icon-App-40x40@2x-ipad.png", "scale" : "2x" },
    { "size" : "76x76", "idiom" : "ipad", "filename" : "Icon-App-76x76@1x.png", "scale" : "1x" },
    { "size" : "76x76", "idiom" : "ipad", "filename" : "Icon-App-76x76@2x.png", "scale" : "2x" },
    { "size" : "83.5x83.5", "idiom" : "ipad", "filename" : "Icon-App-83.5x83.5@2x.png", "scale" : "2x" },
    { "size" : "1024x1024", "idiom" : "ios-marketing", "filename" : "Icon-App-1024x1024@1x.png", "scale" : "1x" }
  ],
  "info" : { "version" : 1, "author" : "xcode" }
}
JSON

rm -f /tmp/make_airship_overlay.swift /tmp/composite_airship.swift /tmp/airship_overlay.png appicon-1024-base.png
ls -1 *.png | cat
