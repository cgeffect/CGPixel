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

mat2 rotate2d(float angle) {
    vec2 sc = vec2(sin(angle), cos(angle));
    return mat2( sc.y, sc.x, -sc.x, sc.y );
}

void main() {
    float factor = uCount * 3.14159 * 0.00025;

    vec2 loc_tex = varyTextCoord * uSize;
    vec2 loc_cnt = uCenter;
    vec2 loc_dist = loc_tex - loc_cnt;

    float offset = rand(loc_dist);
    vec4 color = vec4(0.0);

    for (int i = 0; i < 20; i++) {
        vec2 loc_tmp = rotate2d(factor * (float(i-10) + offset)) * loc_dist;
        loc_tex = loc_cnt + loc_tmp;
        loc_tex /= uSize;
        color += texture2D(uTexture, loc_tex);
    }

    gl_FragColor = color * 0.05;
}
