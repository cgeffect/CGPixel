precision highp float;
varying vec2 vTexCoord;
uniform sampler2D uTexture;
uniform float width;
uniform float height;

//图像宽度 *0.5 图像高度的范围内数据是正确的
void main() {
    vec2 samplingPos = vec2(0.0, 0.0);
    vec4 texel = vec4(0.0, 0.0, 0.0, 0.0);

    vec3 offset = vec3(0.0625, 0.5, 0.5);
    //颜色系数矩阵 若输出颜色偏色可尝试交换ucoeff和vcoeff
    vec3 ycoeff = vec3(0.256816, 0.504154, 0.0979137);
    vec3 ucoeff = vec3(-0.148246, -0.29102, 0.439266);
    vec3 vcoeff = vec3(0.439271, -0.367833, -0.071438);

    vec2 nowTxtPos = vTexCoord;
    vec2 size = vec2(width, height);

    vec2 yScale = vec2(4, 1);
    vec2 uvScale = vec2(8, 2);
    /*
        总大小为w*h*4  YUV420Pw*h*3/2
        y w*h / w*h*4 = 0.25
        uv = w*h*3/2 - w*h = 0.5, uv各占0.25, 总共是4, 即各占1/16 = 0.0625
    */
    if (nowTxtPos.x < 0.25) {
        vec2 basePos1 = (nowTxtPos * size);
        vec2 basePos = vec2(int(basePos1.x), int(basePos1.y)) * yScale;
        float y1, y2, y3, y4;

        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        y1 = dot(texel.bgr, ycoeff);
        y1 += offset.x;

        basePos.x += 1.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        y2 = dot(texel.bgr, ycoeff);
        y2 += offset.x;

        basePos.x += 1.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        y3 = dot(texel.bgr, ycoeff);
        y3 += offset.x;

        basePos.x += 1.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        y4 = dot(texel.bgr, ycoeff);
        y4 += offset.x;

        gl_FragColor = vec4(y1, y2, y3, y4);

    }else if (nowTxtPos.x >= 0.25 && nowTxtPos.x < 0.375 && nowTxtPos.y < 0.5) {
        nowTxtPos.x -= 0.25;
        vec2 basePos1 = (nowTxtPos * size);
        vec2 basePos = vec2(int(basePos1.x), int(basePos1.y)) * uvScale;
        float v1, v2, v3, v4;

        basePos.x += 0.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        v1 = dot(texel.bgr, vcoeff);
        v1 += offset.z;

        basePos.x += 2.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        v2 = dot(texel.bgr, vcoeff);
        v2 += offset.z;

        basePos.x += 2.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        v3 = dot(texel.bgr, vcoeff);
        v3 += offset.z;

        basePos.x += 2.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        v4 = dot(texel.bgr, vcoeff);
        v4 += offset.z;

        gl_FragColor = vec4(v1, v2, v3, v4);
    } else if (nowTxtPos.x >= 0.25 && nowTxtPos.x < 0.375 && nowTxtPos.y >= 0.5) {
        nowTxtPos.x -= 0.25;
        nowTxtPos.y -= 0.5;

        vec2 basePos1 = (nowTxtPos * size);
        vec2 basePos = vec2(int(basePos1.x), int(basePos1.y)) * uvScale;
        float u1, u2, u3, u4;

        basePos.x += 0.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        u1 = dot(texel.bgr, ucoeff);
        u1 += offset.y;

        basePos.x += 2.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        u2 = dot(texel.bgr, ucoeff);
        u2 += offset.y;

        basePos.x += 2.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        u3 = dot(texel.bgr, ucoeff);
        u3 += offset.y;

        basePos.x += 2.0;
        basePos.y += 0.0;
        samplingPos = basePos / size;
        texel = texture2D(uTexture, samplingPos);
        u4 = dot(texel.bgr, ucoeff);
        u4 += offset.y;

        gl_FragColor = vec4(u1, u2, u3, u4);
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
