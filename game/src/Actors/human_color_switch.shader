shader_type canvas_item;

uniform vec4 sprite_light_color : hint_color;
uniform vec4 light_color : hint_color;

uniform vec4 sprite_dark_color : hint_color;
uniform vec4 dark_color : hint_color;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
	
	// Color 1
    vec4 d4 = abs(col - sprite_light_color);
    float d = max(max(d4.r, d4.g), d4.b);
    if(d < 0.5) {
        col = light_color;
		COLOR = col;
		return
    }
	
		// Color 1
    d4 = abs(col - sprite_dark_color);
    d = max(max(d4.r, d4.g), d4.b);
    if(d < 0.5) {
        col = dark_color;
		COLOR = col;
		return
    }
	
    COLOR = col;
}