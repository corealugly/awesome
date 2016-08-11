---------------------------------------------
----- Стандартные библиотеки ---
---------------------------------------------
local gears = require("gears")
local awful = require("awful")
awfulRules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--#my
local vicious = require("vicious")
local dbus = require("dbus")

local lain = require("lain")

local textclock = require("textclock")
local blingbling = require("blingbling")
--local my = require("blingbling/my_graph")
---------------------------------------------------------
----- Устанавливаем системную локаль ---
-----------------------------------------------------------
os.setlocale("en_US.UTF-8")

--#autorun
--os.execute("pgrep -u $USER -x nm-applet || (nm-applet &)")
---os.execute("pgrep -u $user -x xxkb || (xxkb &)")
os.execute("pgrep -u $user -x kbdd || $(kbdd &)")
os.execute("setxkbmap -layout us,ru -variant -option  grp:alt_shift_toggle, terminate:ctrl_alt_bksp")
--os.execute("pgrep -u $USER -x xscreensaver || (xscreensaver -nosplash &)")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-------------------------------------
----- Устанавливаем тему ---
---------------------------------------
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

----------------------------------------------------------------------
----- Устанавливаем приложения по умолчанию ---
------------------------------------------------------------------------
terminal = "terminator"
browser="google-chrome-stable"
editor = os.getenv("gvim") or "gvim"
editor_cmd = terminal .. " -e " .. editor

-----------------------------------------
----- Клавиша-модификатор ---
-----------------------------------------
modkey = "Mod4"

---------------------------
----- Кнопки мыши ---
-----------------------------
left_button        = 1
wheel_button       = 2
right_button       = 3
plus_button        = 4 
minus_button       = 5
wheel_left_button  = 6
wheel_write_button = 7

-----------------------------------
----- Скан-коды клавиш ---
-------------------------------------
key_V          = "#55"
key_Z          = "#52"
key_Y          = "#29"
key_J          = "#44"
key_K          = "#45"
key_N          = "#57"
key_M          = "#58"
key_F          = "#41"
key_R          = "#27"
key_L          = "#46"
key_C          = "#54"
key_W          = "#25"
key_X          = "#53"
key_Q          = "#24"
key_H          = "#43"
key_Tab        = "#23"
key_Tilda      = "#49"
key_U          = "#30"
key_E          = "#26"
key_T          = "#28"
key_P          = "#33"
key_O          = "#32"
key_Return     = "#36"
key_Left       = "#113"
key_Right      = "#114"
key_Esc        = "#9"
key_Print      = "#107"
key_Alt_R      = "#108"
key_Alt_L      = "#64"
key_Space      = "#65"
key_Ctrl_R     = "#105"
key_Ctrl_L     = "#37"
key_Home       = "#110"
key_F1         = "#67"

key_play       = "#172"
key_move_right = "#171"
key_move_left  = "#173"
key_sleep      = "#150"
key_Mute       = "#121"
key_Vol_Down   = "#122"
key_Vol_Up     = "#123"

------------------------------------------------------------------------------
----- Layouts - способы расположения окон на экране ---
------------------------------------------------------------------------------
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}

--------------------------------------
----- Обои рабочего стола ---
--------------------------------------
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end


---------------------------------------------------------
----- Тэги - виртуальные рабочие столы ---
-----------------------------------------------------------
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "web", "note", "terminal", "file", "media", "chat"}, s,
    layouts[5], layouts[1], layouts[1], layouts[1], layouts[5], layouts[2])
end

------------------------------
----- Главное меню ---
------------------------------
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

------------------------------------------------------------------
----- Лаунчер - та кнопка что на панели слева --- 
------------------------------------------------------------------
menubar.utils.terminal = terminal -- Set the terminal for applications that require it


------------------------------------------------------------------
------- настройка виджетов --- 
------------------------------------------------------------------
---Separator 
-----------------------------------
separator = blingbling.text_box.new()
--separator:set_text(" : : ")
separator:set_text(" | ")
separator:set_font_size(10)
-----------------------------------
---Volume widget "♫"
-----------------------------------
--volume_master_bar = blingbling.volume.new({height = 25, width = 40, v_margin = 0,  bar =true, show_text = false, label ="$percent%", pulseaudio = true})
--volume_master_bar:update_master()
--volume_master_bar:set_master_control()

volume_master_text = blingbling.volume.new({height = 18, width = 25, v_margin = 4,  bar =false, show_text = true, label ="$percent%", pulseaudio = true})
volume_master_text:update_master()
volume_master_text:set_master_control()

volume_label = blingbling.text_box.new() 
volume_label:set_text("♫")
volume_label:set_font_size(12)

----------------------------------
---Net widget
----------------------------------
--netWidgetText = wibox.widget.textbox()
--netWidgetText:set_text("NET:")
--netWidgetText:

netWidgetText = blingbling.text_box.new()
netWidgetText:set_text("NET : ")
netWidgetText:set_font_size(10)
--netWidgetText:set_background_color("")

netWidget = blingbling.net()
netWidget:set_interface("vbr0")
netWidget:set_show_text(true)
netWidget:set_url_for_ext_ip(nil)
netWidget:set_ippopup()
netWidget:set_font_size(7)

----------------------------------
---CPU widget
----------------------------------

cpuwidgetText = blingbling.text_box.new()
cpuwidgetText:set_text("CPU : ")
cpuwidgetText:set_font_size(10)
--netWidgetText:set_background_color("")

cpuwidget = blingbling.line_graph({ height = 18,
                                        width = 200,
                                        show_text = false,
                                        label = "Load: $percent %",
                                        rounded_size = 0.3,
                                        graph_background_color = "#00000033"
                                      })
--cpu_graph:set_height(18)
--cpu_graph:set_width(200)
--cpu_graph:set_show_text(true)
--cpu_graph:set_label("Load: $percent %")
--cpu_graph:set_rounded_size(0.3)
--cpu_graph:set_graph_background_color("#00000033")
vicious.register(cpuwidget, vicious.widgets.cpu,'$1',2)

corewidgetText = blingbling.text_box.new()
corewidgetText:set_text("CORE : ")
corewidgetText:set_font_size(10)

---------------------------------------------
--- MY CRAZY ASS SQUARE WIDGET, BEWARE MAN
---------------------------------------------
-- "width", "height", "h_margin", "v_margin",
--                      "background_color", "graph_background_color",
--                      "rounded_size", --[["graph_color", "graph_line_color",
--                      "show_text", "text_color", "font_size", "font",
--                      "text_background_color", "label", "value_format"]]
--                      "graph_gradient", "parts", "spacing"

-- print my
-- dbg({my.})

--my_widget = my({
--	height = 18,
--	width = 200,
--	rounded_size = 0.3,
--	graph_background_color = "#00000033",
--	graph_gradient = {"#000000", "#ffffff"},
--	parts = 4,
--	spacing = 1
--	})
--
--vicious.register(my_widget, vicious.widgets.net,
--	function (widget, args)
--      return args["{vbr0 rx_b}"] + args["{vbr0 tx_b}"]
--    end,
--    2)

----------------------------------
---CORE widget
----------------------------------

--core_start=7
--core_end=8

--cores_graph_conf ={height = 18, width = 8, rounded_size = 0.3}
--cores_graphs = {}
--for i=core_start,core_end do
--  cores_graphs[i] = blingbling.progress_graph( cores_graph_conf)
--  vicious.register(cores_graphs[i], vicious.widgets.cpu, "$"..(i+1).."",1)
--end

-----------------------------------
---keyboard layout widget
-----------------------------------
--kbdwidget = wibox.widget.textbox()
kbdwidget = blingbling.text_box.new()
kbdwidget.border_width = 1
kbdwidget.border_color = beautiful.fg_normal
kbdwidget:set_text("✡ US")

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    lts = {[0] = "✡ US", [1] = "☭ RU"}
    kbdwidget:set_text(" "..lts[layout].." ")
    --kbdwidget:set_markup(" " ..lts[layout].. "")
    end
)


-----------------------------------
---Clock widget
-----------------------------------
textclock = textclock("%H:%M")

----------------------------------
-----calendar widget
-----------------------------------
--cal_box = wibox({height = 200, width = 240, ontop = false, x = 1200, y = 200})
--cal_box.visible = true

-- cal = blingbling.calendar({locale = 'fr_FR'})
cal = blingbling.calendar()
--cal_box:set_widget(cal)


--Local function print_info_enter(calendar_day_widget, month, year, info_cell)
--  local day = calendar_day_widget._layout.text
--  local month = month
--  local day = day
--  local str = day .."/"..month.."/"..year.." : No events for this day"
--  info_cell:set_text(str)
--End
--
--Local function print_info_leave(widget, month, year, info_cell)
--  info_cell:set_text("")
--End
--
--Cal = blingbling.extended_calendar({height = 200, width = 300, 
--                                    ontop = false, x = 1620, y = 23,
--                                    days_mouse_enter = print_info_enter,
--                                    days_mouse_leave = print_info_leave})


--lain.widgets.calendar:attach(mytextclock)

-----------------------------------
-- Create a wibox for each screen and add it
-----------------------------------
wiboxS = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
	mytaglist.buttons = awful.util.table.join(
			awful.button({ }, 1, awful.tag.viewonly),
			awful.button({ modkey }, 1, awful.client.movetotag),
			awful.button({ }, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, awful.client.movetotag),
			awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
			awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
			)


	mytasklist = {}
	mytasklist.buttons = awful.util.table.join(
			awful.button({ }, 1, function (c)
				if c == client.focus then
				c.minimized = true
				else
				c.minimized = false
				if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
				end
				client.focus = c
				c:raise()
				end
				end),
			awful.button({ }, 3, function (c)
				c:kill()
				end),
			awful.button({ }, 4, function ()
					awful.client.focus.byidx(1)
					if client.focus then client.focus:raise() end
					end),
			awful.button({ }, 5, function ()
					awful.client.focus.byidx(-1)
					if client.focus then client.focus:raise() end
					end))

for s = 1, screen.count() do
--	-- Create a promptbox for each screen
mypromptbox[s] = awful.widget.prompt()
--	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
--	-- We need one layoutbox per screen.
mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
				awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
				awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
				awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
				awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	wiboxS[s] = awful.wibox({ position = "top", height=23, screen = s })
	--wiboxS[s] = awful.wibox({ position = "top", height=50, screen = s })

	-- Widgets that are aligned to the left
local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mylauncher)
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])

	-- Widgets that are aligned to the right
local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(separator)
	right_layout:add(kbdwidget)	
	right_layout:add(separator)
--	right_layout:add(netWidgetText)
	right_layout:add(netWidget)
	right_layout:add(separator)
	---[[
--	right_layout:add(my_widget)
--	right_layout:add(separator)
	--]]
	right_layout:add(volume_label)
	right_layout:add(volume_master_text)
--	right_layout:add(volume_master_bar)
	right_layout:add(separator)
	right_layout:add(cal)
	right_layout:add(separator)
	right_layout:add(mylayoutbox[s]) 

    -- Now bring it all together (with the tasklist in the middle)
local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	wiboxS[s]:set_widget(layout)


	wiboxS[s] = awful.wibox({ position = "bottom", height=23, screen = s })

local left_layoutB = wibox.layout.fixed.horizontal()
	left_layoutB:add(cpuwidgetText)
	left_layoutB:add(cpuwidget)
	left_layoutB:add(separator)
	
	
----------------------------------
---CORE widget
----------------------------------
	--left_layoutB:add(corewidgetText)
	--for i=core_start,core_end do
  	--	left_layoutB:add(cores_graphs[i])
	--end
----------------------------------

    -- Now bring it all together (with the tasklist in the middle)
local layoutB = wibox.layout.align.horizontal()
	layoutB:set_left(left_layoutB)
	--layout:set_middle(mytasklist[s])

	wiboxS[s]:set_widget(layoutB)
end


------------------------------------------------------------------
--------- настройка мышы --- 
--------------------------------------------------------------------
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ }, "XF86AudioMute", function() awful.util.spawn_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")        end),
    awful.key({ }, "XF86AudioLowerVolume", function() awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%")  end),
    awful.key({ }, "XF86AudioRaiseVolume", function() awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%")  end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
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
-- Rules to apply to new clients (through the "manage" signal).
awfulRules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

    local titlebars_enabled = True
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
