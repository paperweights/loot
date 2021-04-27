shader_type canvas_item;

uniform vec4 subtract_color: hint_color;


void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR = screen_color - subtract_color * 1.0 - color.a;
}