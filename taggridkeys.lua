--------------------------------------------------------------------------
---- @author AfoHT
---- @copyright 2020 AfoHT
---- @license MIT
---- @module taggridkeys
------------------------------------------------------------------------------

-- Package envronment
local awful = require("awful")
local gears = require("gears")

local taggrid = require("taggrid.taggrid")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get(globalkeys)
    -- This should map on the top row of your keyboard, usually 1 to 9.
    -- tag_offset from taggrid
    for i = 1, taggrid.tag_offset do
        globalkeys = gears.table.join(globalkeys,
            -- View tag only.
            awful.key({ modkey }, "#" .. i + 9,
            function () taggrid.numviewtag(i) end,
                {description = "view tag #"..i, group = "tag"}),
            -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
            function () taggrid.numviewtoggle(i) end,
                    {description = "toggle tag #" .. i, group = "tag"}),

            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function () taggrid.numshifttag(i) end,
                    {description = "move focused client to tag #"..i, group = "tag"}),
            -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function () taggrid.numtoggletag(i) end,
                    {description = "toggle focused client on tag #" .. i, group = "tag"})
        )
    end
    globalkeys = gears.table.join(globalkeys,
    -- Switch tag up or down
        -- Move down a column
        awful.key({ modkey,           }, "Down", taggrid.viewdown,
                {description = "Jump down one column", group = "tag"}),
        -- Move up a column
        awful.key({ modkey,           }, "Up", taggrid.viewup,
                {description = "Jump up one column", group = "tag"}),

    -- Shift windows to left or right

        -- Shift left
        awful.key({ modkey, "Shift"   }, ",", taggrid.shiftleft,
                {description = "Move tag left", group = "tag"}),
        -- Shift right
        awful.key({ modkey, "Shift"   }, ".", taggrid.shiftright,
                {description = "Move tag right", group = "tag"}),
        -- Shift left
        awful.key({ modkey, "Shift"   }, "Left", taggrid.shiftleft,
                {description = "Move tag left", group = "tag"}),
        -- Shift right
        awful.key({ modkey, "Shift"   }, "Right", taggrid.shiftright,
                {description = "Move tag right", group = "tag"}),

    -- Shift windows up or down
        awful.key({ modkey, "Shift"   }, "Down", taggrid.shiftdown,
                {description = "Move tag down", group = "tag"}),
        awful.key({ modkey, "Shift"   }, "Up", taggrid.shiftup,
                {description = "Move tag up", group = "tag"})
    )
  return globalkeys
end

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
