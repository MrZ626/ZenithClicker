local sd = {}

sd.coloring = GC.newShader [[
    vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
        return vec4(color.rgb, color.a * texture2D(tex, texCoord).a);
    }
]]

sd.throb = GC.newShader [[
    vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
        vec4 t = texture2D(tex, texCoord);
        return vec4(1., 0., 0., (1.-step(t.a, .999)) * color.a * (1. - t.r) * (1. - length(texCoord.xy - .5)));
    }
]]

sd.swapRG = GC.newShader [[
    vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
        vec4 t = texture2D(tex, texCoord);
        return vec4(t.grb, color.a * t.a);
    }
]]

return sd
