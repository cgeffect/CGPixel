precision highp float;

varying vec2 varyTextCoord;
uniform sampler2D uTexture;

uniform float Time;

void main (void) {
    float duration = 0.7;
    float maxScale = 1.1;
    float offset = 0.02;
    
    float progress = mod(Time, duration) / duration; // 0~1
    vec2 offsetCoords = vec2(offset, offset) * progress;
    float scale = 1.0 + (maxScale - 1.0) * progress;
    
    vec2 ScaleTextureCoords = vec2(0.5, 0.5) + (varyTextCoord - vec2(0.5, 0.5)) / scale;
    
    vec4 maskR = texture2D(uTexture, ScaleTextureCoords + offsetCoords);
    vec4 maskB = texture2D(uTexture, ScaleTextureCoords - offsetCoords);
    vec4 mask = texture2D(uTexture, ScaleTextureCoords);
    
    gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a);
}

