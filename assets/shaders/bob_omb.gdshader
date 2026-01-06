shader_type canvas_item;

uniform float flash_speed : hint_range(0.0, 10.0) = 1.0;
uniform float flash_strength : hint_range(0.0, 10.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.8, 0.2, 1.0); // color del flash

// Cuanto más fuerte el flash, más afecta el color base
uniform float flash_saturation = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Efecto tipo pulso basado en tiempo + velocidad
    float pulse = sin(TIME * flash_speed) * 0.5 + 0.5; // 0 -> 1

    // Combinar el pulso con la fuerza
    float intensity = pulse * flash_strength;

    // Multiplica la textura por un color brillante
    vec4 flash_effect = mix(tex, flash_color, intensity * flash_saturation);

    COLOR = flash_effect * tex.a;
}
