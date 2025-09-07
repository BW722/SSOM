global function ServerChatCommand_Kick_Init

global function SSOM_KickPlayer

bool dedbg = false

void function ServerChatCommand_Kick_Init()
{
    AddServerChatCommandCallback("/kick", ServerChatCommand_Kick)
}

void function ServerChatCommand_Kick(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() < 1 || args.len() > 2)
        return

    entity target = GetPlayerByNamePrefix(args[0])

    if( !IsValid(target) )
        return

    string reason = args.len() == 2 ? args[1] : ""

    SSOM_KickPlayer(target, reason)
}

void function SSOM_KickPlayer( entity player, string reason )
{
    string playerName = player.GetPlayerName()
    string playerUID = GetPlayerUID(player)

    if(!dedbg)  NSDisconnectPlayer( player, reason )

    SSOM_ChatServerBroadcast( "|==================[KICK]==================|")
    SSOM_ChatServerBroadcast( " 玩家: " + playerName + " (" + playerUID + ")" )
    SSOM_ChatServerBroadcast( " 原因：" + reason )
    SSOM_ChatServerBroadcast( "|========================================|" )
}