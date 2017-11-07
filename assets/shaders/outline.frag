#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D tex0;
uniform vec2 pixelSize;
varying vec2 tcoord;
varying vec4 color;

void main() {
    vec4 texcolor = texture2D(tex0, tcoord);
    
    if (texcolor.a == 0.0) {
        if (texture2D(tex0, tcoord + vec2(-pixelSize.x, 0)).a > 0.0) {
            texcolor = vec4(0.0,0.0,0.0,1.0);
        }
        if (texture2D(tex0, tcoord + vec2(pixelSize.x, 0)).a > 0.0) {
            texcolor = vec4(0.0,0.0,0.0,1.0);
        }
        if (texture2D(tex0, tcoord + vec2(0, -pixelSize.y)).a > 0.0) {
            texcolor = vec4(0.0,0.0,0.0,1.0);
        }
        if (texture2D(tex0, tcoord + vec2(0, pixelSize.y)).a > 0.0) {
            texcolor = vec4(0.0,0.0,0.0,1.0);
        }
    }
    
    gl_FragColor = color * texcolor;
}