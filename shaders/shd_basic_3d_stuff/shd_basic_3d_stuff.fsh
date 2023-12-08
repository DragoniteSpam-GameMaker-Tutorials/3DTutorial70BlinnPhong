varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

uniform vec3 u_LightPosition;
uniform float u_LightRadius;
uniform vec3 u_ViewPosition;

void main() {
    vec4 starting_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    vec3 ambient_color = vec3(0.1, 0.1, 0.1);
    vec3 light_color = vec3(0.8, 0.8, 0.8);
    vec3 light_dir = normalize(v_worldPosition - u_LightPosition);
    
    float specular_strength = 1.0;
    float specular_shininess = 32.0;
    vec3 view_dir = normalize(u_ViewPosition - v_worldPosition);
    vec3 reflect_dir = reflect(light_dir, v_worldNormal);
    
    float specular_intensity = pow(max(dot(view_dir, reflect_dir), 0.0), specular_shininess);
    vec3 specular_color = specular_strength * specular_intensity * light_color;
    
    float att = distance(u_LightPosition, v_worldPosition) / u_LightRadius;
    float NdotL = max(0.0, -dot(v_worldNormal, light_dir)) * att;
    vec3 diffuse_color = NdotL * light_color;
    
    vec3 final_color = starting_color.rgb * (ambient_color + diffuse_color + specular_color);
    gl_FragColor = vec4(final_color, starting_color.a);
}