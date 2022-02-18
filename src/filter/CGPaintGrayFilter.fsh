precision highp float;

varying vec2 varyTextCoord;
uniform sampler2D uTexture;

void main() {
    vec4 mask = texture2D(uTexture, varyTextCoord);
    float v = (mask.r + mask.g + mask.b) / 3.0;
    if (varyTextCoord.x > 0.5) {
        gl_FragColor = vec4(vec3(v), mask.a);
    } else {
        gl_FragColor = mask;
    }
}
