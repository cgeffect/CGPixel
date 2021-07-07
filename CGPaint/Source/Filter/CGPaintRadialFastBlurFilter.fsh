precision highp float;

uniform sampler2D uTexture;
varying vec2 varyTextCoord;

const vec2 BLUR_CENTER = vec2(0.5, 0.5);
const int NUM_SAMPLES = 70;

uniform float ratio;//0-1
void main() {
    vec2 curPos = varyTextCoord;
    float strength = ratio / float(NUM_SAMPLES);
    vec2 dir = BLUR_CENTER - curPos;
    vec2 blurVector = dir * strength;
    vec4 accumulateColor = texture2D(uTexture, curPos);
    for (int i = 0; i < NUM_SAMPLES; i++) {
        accumulateColor += texture2D(uTexture, curPos);
        curPos.xy += blurVector.xy;
    }

    vec4 result = accumulateColor/vec4(NUM_SAMPLES);
    gl_FragColor = result;
}
