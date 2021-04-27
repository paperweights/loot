shader_type canvas_item;

uniform vec4 subtract_color: hint_color;


void fragment()
{
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 result = color - subtract_color;
	result.g = color.g;
	COLOR = result;
}