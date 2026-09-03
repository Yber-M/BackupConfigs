-- Config propia de Hyprland (post-HyDE). Ver DESIGN/NOTAS en BackupConfigs.

---- MONITORES ----
hl.monitor({ output = "desc:Samsung Electric Company LS32AG55x HNTTC00172",
             mode = "2560x1440@144.0", position = "1600x0", scale = 1.0 })
hl.monitor({ output = "desc:LG Display 0x07A3",
             mode = "2560x1600@240.0", position = "0x440", scale = 1.6 })

---- ENTORNO (NVIDIA) ----
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("GBM_BACKEND", "nvidia-drm")

---- ASPECTO ----
hl.config({
    cursor = { no_hardware_cursors = true },

    general = {
        gaps_in = 3, gaps_out = 8, border_size = 2,
        col = {
            active_border   = { colors = {"rgba(bb9af7ff)", "rgba(b4f9f8ff)"}, angle = 45 },
            inactive_border = { colors = {"rgba(565f89cc)", "rgba(9aa5cecc)"}, angle = 45 },
        },
        layout = "dwindle",
        resize_on_border = true,
    },

    decoration = {
        rounding = 10,
        active_opacity = 0.95,
        inactive_opacity = 0.88,
        shadow = { enabled = false },
        blur = {
            enabled = true, size = 6, passes = 3,
            new_optimizations = true, ignore_opacity = true,
            xray = false, popups = true, popups_ignorealpha = 0.2,
        },
    },

    dwindle = { preserve_split = true },
    animations = { enabled = true },
})

---- ANIMACIONES ----
hl.curve("wind",   { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winIn",  { type = "bezier", points = { {0.1, 1.1},  {0.1, 1.1}  } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1}      } })
hl.curve("liner",  { type = "bezier", points = { {1, 1},      {1, 1}      } })

hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,  bezier = "winIn",  style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner",  style = "once" })
hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "wind" })

---- ENTRADA ----
hl.config({
    input = {
        kb_layout = "us,latam",
        follow_mouse = 1,
        touchpad = { natural_scroll = false },
    },
})

hl.device({ name = "logitech-g502-x-plus", sensitivity = -0.2, scroll_factor = 0.65 })

---- PLUGINS ----
-- TODO: la sintaxis Lua de dynamic-cursors no esta confirmada (plugin de
-- terceros, no del nucleo). El plugin sigue cargado por hyprpm, solo
-- queda sin esta personalizacion de modo tilt hasta investigar la API.
-- hl.config({
--     plugin = {
--         ["dynamic-cursors"] = {
--             enabled = true,
--             mode = "tilt",
--             rotate = { length = 24, offset = 0.0 },
--         },
--     },
-- })

---- AUTOSTART ----
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/monitor-layout.sh")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/autostart.sh")
end)
require("keybindings")
