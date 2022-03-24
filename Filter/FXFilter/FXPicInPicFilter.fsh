precision highp float;

varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

void main() {
    lowp vec2 uv = textureCoordinate.xy;
    highp vec4 rgba = vec4(0.0);
    if (uv.x > 0.6 && uv.x < 0.9 &&
        uv.y > 0.6 && uv.y < 0.9) {
        vec2 xy = vec2(0);
        xy.x = (uv.x - 0.6) * 3.333;
        xy.y = (uv.y - 0.6) * 3.333;
        rgba = texture2D(inputImageTexture, vec2(xy));
    } else {
        rgba = texture2D(inputImageTexture2, vec2(uv.x, uv.y));
    }
    gl_FragColor = rgba;
}
