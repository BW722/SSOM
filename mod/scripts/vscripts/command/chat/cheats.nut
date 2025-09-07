global function ServerChatCommand_Cheats_Init
global function SSOM_SetCheatsEnabled
global function SSOM_IsCheatsEnabled

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
    bool cheats = SSOM_IsCheatsEnabled()

    if( SSOM_IsAffirmative( arg0 ) && !cheats )
    {
        SSOM_SetCheatsEnabled(true)
    }
    else if( SSOM_IsNegative( arg0 ) && cheats)
    {
        SSOM_SetCheatsEnabled(false)
    }
    string message = SSOM_IsCheatsEnabled() ? "开启" : "关闭"
    SSOM_ChatServerPrivateMessage( player, "已" + message + "作弊！！！" )
}

void function SSOM_SetCheatsEnabled(bool enabled)
{
    SetConVarBool( "sv_cheats", enabled )
}

bool function SSOM_IsCheatsEnabled()
{
    return GetConVarBool( "sv_cheats" )
}