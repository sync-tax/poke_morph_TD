// Morph - FragmentShader

uniform float progress;
uniform float offset;
uniform float strength;

vec4 morph()
{
	//Top Right Offset
	vec4 tr_from_color = texture(sTD2DInputs[0], vUV.xy + vec2(offset,offset)) * (1-progress);
	vec4 tr_to_color = texture(sTD2DInputs[1], vUV.xy + vec2(offset,offset)) * progress;
	//Top Right Offset
	vec4 br_from_color = texture(sTD2DInputs[0], vUV.xy + vec2(offset,-offset)) * (1-progress);
	vec4 br_to_color = texture(sTD2DInputs[1], vUV.xy + vec2(offset,-offset)) * progress;
	//Top Left Offset
	vec4 tl_from_color = texture(sTD2DInputs[0], vUV.xy + vec2(-offset,offset)) * (1-progress);
	vec4 tl_to_color = texture(sTD2DInputs[1], vUV.xy + vec2(-offset,offset)) * progress;
	//Top Right Offset
	vec4 bl_from_color = texture(sTD2DInputs[0], vUV.xy + vec2(-offset,-offset)) * (1-progress);
	vec4 bl_to_color = texture(sTD2DInputs[1], vUV.xy + vec2(-offset,-offset)) * progress;
	
	vec4 sx = ((tl_from_color + tl_to_color + bl_from_color + bl_to_color) - (tr_from_color + tr_to_color + br_from_color + br_to_color));
	
	vec4 sy = ((tr_from_color + tr_to_color + br_from_color + br_to_color) - (tl_from_color + tl_to_color + tr_from_color + tr_to_color));
	
	vec2 slope = vec2(sx.r + sx.g + sx.b + sx.a, sy.r + sy.g + sy.b + sy.a);
	
	float limiter = dot(slope,slope) + strength;
	 
	vec2 morph = (slope / limiter) * strength;
	
	vec2 morph_from = morph * (1-progress);
	vec2 morph_to = morph * progress;
	
	
	vec4 from_color = texture(sTD2DInputs[0], vUV.xy - morph_to) * (1-progress);
	vec4 to_color = texture(sTD2DInputs[1], vUV.xy - morph_from) * progress;
	
	return mix(from_color, to_color, progress);
}

out vec4 fragColor;
void main()
{
	vec4 color = morph();
	fragColor = TDOutputSwizzle(color);
}
