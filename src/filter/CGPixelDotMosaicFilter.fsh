precision highp float;

varying vec2 vTexCoord;

uniform sampler2D uTexture;

vec2 texSize = vec2(400.0, 400.0);
vec2 mosaicSize = vec2(8,8);

void main(void) {
    vec2 vUV = vTexCoord;
    vec2 intXY = vec2(vUV.x * texSize.x, vUV.y * texSize.y);
    vec2 XYMosaic = vec2(floor(intXY.x / mosaicSize.x) * mosaicSize.x + 0.5 * mosaicSize.x, floor(intXY.y / mosaicSize.y) * mosaicSize.y + 0.5 * mosaicSize.y);
    vec2 UVMosaic = vec2(XYMosaic.x / texSize.x, XYMosaic.y / texSize.y);

    vec2 delXY = XYMosaic - intXY;
    float delL = length(delXY);

    vec4 finalColor;
    if(delL < 0.5 * mosaicSize.x) {
        finalColor = texture2D(uTexture, UVMosaic);
    }
    else {
        finalColor = texture2D(uTexture, vUV);
    }

    gl_FragColor = finalColor;
}
