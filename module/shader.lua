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

sd.hueShift = GC.newShader [[
    uniform float hueShift; // 0-1

    vec3 rgb2hsv(vec3 c) {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }

    vec3 hsv2rgb(vec3 c) {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }

    vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
        vec4 t = texture2D(tex, texCoord);
        vec3 hsv = rgb2hsv(t.rgb);
        hsv.x = mod(hsv.x + hueShift, 1.0);
        vec3 rgb = hsv2rgb(hsv);
        return vec4(rgb, color.a * t.a);
    }
]]

return sd
