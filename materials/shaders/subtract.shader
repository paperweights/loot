shader_type canvas_item;

uniform vec4 subtract_color: hint_color;


void fragment()
{
	COLOR = texture(TEXTURE, UV) - subtract_color;
}