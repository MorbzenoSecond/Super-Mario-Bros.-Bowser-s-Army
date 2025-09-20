shader_type canvas_item;

uniform bool active = true;
uniform vec4 flame_color: source_color = vec4(0.2, 0.463, 1, 1.0); // color cálido
uniform float intensity: hint_range(0.0, 1.0) = 0.761;              // fuerza del efecto
uniform float flicker_speed: hint_range(0.1, 10.0) = 9;         // velocidad de parpadeo
uniform float radius: hint_range(0.0, 1.0) = 0.9;                 // radio de la luz
uniform vec2 flicker_offset = vec2(0.05, 0.05);                   // desplazamiento de parpadeo

void fragment() {
    if (active) {
        
    

    vec2 center = vec2(0.5, 0.5); // centro del resplandor
    // añade un pequeño movimiento aleatorio para simular parpadeo
    vec2 flicker = vec2(sin(TIME * flicker_speed), cos(TIME * flicker_speed)) * flicker_offset;
    
    float dist = length(UV - center + flicker);

    // caída radial de la luz (suave)
    float glow = smoothstep(radius, 0.0, dist);

    // añade una pequeña variación en la intensidad para simular parpadeo
    // glow *= 0.7 + 0.3 * sin(TIME * flicker_speed * 1.5 + dist * 10.0);

    vec4 tex_color = texture(TEXTURE, UV);
    vec4 final_color = mix(tex_color, flame_color, glow * intensity);
	vec4 color = texture(TEXTURE, UV);
	if (color.a == 0.0) 
	{ COLOR = color; }
	else{
    COLOR = final_color;
	}
	}
}
