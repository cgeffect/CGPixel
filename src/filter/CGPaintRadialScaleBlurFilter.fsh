precision highp float;

varying vec2 varyTextCoord;
uniform sampler2D uTexture;
uniform vec2 uSize;
uniform vec2 uCenter;
uniform float uCount;

highp float rand( const in vec2 uv) {
    const highp float a = 12.9898, b = 78.233, c = 43758.5453;
    highp float dt = dot( uv.xy, vec2( a, b ) ), sn = mod( dt, 3.14159 );
    return fract(sin(sn) * c);
}

void main() {
    vec2 texCoord = varyTextCoord;
    vec2 center = uCenter / uSize;
    vec2 toCenter = center - texCoord;

    float strength = uCount * 0.01;
    float offset = rand(texCoord);

    vec4 color = vec4(0.0);
    for (float t = 0.0; t <= 20.0; t++) {
        float percent = (t - 10.0 + offset) * 0.0225;
        color += texture2D(uTexture, texCoord + toCenter * percent * strength);
    }
    gl_FragColor = color * 0.05;
}
