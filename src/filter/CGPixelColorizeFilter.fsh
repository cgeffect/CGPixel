precision highp float;
varying vec2 vTexCoord;
uniform sampler2D uTexture;
uniform vec3 uColor;
uniform float uRatio;
uniform float time;

vec4 toGrayscale(in vec4 color)
{
  float average = (color.r + color.g + color.b) / 3.0;
  return vec4(average, average, average, 1.0);
}

vec4 colorize(in vec4 grayscale, in vec4 color)
{
  return (grayscale * color);
}

void main()
{
  // This is the color you want to apply
  // in the "colorize" step. Shoul ultimately be a uniform var.
  vec4 c = vec4(1.0, 0.0, 0.5, 1.0);

  // The input fragment color.
  // Can come from a texture, a varying or a contant.
  vec4 inputColor = texture2D(uTexture, vTexCoord);
  
  // Convert to grayscale first:
  vec4 grayscale = toGrayscale(inputColor);

  // Then "colorize" by simply multiplying the grayscale
  // with the desired color.
  vec4 colorizedOutput = colorize(grayscale, c);

  // Done!
  gl_FragColor = colorizedOutput;
}
