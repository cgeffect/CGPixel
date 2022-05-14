precision highp float;

varying vec2 varyTextCoord;
uniform sampler2D uTexture;
uniform vec3 uColor;
uniform float uRatio;

vec3 RGB2YUV(float r, float g, float b) {
    float y = 0.299 * r + 0.587 * g + 0.114 * b;
    float u = -0.169 * r - 0.331 * g + 0.500 * b;
    float v = 0.500 * r - 0.419 * g - 0.081 * b;
    return vec3(y, u, v);
}

vec3 YUV2RGB(float y, float u, float v) {
    float r = y + 1.402 * v;
    float g = y - 0.344 * u - 0.714 * v;
    float b = y + 1.772 * u;
    return vec3(r, g, b);
}

//yuv
void main() {
    vec4 src = texture2D(uTexture, varyTextCoord);
    vec3 yuv = RGB2YUV(src.r, src.g, src.b);

    vec3 color = vec3(1.0, 0.0, 0.0);
    vec2 uv = RGB2YUV(color.r, color.g, color.b).xy;

    vec3 rgb = YUV2RGB(yuv.x, uv.x, uv.y);

    gl_FragColor = vec4(rgb, src.a);
}
