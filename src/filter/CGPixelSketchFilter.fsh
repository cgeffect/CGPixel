precision highp float;

varying vec2 vTexCoord;

uniform sampler2D uTexture;

// Change me!!!
vec2 texSize = vec2(400.0, 400.0);

mat3 kernel = mat3(
    -0.5, -1.0, -1.0,
    -1.0,  0.0,  1.0,
     0.0,  1.0,  0.5
);

vec4 dip_filter(mat3 _filter, sampler2D _image, vec2 _xy, vec2 texSize)
{
    mat3 _filter_pos_delta_x = mat3(
        vec3(-1.0, 0.0, 1.0),
        vec3( 0.0, 0.0, 1.0),
        vec3( 1.0, 0.0, 1.0));
    mat3 _filter_pos_delta_y = mat3(
        vec3(-1.0,-1.0,-1.0),
        vec3(-1.0, 0.0, 0.0),
        vec3(-1.0, 1.0, 1.0));
      vec4 final_color = vec4(0.0, 0.0, 0.0, 0.0);
      for(int i = 0; i<3; i++) {
            for(int j = 0; j<3; j++) {
                  vec2 _xy_new = vec2(_xy.x + _filter_pos_delta_x[i][j], _xy.y + _filter_pos_delta_y[i][j]);
                  vec2 _uv_new = vec2(_xy_new.x/texSize.x, _xy_new.y/texSize.y);
                  final_color += texture2D(_image,_uv_new) * _filter[i][j];
            }
      }
      return final_color;
}

void main(void) {
    vec2 vUV = vTexCoord;
    vec2 intXY = vec2(vUV.x * texSize.x, vUV.y * texSize.y);
    vec4 delColor = dip_filter(kernel, uTexture, intXY, texSize);
    float deltaGray = 0.3*delColor.x + 0.59*delColor.y + 0.11*delColor.z;
    if(deltaGray < 0.0) deltaGray = -1.0 * deltaGray;
    deltaGray = 1.0 - deltaGray;
    gl_FragColor = vec4(vec3(deltaGray), 1.0);
}
