precision highp float;

varying vec2 varyTextCoord;
uniform sampler2D uTexture;
uniform vec3 uColor;
uniform float uRatio;

float hue2rgb(float p, float q, float t) {
    if(t < 0.0) t += 1.0;
    if(t > 1.0) t -= 1.0;
    if(t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if(t < 1.0/2.0) return q;
    if(t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec3 cvtHSL2RGB(float h, float s, float l){
    float r, g, b;
    if(s == 0.0){
        r = g = b = l; // achromatic
    }else{
        float q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
        float p = 2.0 * l - q;
        r = hue2rgb(p, q, h + 1.0/3.0);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1.0/3.0);
    }

    return vec3(r, g, b);
}

vec3 cvtRGB2HSL(float r, float g, float b) {
    float maxVal = max(r, max(g, b));
    float minVal = min(r, min(g, b));
    float h, s, l = (maxVal + minVal) / 2.0;

    if(maxVal == minVal){
        h = s = 0.0; // achromatic
    }else{
        float d = maxVal - minVal;
        s = l > 0.5 ? d / (2.0 - maxVal - minVal) : d / (maxVal + minVal);
        if (maxVal == r) h = (g - b) / d + (g < b ? 6.0 : 0.0);
        if (maxVal == g) h = (b - r) / d + 2.0;
        if (maxVal == b) h = (r - g) / d + 4.0;
        h /= 6.0;
    }
    return vec3(h, s, l);
}
//hsl
void main() {
    vec4 src = texture2D(uTexture, varyTextCoord);
    vec3 hsl = cvtRGB2HSL(src.r, src.g, src.b);

    vec3 color = vec3(0.0, 0.0, 1.0);
    float h = cvtRGB2HSL(color.r, color.g, color.b).x;

    vec3 rgb = cvtHSL2RGB(h, hsl.y, hsl.z);

    gl_FragColor = vec4(rgb, src.a);
}
