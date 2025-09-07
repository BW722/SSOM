global function ServerChatCommand_Ban_Init
global function SSOM_BanPlayer
global function SSOM_UnbanPlayer

bool dedbg = false

void function ServerChatCommand_Ban_Init()
{
    AddServerChatCommandCallback("/ban", ServerChatCommand_Ban)
    AddServerChatCommandCallback("/unban", ServerChatCommand_Unban)
}

void function ServerChatCommand_Ban(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 1)
        return
    
    string arg0 = args[0]

    entity target = GetPlayerByNamePrefix(arg0)
    if( !IsValid(target) )
    {
        SSOM_ChatServerPrivateMessage( player, "未找到玩家: " + arg0 )
        return
    }
    
    string targetUID = GetPlayerUID(target)
    
    if( SSOM_IsPlayerAdmin(target) && !dedbg )
    {
        SSOM_ChatServerPrivateMessage(player, "你不能封禁管理员！！！")
        return
    }

    SSOM_BanPlayer( target )
    SSOM_ChatServerPrivateMessage(player, "已封禁玩家: " + target.GetPlayerName())
}

void function ServerChatCommand_Unban(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 1)
        return
    
    string arg0 = args[0]

    entity target = GetPlayerByNamePrefix(arg0)
    if( !IsValid(target) )
    {
        SSOM_ChatServerPrivateMessage( player, "未找到玩家: " + arg0 )
        return
    }
    
    SSOM_UnbanPlayer( target )
    SSOM_ChatServerPrivateMessage(player, "已解封玩家: " + target.GetPlayerName())
}

void function SSOM_BanPlayer( entity player )
{
    string playerName = player.GetPlayerName()
    string playerUID = GetPlayerUID(player)

    if(!dedbg)  ServerCommand( "ban " + playerUID )

    SSOM_ChatServerBroadcast( "|==================[BAN]==================|")
    SSOM_ChatServerBroadcast( " 玩家: " + playerName + " (" + playerUID + ")" )
    SSOM_ChatServerBroadcast( "|========================================|" )
}

void function SSOM_UnbanPlayer( entity player )
{
    string playerName = player.GetPlayerName()
    string playerUID = GetPlayerUID(player)
    
    ServerCommand( "unban " + playerUID )
}