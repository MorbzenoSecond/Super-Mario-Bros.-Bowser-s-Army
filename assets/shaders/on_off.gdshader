shader_type canvas_item;

uniform vec4 OLDCOLOR1 : source_color;
uniform vec4 OLDCOLOR2 : source_color;
uniform vec4 OLDCOLOR3 : source_color;
uniform vec4 OLDCOLOR4 : source_color;

uniform vec4 NEWCOLOR1 : source_color;
uniform vec4 NEWCOLOR2 : source_color;
uniform vec4 NEWCOLOR3 : source_color;
uniform vec4 NEWCOLOR4 : source_color;

void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);

	if (distance(curr_color, OLDCOLOR1) < 0.1) {
		COLOR = NEWCOLOR1;
	} else if (distance(curr_color, OLDCOLOR2) < 0.1) {
		COLOR = NEWCOLOR2;
	} else if (distance(curr_color, OLDCOLOR3) < 0.1) {
		COLOR = NEWCOLOR3;
	} else if (distance(curr_color, OLDCOLOR4) < 0.1) {
		COLOR = NEWCOLOR4;
	} else {
		COLOR = curr_color;
	}
}
