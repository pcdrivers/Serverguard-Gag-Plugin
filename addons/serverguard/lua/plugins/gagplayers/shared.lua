--[[
	Maked by PC-Drivers (TrollFortress)
	- Idea from ULX
]]

plugin.unique = "gagplayer";

plugin.name = "[All Servers] Gag Commands (!gag/!ungag)";
plugin.author = "PCDrivers";
plugin.version = "1.0";
plugin.description = "Gag/Ungag Players.";
plugin.gamemodes = {"darkrp"};
plugin.permissions = {"Mute"};

-- File Download
resource.AddFile("icon16/sound.png")

--
-- Gag Target Command (And Ungag if is gagged)
-- Console Command: sg gag <player>
--
local command = {};

command.help = "Gag Target Player.";
command.command = "gag";
command.arguments	= {"<player>"};
command.permissions = "Mute";

function command:Execute( player, silent, arguments )
	local target = util.FindPlayer(arguments[1], player);
	--
	if (serverguard.player:GetImmunity(target) <= serverguard.player:GetImmunity(player)) then
		-- ARGUMENTS
		if target.sg_gagged then
			target.sg_gagged = nil
			if (!silent) then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " ungagged ", SERVERGUARD.NOTIFY.RED, target:Name());
			end;
		else
			target.sg_gagged = true;
			--
			if (!silent) then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " gagged ", SERVERGUARD.NOTIFY.RED, target:Name());
			end;
		end;
		--
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has a higher immunity than you.");
	end;
end;


-- Called when the command needs an entry in the context menu (right click menu).
function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Gag/Ungag", function() 
		serverguard.command.Run("gag", false, player:UniqueID());
	end);

	option:SetImage("icon16/sound.png");
end;

-- Register the command through the plugin so it can be disabled when the plugin is.
plugin:AddCommand(command);


--
-- ONLY UNGAG Target Command (For Custom Tab Menus - DarkRP)
-- Console Command: sg ungag <player>
--
local command = {};

command.help = "UnGag Target Player.";
command.command = "ungag";
command.arguments	= {"<player>"};
command.permissions = "Mute"; 


function command:Execute( player, silent, arguments )
	local target = util.FindPlayer(arguments[1], player);
	--
	if (serverguard.player:GetImmunity(target) <= serverguard.player:GetImmunity(player)) then
		-- ARGUMENTS
		if target.sg_gagged then
			target.sg_gagged = nil
			--
			if (!silent) then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " ungagged ", SERVERGUARD.NOTIFY.RED, target:Name());
			end;
		end;
		--
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has a higher immunity than you.");
	end;
end;

plugin:AddCommand(command);



--
-- FUNCTIONS EXTRACTED FROM ULX
--
--hook.Add("PlayerSay", "FAdmin_Chatmute", function(ply, text, Team, dead)
--	if ply:FAdmin_GetGlobal("FAdmin_chatmuted") then return "" end
--end)

hook.Add( "PlayerSay", "gagplayer.PlayerGag", function( ply, text, team )
	if ply.sg_gagged then
		return ""
	end
end )

--local function gagHook( listener, talker )
--	if talker.sg_gagged then
--		return false
--	end
--end
--hook.Add( "PlayerSay", "gagplayer.PlayerGag", gagHook )
