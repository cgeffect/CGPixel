precision highp float;
varying vec2 vTexCoord;
uniform sampler2D uTexture;
uniform vec3 uColor;
uniform float uRatio;
uniform float time;

void main() {
    // UV map
    vec2 uv = vTexCoord;

    // Input image
    vec4 image = texture(uTexture, uv);

    // Input colour
    vec3 color = vec3(sin(iTime),sin(iTime+1.0),sin(iTime+2.0))*0.5+0.5;
    color = vec3(1.0, 0.5, 1.0);

    // Perceptual greyscale
    // https://gist.github.com/Volcanoscar/4a9500d240497d3c0228f663593d167a
    // https://mouaif.wordpress.com/2009/01/05/photoshop-math-with-glsl-shaders/
    image.r = image.r * 0.3 + image.g * 0.7 + image.b * 0.1;

    // Centre the colour values using the RGB average
    vec3 power = (color.r+color.g+color.b)*0.3333-color;

    // Increase the perceptual saturation (this is the downside of simple RGB calculations - you easily lose hue/sat accuracy)
    power *= 2.0;

    // Colourise the original image
    image.rgb = pow(image.rrr, 1.0+power);

    // Output to screen
    gl_FragColor = (uv.x > 0.05) ? image : vec4(color, 1.0);
}
