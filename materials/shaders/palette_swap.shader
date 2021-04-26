shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D palette;


void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	vec2 position = vec2(color.r, color.g);
	COLOR = texture(palette, position);
}