shader_type canvas_item;

uniform sampler2D mask_texture;
uniform float offset_x;
uniform float offset_y;

// NOTE: change if mask size is changed!
const float mask_width = 150.0;
const float mask_hight = 100.0;



void fragment() {
    vec4 colour = texture(TEXTURE, UV);
	float offset_x_pct = offset_x / mask_width;
	float offset_y_pct = offset_y / mask_hight;
	vec2 mask_texture_position = vec2(UV.x + offset_x_pct, UV.y + offset_y_pct);
    colour.a *= texture(mask_texture, mask_texture_position).a;

    COLOR = colour;
}