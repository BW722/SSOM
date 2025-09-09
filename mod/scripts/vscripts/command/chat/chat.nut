global function ServerChatCommand_Chat_Init
global function SSOM_SetChatEnabled
global function SSOM_IsChatEnabled


void function ServerChatCommand_Chat_Init()
{
    AddCallback_OnReceivedSayTextMessage(OnReceivedSayTextMessage)
    AddServerChatCommandCallback( "/chat",  ServerChatCommand_Chat )
}

void function ServerChatCommand_Chat(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if( args.len() == 1 )
    {
        string arg0 = args[0].tolower()
        bool currentlyEnabled = SSOM_IsChatEnabled()
        if( SSOM_IsAffirmative(arg0) && !currentlyEnabled )
        {
            SSOM_SetChatEnabled(true)
            SSOM_ChatServerBroadcast( "已开启聊天" )
        }
        else if( !SSOM_IsAffirmative(arg0) && currentlyEnabled )
        {
            SSOM_SetChatEnabled(false)
            SSOM_ChatServerBroadcast( "已关闭聊天" )
        }
    }
    else
    {
        SSOM_ChatServerPrivateMessage(player, "状态: " + (SSOM_IsChatEnabled() ? "开启" : "关闭"))
    }
}

ClServer_MessageStruct function OnReceivedSayTextMessage(ClServer_MessageStruct message)
{
    entity player = message.player

    if(SSOM_IsPlayerAdmin(player))
    {
        return message
    }
    if(!SSOM_IsChatEnabled())
    {
        message.shouldBlock = true
        SSOM_ChatServerPrivateMessage(player, "聊天已关闭(仅管理员可发言)")
    }
    return message
}

void function SSOM_SetChatEnabled(bool Enabled)
{
    SetConVarBool( "SSOM_ChatEnabled", Enabled )
}

bool function SSOM_IsChatEnabled()
{
    return GetConVarBool("SSOM_ChatEnabled")
}