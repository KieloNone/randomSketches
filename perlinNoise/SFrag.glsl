varying vec4 vertTexCoord;
varying vec4 vertColor;
uniform sampler2D textureIn;

void main() {
    //vec4 color=texture2D(textureIn, vertTexCoord.st);
    vec4 color=vec4(texture2D(textureIn,vertTexCoord.st).rgb,1);
    gl_FragColor=vertColor*color;
}
