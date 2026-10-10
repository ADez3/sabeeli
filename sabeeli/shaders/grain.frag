#version 460 core

// Monochrome film grain, drawn over gradients so they never band and feel like
// light rather than flat colour. One random value per physical pixel.

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uSeed;
uniform float uOpacity;

out vec4 fragColor;

float hash(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  float g = hash(floor(pos) + uSeed) - 0.5;
  // Lighter and darker specks around the colour beneath (premultiplied alpha).
  float a = abs(g) * 2.0 * uOpacity;
  vec3 c = g > 0.0 ? vec3(1.0) : vec3(0.0);
  fragColor = vec4(c * a, a);
}
