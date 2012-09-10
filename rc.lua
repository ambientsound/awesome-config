----- ambientsound's awesome config -----

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Vicious widgets
require("vicious")

-- Load our beauty
beautiful.init(awful.util.getdir("config") .. "/themes/ambient/theme.lua")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
altkey = "Mod1"
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.max
}
-- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[5])
end
-- }}}


-- {{{ Wibox
-- Create a textclock widget
spacer = awful.widget.textclock({ align = "right" }, " | ", 0)
textdate = awful.widget.textclock({ align = "right" }, " %a %d %b %Y ", 1)
textclock = awful.widget.textclock({ align = "right" }, " %H:%M:%S   ", 1)
textclock.color = beautiful.fg_bright

-- Create a systray
systray = widget({ type = "systray" })

-- Create a battery icon
textbat = widget({ type = "textbox" })
vicious.register(textbat, vicious.widgets.bat, " $2% ", 60, "BAT1")

-- Create a wibox for each screen and add it
wibox = {}
for s = 1, screen.count() do
    wibox[s] = awful.wibox({ position = "bottom", screen = s })
    wibox[s].widgets = {
        s == 1 and systray or nil,
        textclock,
        spacer,
        textdate,
        spacer,
        textbat,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    
    -- Move CDROM in and out
    awful.key({ modkey, "Control"   }, "KP_Add",        function () awful.util.spawn("eject") end),
    awful.key({ modkey, "Control"   }, "KP_Subtract",   function () awful.util.spawn("eject -t") end),

    -- dmenu
    awful.key({ modkey      }, " ",         function () awful.util.spawn("dmenu_run") end),

    -- Tag movement
    awful.key({ modkey      }, "Tab",       function () awful.screen.focus_relative(1) end),
    awful.key({ modkey      }, "n",         function () awful.screen.focus_relative(1) end),
    awful.key({ altkey      }, "Escape",        awful.tag.history.restore),

    -- Screen movement
    awful.key({ modkey      }, "Left",      function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey      }, "Right",     function () awful.screen.focus_relative(1) end),

    -- Standard program
    awful.key({             }, "Print",     function () awful.util.spawn("shot") end),
    awful.key({ altkey      }, "Print",     function () awful.util.spawn("shot -s") end),
    awful.key({ modkey      }, "Return",    function () awful.util.spawn(terminal) end),
    awful.key({ modkey      }, "l",         function () awful.util.spawn("xscreensaver-command -lock") end),

    -- Touchpad on/off
    awful.key({ },             "XF86TouchpadToggle", function () awful.util.spawn("touchpad") end),

    -- Suspend to RAM
    awful.key({ },             "XF86PowerOff", function () awful.util.spawn("gotosleep") end),

    -- Awesome
    awful.key({ modkey, "Shift"     }, "r",         awesome.restart),
    awful.key({ modkey, "Shift"     }, "q",         awesome.quit),

    -- Cycle master/slave clients and switch between them
    awful.key({ altkey      }, "Right",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    awful.key({ altkey      }, "Left",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),

    awful.key({ altkey      }, "Up",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),

    awful.key({ altkey      }, "Down",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),

    -- Alt+Tab and Win+N cycles to the next window
    awful.key({ altkey      }, "Tab",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),

    -- Alt+Shift+Tab and Win+H cycles to prev window
    awful.key({ altkey, "Shift" }, "Tab",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus.minimized = false
                client.focus:raise()
            end
        end),

    awful.key({ modkey      }, "h",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus.minimized = false
                client.focus:raise()
            end
        end),


    -- Layout manipulation
    awful.key({ modkey, "Control" }, " ", function () awful.layout.inc(layouts, 1)  end),
    awful.key({ modkey, "Control", "Shift" }, " ", function () awful.layout.inc(layouts, -1)    end),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey          }, "w",     function (c) c:kill() end),

    -- Toggle floating client
    awful.key({ modkey      }, "f", function (c) awful.client.floating.toggle(c) end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { class = "Ardour" }, properties = { floating = true } },
    { rule = { },
      properties = { border_width = 0,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- }}}
