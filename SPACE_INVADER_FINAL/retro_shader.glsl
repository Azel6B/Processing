#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture;
uniform vec2 resolution;

void main() {
  vec2 uv = gl_FragCoord.xy / resolution.xy;

  // Adjust these values to change the pixelation level
  float pixelationX = 250.0; // Number of "pixels" horizontally
  float pixelationY = 250.0; // Number of "pixels" vertically

  // Calculate the pixelated UV coordinates
  vec2 pixelatedUV = floor(uv * vec2(pixelationX, pixelationY)) / vec2(pixelationX, pixelationY);

  // Sample the texture at the pixelated coordinates
  gl_FragColor = texture2D(texture, pixelatedUV);
}
