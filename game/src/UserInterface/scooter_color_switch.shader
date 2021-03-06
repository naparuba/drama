shader_type canvas_item;

uniform vec4 whiteColor : hint_color = vec4(0.627, 0.812, 0.039, 1.0);
uniform vec4 lightGreyColor : hint_color = vec4(0.549, 0.749, 0.039, 1.0);
uniform vec4 darkGreyColor : hint_color = vec4(0.18, 0.451, 0.125, 1.0);
uniform vec4 blackColor : hint_color = vec4(0.0, 0.247, 0.0, 1.0);

float min4(float a, float b, float c, float d){
	return min(a, min(b, min(c, d)));
}

void fragment(){
	vec4 currentColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	float blackDistance = distance(currentColor, vec4(vec3(0.0), 1.0));
	float whiteDistance = distance(currentColor, vec4(vec3(1.0), 1.0));
	float lightGrayDistance = distance(currentColor, vec4(vec3(0.666, 0.666, 0.666), 1.0));
	float darkGrayDistance = distance(currentColor, vec4(vec3(0.333, 0.333, 0.333), 1.0));
	
	if (
		whiteDistance == min4(whiteDistance, lightGrayDistance, darkGrayDistance, blackDistance)
	)
	{
		COLOR = whiteColor;
	}
	else if (
		blackDistance == min4(whiteDistance, lightGrayDistance, darkGrayDistance, blackDistance)
	)
	{
		COLOR = blackColor;
	}
	else if (
		darkGrayDistance == min4(whiteDistance, lightGrayDistance, darkGrayDistance, blackDistance)
	)
	{
		COLOR = darkGreyColor;
	}
	else if (
		lightGrayDistance == min4(whiteDistance, lightGrayDistance, darkGrayDistance, blackDistance)
	)
	{
		COLOR = lightGreyColor;
	}
	else{
		COLOR = whiteColor;
	}
}