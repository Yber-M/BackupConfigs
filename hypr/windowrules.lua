-- Reglas propias de ventanas y capas.
-- Migración limpia desde windowrules.conf.
-- No incluye reglas visuales/genéricas heredadas de HyDE.

--------------------------------------------------
-- IDLE INHIBIT
--------------------------------------------------

-- Reproductores de vídeo: impedir suspensión mientras estén fullscreen.
hl.window_rule({
    match = {
        class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$",
    },
    idle_inhibit = "fullscreen",
})

-- Navegadores: impedir suspensión mientras haya contenido fullscreen.
hl.window_rule({
    match = {
        class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$",
    },
    idle_inhibit = "fullscreen",
})

--------------------------------------------------
-- PICTURE IN PICTURE
--------------------------------------------------

hl.window_rule({
    name = "picture-in-picture",
    match = {
        title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$",
    },
    float = true,
    keep_aspect_ratio = true,
    move = {
        "(monitor_w*0.73)",
        "(monitor_h*0.72)",
    },
    size = {
        "(monitor_w*0.25)",
        "(monitor_h*0.25)",
    },
    pin = true,
})

--------------------------------------------------
-- WORKSPACES DE APLICACIONES
--------------------------------------------------

-- WhatsApp / Ferdium -> workspace 2
hl.window_rule({
    match = { class = "^ferdium$" },
    workspace = "2 silent",
})

-- Discord -> workspace 3
hl.window_rule({
    match = { class = "^discord$" },
    workspace = "3 silent",
})

-- Cider -> workspace 4
hl.window_rule({
    match = { class = "^cider$" },
    workspace = "4 silent",
})

--------------------------------------------------
-- COPYQ
--------------------------------------------------

hl.window_rule({
    match = { class = "^com.github.hluk.copyq$" },
    float = true,
    size = { 760, 560 },
    center = true,
})

--------------------------------------------------
-- JUEGOS
--------------------------------------------------

-- Control
hl.window_rule({
    match = { class = "^(control_dx12\\.exe)$" },
    workspace = "6 silent",
    fullscreen = true,
    opacity = "1 override 1 override 1 override",
    idle_inhibit = "fullscreen",
})

-- Juegos lanzados por Steam
hl.window_rule({
    match = { class = "^(steam_app_.*)$" },
    workspace = "6 silent",
    fullscreen = true,
    opacity = "1 override 1 override 1 override",
    idle_inhibit = "fullscreen",
})

-- Heroic Launcher
hl.window_rule({
    match = { class = "^heroic$" },
    workspace = "6 silent",
    opacity = "1 override 1 override 1 override",
})

--------------------------------------------------
-- CALCULADORA
--------------------------------------------------

hl.window_rule({
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
    center = true,
    size = { 420, 620 },
})

--------------------------------------------------
-- XPAD
--------------------------------------------------

hl.window_rule({
    match = { class = "^(xpad)$" },
    float = true,
    center = true,
    size = { 520, 420 },
})

--------------------------------------------------
-- TERMINAL FLOTANTE
--------------------------------------------------

hl.window_rule({
    match = { class = "^(floating-terminal)$" },
    float = true,
    center = true,
    size = { 1100, 720 },
})

--------------------------------------------------
-- MODRINTH
--------------------------------------------------

hl.window_rule({
    match = { class = "^(ModrinthApp)$" },
    float = true,
    center = true,
    size = { 1200, 700 },
})

--------------------------------------------------
-- PWVUCONTROL
--------------------------------------------------

hl.window_rule({
    match = { class = "^(com\\.saivert\\.pwvucontrol)$" },
    float = true,
    center = true,
    size = { 900, 600 },
})

--------------------------------------------------
-- MATSHELL / LAYER SHELL
--------------------------------------------------

hl.layer_rule({
    match = { namespace = "gtk4-layer-shell" },
    blur = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    match = { namespace = "bar" },
    blur = true,
    ignore_alpha = 0.2,
})
