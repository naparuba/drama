shader_type canvas_item;

uniform vec4 u_color_key : hint_color;
uniform vec4 u_replacement_color : hint_color;

uniform vec4 u_color2_key : hint_color;
uniform vec4 u_replacement_color2 : hint_color;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
	
	// Color 1
    vec4 d4 = abs(col - u_color_key);
    float d = max(max(d4.r, d4.g), d4.b);
    if(d < 0.5) {
        col = u_replacement_color;
		COLOR = col;
		return
    }
	
		// Color 1
    d4 = abs(col - u_color2_key);
    d = max(max(d4.r, d4.g), d4.b);
    if(d < 0.5) {
        col = u_replacement_color2;
		COLOR = col;
		return
    }
	
    COLOR = col;
}