shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D palette;

void fragment()
{
	vec4 colour = texture(TEXTURE, UV);
	vec2 position = vec2(colour.r, 1.0 - colour.g);
	vec4 new_colour = texture(palette, position);
	new_colour.a = colour.a;
	COLOR = new_colour;
}