shader_type canvas_item;
uniform float progress: hint_range(0.0, 1.0, 0.1);
void vertex() {
	
}

void fragment() {
  vec4 tex_color = texture(TEXTURE, UV);

    // Cortamos el sprite gradualmente de abajo hacia arriba
    if (UV.y > progress) {
        discard; // No dibuja el píxel
    }

    COLOR = tex_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
