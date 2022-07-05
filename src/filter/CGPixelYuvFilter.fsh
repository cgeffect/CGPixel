precision highp float;
uniform sampler2D tex;
varying vec2 vTextureCoord;

uniform float width;
uniform float height;
uniform float offset;
uniform vec3 scal;

void main(void) {
    vec2 nowTxtPos = vTextureCoord;
    vec2 size = vec2(width, height);
    //y
    if (nowTxtPos.y<0.25) {
        //y1 postion
        vec2 now_pos = nowTxtPos * size;
        vec2 basePos = now_pos * vec2(4.0,4.0);
        float addY = float(int(basePos.x / width));
        basePos.x = basePos.x - addY * width;
        basePos.y += addY;

        float y1,y2,y3,y4;
        vec2 samplingPos = basePos / size;
        vec4 texel = texture2D(tex, samplingPos);
        y1 = dot(texel.rgb, scal);
        y1 += offset;

        basePos.x+=1.0;
        samplingPos = basePos/size;
        texel = texture2D(tex, samplingPos);
        y2 = dot(texel.rgb, scal);
        y2 += offset;

        basePos.x+=1.0;
        samplingPos = basePos/size;
        texel = texture2D(tex, samplingPos);
        y3 = dot(texel.rgb, scal);
        y3 += offset;

        basePos.x+=1.0;
        samplingPos = basePos/size;
        texel = texture2D(tex, samplingPos);
        y4 = dot(texel.rgb, scal);
        y4 += offset;

        gl_FragColor = vec4(y1, y2, y3, y4);
    }
}

