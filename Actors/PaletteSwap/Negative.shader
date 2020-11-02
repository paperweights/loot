shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform vec4 mod_colour: hint_color;

void fragment()
{
	vec4 colour = texture(TEXTURE, UV) - mod_colour;
	COLOR = colour;
}