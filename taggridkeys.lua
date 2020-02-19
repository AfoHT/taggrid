----------------------------------------------------------------------------
---- @author AfoHT
---- @copyright 2020 AfoHT
---- @license MIT/Apache
---- @module globalkeys
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
            function ()
                taggrid.numviewtag(i)
            end,
                {description = "view tag #"..i, group = "tag"}),
            -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9, taggrid.numviewtoggle(i),
                    {description = "toggle tag #" .. i, group = "tag"}),

            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9, taggrid.numshifttag(i),
                    {description = "move focused client to tag #"..i, group = "tag"}),
            -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, taggrid.numtoggletag(i),
                    {description = "toggle focused client on tag #" .. i, group = "tag"})
        )
     end
  return globalkeys
end

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
