global function ServerChatCommand_Noclip_Init

global function SSOM_Noclip


void function ServerChatCommand_Noclip_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback( "/noclip", ServerChatCommand_Noclip )
}

void function ServerChatCommand_Noclip(entity player, array<string> args) {
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    array<entity> targets = []

    if (args.len() != 1)
    {
        targets.append(player)
    }
    else if(args.len() == 1)
    {
        if (args[0].tolower() == "all")
        {
            targets = GetPlayerArray()
        }
        else
        {
            targets.append(FindPlayerByNamePrefix(args[0]))
        }
    }

    foreach(target in targets)
    {
        if( !IsValid(target) || !IsAlive(target) )
            continue
        SSOM_Noclip(target)
    }
}

void function SSOM_Noclip( entity player )
{
	if( player.GetParent() )
		return
	if( player.IsNoclipping() )
    {
        player.SetPhysics( MOVETYPE_WALK )
    }
	else
    {
        player.SetPhysics( MOVETYPE_NOCLIP )
    }
}