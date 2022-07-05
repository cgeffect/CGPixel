precision highp float;

varying vec2 vTexCoord;

uniform sampler2D uTexture;

vec2 texSize = vec2(400.0, 400.0);
vec2 mosaicSize = vec2(8,8);

void main(void) {
    vec2 vUV = vTexCoord;
    vec2 intXY = vec2(vUV.x * texSize.x, vUV.y * texSize.y);
    vec2 XYMosaic = vec2(floor(intXY.x / mosaicSize.x) * mosaicSize.x, floor(intXY.y / mosaicSize.y) * mosaicSize.y);
    vec2 UVMosaic = vec2(XYMosaic.x / texSize.x, XYMosaic.y / texSize.y);
    vec4 baseMap = texture2D(uTexture, UVMosaic);
    gl_FragColor = baseMap;
}
