precision highp float;

varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

void main() {
    lowp vec2 uv = textureCoordinate.xy;
    if (uv.x <= 0.5) {
        lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
        lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
        
        gl_FragColor = vec4(mix(textureColor.rgb, textureColor2.rgb, 0.2), textureColor.a);
    } else {
        lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
        lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
        
        gl_FragColor = vec4(mix(textureColor2.rgb, textureColor.rgb, 0.2), textureColor2.a);
        
    }
}
