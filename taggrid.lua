----------------------------------------------------------------------------
---- @author AfoHT
---- @copyright 2020 AfoHT
---- @license MIT/Apache
---- @module taggrid
------------------------------------------------------------------------------

-- Package envronment
local awful = require("awful")
local gears = require("gears")

-- Widget and layout library
local wibox = require("wibox")

local taggrid = {}

-- Add tags matching the layout below
taggrid.tag_count = 39
taggrid.tag_column_count = 3
taggrid.tag_offset = math.floor(taggrid.tag_count / taggrid.tag_column_count)

-- Provide the tags
taggrid.tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "[", "]", "←",
                 "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "[", "]", "←",
                 "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "[", "]", "←"
               }


-- Create a gridlayout for the above tags
    taggrid.gridlayout = wibox.widget {
        forced_num_cols = taggrid.tag_offset,
        forced_num_rows = taggrid.tag_column_count,
        --min_rows_size   = 10,
        homogeneous     = true,
        expand          = true,
        layout = wibox.layout.grid
    }

-- View the next tag to the left, wrapping on the current row
-- Replacing awful.tag.viewprev
function taggrid.viewprev()
    -- If standing on the left edge and shifting one more,
    -- wrap around on the current row
    local tag_offset = taggrid.tag_offset
    local screen = awful.screen.focused()
    local t = awful.screen.focused().selected_tag
    local curidx = t.index

    local tag
    if curidx == 1 then
        tag = screen.tags[tag_offset]
    elseif curidx == tag_offset + 1 then
        tag = screen.tags[tag_offset * 2]
    elseif curidx == tag_offset * 2 + 1 then
        tag = screen.tags[tag_offset * 3]
    else 
        tag = screen.tags[curidx - 1]
    end
    if tag then
        tag:view_only()
    end
end

-- View the next tag to the right, wrapping on the current row
-- Replacing awful.tag.viewnext
function taggrid.viewnext()
    -- If standing on the right edge and shifting one more,
    -- wrap around on the current row
    local tag_offset = taggrid.tag_offset
    local screen = awful.screen.focused()
    local t = awful.screen.focused().selected_tag
    local curidx = t.index

    local tag
    if curidx == tag_offset then
        tag = screen.tags[1]
    elseif curidx == tag_offset * 2 then
        tag = screen.tags[tag_offset + 1]
    elseif curidx == tag_offset * 3 then
        tag = screen.tags[tag_offset * 2 + 1]
    else 
        tag = screen.tags[curidx + 1]
    end
    if tag then
        tag:view_only()
    end
end

-- Jump to the row below in the grid
function taggrid.viewdown()
    local tag_offset = taggrid.tag_offset
    awful.tag.viewidx(-tag_offset)
end

-- Jump to the row above in the grid
function taggrid.viewup()
    local tag_offset = taggrid.tag_offset
    awful.tag.viewidx(tag_offset)
end

-- Shift the currently focused client left
function taggrid.shiftleft()
    if client.focus then
        local tag_offset = taggrid.tag_offset
        local t = awful.screen.focused().selected_tag
        local curidx = t.index

        -- If standing on the right edge and shifting one more,
        -- wrap around on the current row
        -- Create local tag
        local tag
        if curidx == 1 then
            tag = client.focus.screen.tags[tag_offset]
        elseif curidx == tag_offset + 1 then
            tag = client.focus.screen.tags[tag_offset * 2]
        elseif curidx == tag_offset * 2 + 1 then
            tag = client.focus.screen.tags[tag_offset * 3]
        else
            tag = client.focus.screen.tags[curidx - 1]
        end
        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end

-- Shift the currently focused client right
function taggrid.shiftright()
    if client.focus then
        local tag_offset = taggrid.tag_offset
        local t = awful.screen.focused().selected_tag
        local curidx = t.index

        -- If standing on the right left edge and shifting one more,
        -- wrap around on the current row
        local tag
        if curidx == tag_offset then
            tag = client.focus.screen.tags[1]
        elseif curidx == tag_offset * 2 then
            tag = client.focus.screen.tags[tag_offset + 1]
        elseif curidx == tag_offset * 3 then
            tag = client.focus.screen.tags[tag_offset * 2 + 1]
        else
            tag = client.focus.screen.tags[curidx + 1]
        end
        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end

-- Shift the focused tag "downwards" in the grid
function taggrid.shiftdown()
    if client.focus then
        local tag_offset = taggrid.tag_offset
        local t = awful.screen.focused().selected_tag
        local curidx = t.index
        local tag
        if curidx >= tag_offset * 2 + 1 then
            tag = client.focus.screen.tags[curidx - tag_offset * 2]
        else
            tag = client.focus.screen.tags[curidx + tag_offset]
        end
        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end

-- Shift the focused tag "upwards" in the grid
function taggrid.shiftup()
    if client.focus then
        local t = awful.screen.focused().selected_tag
        local curidx = t.index
        local tag
        if curidx <= tag_offset then
            tag = client.focus.screen.tags[curidx + tag_offset * 2]
        else
            tag = client.focus.screen.tags[curidx - tag_offset]
        end
        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end


-- View the tag on the currently selected row based on num-key row input
function taggrid.numviewtag(i)
        local tag_offset = taggrid.tag_offset
        local screen = awful.screen.focused()
        local t = awful.screen.focused().selected_tag
        local curidx = t.index

        local tag
        if curidx <= tag_offset then
            tag = screen.tags[i]
        elseif curidx <= tag_offset * 2 then
            tag = screen.tags[tag_offset + i]
        else 
            tag = screen.tags[tag_offset * 2 + i]
        end
        if tag then
            tag:view_only()
        end
end

-- Toggle the tag on the currently selected row based on num-key row input
function taggrid.numviewtoggle(i)
    if client.focus then
        local tag_offset = taggrid.tag_offset
        local screen = awful.screen.focused()
        local t = awful.screen.focused().selected_tag
        local curidx = t.index

        if curidx <= tag_offset then
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        elseif curidx <= tag_offset * 2 then
            local tag = screen.tags[tag_offset + i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        else 
            local tag = screen.tags[tag_offset * 2 + i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end
    end
end

-- Shift the tag on the currently selected row based on num-key row input
function taggrid.numshifttag(i)
    if client.focus then
        local tag_offset = taggrid.tag_offset
        local screen = awful.screen.focused()
        local t = awful.screen.focused().selected_tag
        local curidx = t.index

        if curidx <= tag_offset then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        elseif curidx <= tag_offset * 2 then
            local tag = client.focus.screen.tags[tag_offset + i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        else 
            local tag = client.focus.screen.tags[tag_offset * 2 + i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end
end

-- Toggle the tag on the currently selected client on the current row based on num-key row input
function taggrid.numtoggletag(i)
    if client.focus then
        local tag_offset = taggrid.tag_offset
        local screen = awful.screen.focused()
        local t = awful.screen.focused().selected_tag
        local curidx = t.index

        if curidx <= tag_offset then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        elseif curidx <= tag_offset * 2 then
            local tag = client.focus.screen.tags[tag_offset + i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        else 
            local tag = client.focus.screen.tags[tag_offset * 2 + i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end
end

return taggrid
