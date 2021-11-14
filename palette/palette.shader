shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D palette;


void fragment()
{
	vec2 position = texture(TEXTURE, UV).rg;
	COLOR = texture(palette, position);
}