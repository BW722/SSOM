global function ServerChatCommand_Cheats_Init

global function SSOM_SetCheatsEnabledd

void function ServerChatCommand_Cheats_Init()
{
    AddServerChatCommandCallback( "/cheats", ServerChatCommand_Cheats )
}

void function ServerChatCommand_Cheats(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if ( args.len() != 1 )
        return

    string arg0 = args[0]
    bool cheats = GetConVarBool( "sv_cheats" )

    if( SSOM_IsAffirmative( arg0 ) && !cheats )
    {
        SSOM_SetCheatsEnabledd(true)
    }
    else if( SSOM_IsNegative( arg0 ) && cheats)
    {
        SSOM_SetCheatsEnabledd(false)
    }
    string message = GetConVarBool( "sv_cheats" ) ? "开启" : "关闭"
    SSOM_ChatServerPrivateMessage( player, "已" + message + "作弊！！！" )
}

void function SSOM_SetCheatsEnabledd(bool Enabled)
{
    SetConVarBool( "sv_cheats", Enabled )
}