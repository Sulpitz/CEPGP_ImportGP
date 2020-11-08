SLASH_CEPGPIGP1 = "/cepgpigp"
SLASH_CEPGPIGP2 = "/cepigp"
function SlashCmdList.CEPGPIGP(msg, editbox) 
    if msg == "" then
        CEPIGP_StaticPopupImport()
    elseif msg == "t" then 
        CEPGP_override:Show()
    elseif msg == "test" then
        print("test")
        CEPIGP_Test()
    end
end


function CEPIGP_Test()
    C_Timer.After(3, function() print("Hello") end)
end



function CEPIGP_StaticPopupImport()
    
    StaticPopupDialogs["CEPIGP_IMPORT"] =
        StaticPopupDialogs["CEPIGP_IMPORT"] or
        {
            text = "Paste Import String:",
            button1 = "Import",
            hasEditBox = 1,
            hasWideEditBox = 1,
            editBoxWidth = 350,
            preferredIndex = 3,
            OnShow = function(this, ...)
                this:SetWidth(420)
                print("CEPIGP Usage:\nPaste the ItemID and GP Values in this format seperated by ',' (without '): \n['itemID'] = 'GPvalue', 'itemID' = GPvalue, 'etc'")

                local editBox = _G[this:GetName() .. "WideEditBox"] or _G[this:GetName() .. "EditBox"]
              
                editBox:SetText("")
                editBox:SetFocus()
                editBox:HighlightText(false)

                local button = _G[this:GetName() .. "Button2"]
                button:ClearAllPoints()
                button:SetWidth(200)
                button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
            end,
            OnHide = NOP,
            OnAccept = function(this, ...)

                local editbox = _G[this:GetParent():GetName() .. "WideEditBox"] or _G[this:GetName() .. "EditBox"]

                local importstring = "CEPIGP_DATA_OVERRIDES = {" .. editbox:GetText() .. "}"

                local _, err = loadstring(importstring)

                if not err then
                    assert(loadstring(importstring))()
                    
                    CEPGP.Overrides = {}
                    local idTable = {}
                    local i = 0         

                    local p = 0
                    for k, v in pairs(CEPIGP_DATA_OVERRIDES) do
                        p = p + 1
                    end
                    print("length CEPIGP_DATA_OVERRIDES:", p)

                    for id, _ in pairs (CEPIGP_DATA_OVERRIDES) do
                        i = i + 1
                        idTable[i] = id
                    end

                    i = 1
                    local limit = #idTable

                    CEPIGP_Timer = C_Timer.NewTicker(0.05, function()

                        local id = idTable[i]
                        local gp = CEPIGP_DATA_OVERRIDES[id]
                    
                        local link = CEPGP_getItemLink(id)

                        if id == nil then
                            CEPIGP_Timer:Cancel()                            
                            CEPGP_print("Import finished!")
                        end
                        
                        if link ~= nil then     

                            if CEPGP_itemExists(id) then
                                CEPGP.Overrides[link] = gp
                                CEPGP_print(math.floor(i/limit*100) .. "%  " ..  i .. "/" .. limit .. "  GP value for " .. link .. " |c006969FFhas been overriden to " .. gp)
                            else
                                print("ERROR: Item " .. id .. " does not exist")
                            end
                       
                            i = i + 1
                            CEPGP_UpdateOverrideScrollBar()
                        end
                    end)                
                    CEPGP_override:Show()
                end
            end,
            OnCancel = NOP,
            EditBoxOnEscapePressed = function(this, ...)
                this:GetParent():Hide()
            end,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 1
        }
        
    StaticPopup_Show("CEPIGP_IMPORT", export_text)
end


function CEPIGP_CheckImport()
    for idNew, gpNew in pairs(CEPIGP_DATA_OVERRIDES) do

    end
end