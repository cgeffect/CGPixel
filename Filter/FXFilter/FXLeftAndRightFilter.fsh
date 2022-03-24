precision highp float;

varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

void main() {
    lowp vec2 uv = textureCoordinate.xy;
    highp vec4 rgba = vec4(0.0);
    if (uv.x <= 0.5) {
        rgba = texture2D(inputImageTexture, vec2(uv.x * 2.0, uv.y));
    } else {
        rgba = texture2D(inputImageTexture2, vec2((uv.x - 0.5) * 2.0, uv.y));
    }
    gl_FragColor = rgba;
}
