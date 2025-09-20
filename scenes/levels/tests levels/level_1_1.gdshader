shader_type canvas_item;

uniform bool rainbow_enabled = false;
uniform float precision : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float strength : hint_range(0.0, 1.0) = 0.3;
uniform float speed : hint_range(0.0, 10.0) = 0.5;
uniform float angle : hint_range(0.0, 360.0) = 45.0;
uniform int sprite_sheet_columns : hint_range(1, 16) = 1;
uniform int sprite_sheet_rows : hint_range(1, 16) = 1;

uniform vec4 OLDCOLOR1 : source_color;
uniform vec4 OLDCOLOR2 : source_color;
uniform vec4 OLDCOLOR3 : source_color;
uniform vec4 OLDCOLOR4 : source_color;
uniform vec4 OLDCOLOR5 : source_color;

uniform vec4 NEWCOLOR1 : source_color;
uniform vec4 NEWCOLOR2 : source_color;
uniform vec4 NEWCOLOR3 : source_color;
uniform vec4 NEWCOLOR4 : source_color;
uniform vec4 NEWCOLOR5 : source_color;

float when_lt(float x, float y) {
    return max(sign(y - x), 0.0);
}

void fragment() {
    vec4 currentColor = texture(TEXTURE, UV);
	if (distance(currentColor, OLDCOLOR1) < 0.1) {
		COLOR = NEWCOLOR1;
	} else if (distance(currentColor, OLDCOLOR2) < 0.1) {
		COLOR = NEWCOLOR2;
	} else if (distance(currentColor, OLDCOLOR3) < 0.1) {
		COLOR = NEWCOLOR3;
	} else if (distance(currentColor, OLDCOLOR4) < 0.1) {
		COLOR = NEWCOLOR4;
	} else if (distance(currentColor, OLDCOLOR5) < 0.1) {
		COLOR = NEWCOLOR5;
	}
	else {
		COLOR = currentColor;
			}
    // Si el pixel es transparente o negro, no aplicamos efectos
    if (distance(currentColor.rgb, vec3(0.0)) < 0.05 || currentColor.a < 0.05) {
        COLOR = currentColor;
    }

    vec4 finalColor = currentColor;

    // Efecto arcoíris si está habilitado
    if (rainbow_enabled) {
        vec2 sprite_sheet_size = vec2(textureSize(TEXTURE, 0));
        vec2 frame_size = sprite_sheet_size / vec2(float(sprite_sheet_columns), float(sprite_sheet_rows));
        vec2 current_point = sprite_sheet_size * UV;

        float row = floor(current_point.y / frame_size.y);
        float column = floor(current_point.x / frame_size.x);
        vec2 max_point = (frame_size * vec2(column, row)) + frame_size;
        vec2 new_uv = 1.0 - (max_point - current_point) / frame_size;

        float hue = new_uv.x * cos(radians(angle)) - new_uv.y * sin(radians(angle));
        hue = fract(hue + fract(TIME * speed));
        float x = 1.0 - abs(mod(hue / (1.0 / 6.0), 2.0) - 1.0);

        vec3 rainbow = vec3(0.0);
        rainbow += vec3(1.0, x, 0.0) * when_lt(hue, 1.0/6.0);
        rainbow += vec3(x, 1.0, 0.0) * when_lt(hue, 1.0/3.0) * when_lt(1.0/6.0, hue);
        rainbow += vec3(0.0, 1.0, x) * when_lt(hue, 1.0/2.0) * when_lt(1.0/3.0, hue);
        rainbow += vec3(0.0, x, 1.0) * when_lt(hue, 2.0/3.0) * when_lt(1.0/2.0, hue);
        rainbow += vec3(x, 0.0, 1.0) * when_lt(hue, 5.0/6.0) * when_lt(2.0/3.0, hue);
        rainbow += vec3(1.0, 0.0, x) * when_lt(hue, 1.1) * when_lt(5.0/6.0, hue);

        finalColor.rgb = mix(finalColor.rgb, rainbow, strength);
    

    // Efecto de parpadeo si está habilitado

	finalColor.a *= COLOR.a;
	COLOR = finalColor;
	}


}