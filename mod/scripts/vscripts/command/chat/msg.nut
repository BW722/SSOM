global function ServerChatCommand_Msg_Init
global function SSOM_SetMsgEnabled
global function SSOM_IsMsgEnabled

void function ServerChatCommand_Msg_Init()
{
    AddServerChatCommandCallback("/msg", ServerChatCommand_Msg)
}

void function ServerChatCommand_Msg(entity player, array<string> args)
{
    string playerName = player.GetPlayerName()

    if(args.len() == 1)
    {
        if( SSOM_IsPlayerAdmin( player ) )
        {
            string arg0 = args[0].tolower()
            if( SSOM_IsAffirmative(arg0) && !SSOM_IsMsgEnabled() )
            {
                SSOM_SetMsgEnabled(true)
                SSOM_ChatServerBroadcast("已开启私聊！！！")
                return
            }
            else if( SSOM_IsNegative(arg0) && SSOM_IsMsgEnabled() )
            {
                SSOM_SetMsgEnabled(false)
                SSOM_ChatServerBroadcast("已关闭私聊！！！")
                return
            }
        }
    }
    
    if(args.len() != 2)
        return
    
    if( !SSOM_IsMsgEnabled() )
    {
        SSOM_ChatServerPrivateMessage(player, "私聊已关闭！！！")
        return
    }

    string targetName = args[0]
    string message = args[1]

    entity target = GetPlayerByNamePrefix(targetName)
    if(IsAlive(target))
    {
        SSOM_ChatServerPrivateMessage(player, "玩家" + target.GetPlayerName() + "已经死亡")
    }
    
    if(target == player)
    {
        SSOM_ChatServerPrivateMessage(player, "你不能给自己发送私聊消息")
        return
    }

    SSOM_ChatServerPrivateMessage(target, "[来自 " + playerName + " 的私聊]: " + message)
    
    SSOM_ChatServerPrivateMessage(player, "[发送给 " + target.GetPlayerName() + " 的私聊]: " + message)
}

void function SSOM_SetMsgEnabled(bool enabled)
{
    SetConVarBool( "SSOM_MsgEnabled", enabled )
}

bool function SSOM_IsMsgEnabled()
{
    return GetConVarBool("SSOM_MsgEnabled")
}