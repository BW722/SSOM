global function ServerChatCommand_Mute_Init

global function SSOM_MutePlayer
global function SSOM_UnmutePlayer

table<string,float> mutes = {}

void function ServerChatCommand_Mute_Init()
{
    AddCallback_OnReceivedSayTextMessage(OnReceivedSayTextMessage)
    AddServerChatCommandCallback( "/mute", ServerChatCommand_Mute )
    AddServerChatCommandCallback( "/unmute", ServerChatCommand_Unmute )
}

void function ServerChatCommand_Mute(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 2)
        return
    
    entity target = GetPlayerByNamePrefix(args[0])
    if( target == null || !IsValid(target) )
        return
    if( SSOM_IsPlayerAdmin(target) )
    {
        SSOM_ChatServerPrivateMessage(player, "你不能禁言管理员！！！")
        return
    }
    
    try{
        float time = float(args[1])
        SSOM_MutePlayer(target, time)
        SSOM_ChatServerPrivateMessage(player, "已禁言玩家: " + target.GetPlayerName() + " " + time + " 秒！！！")
    }catch(error){
        SSOM_ChatServerPrivateMessage(player, "错误: " + string(error))
    }
}

void function ServerChatCommand_Unmute(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 1)
        return
    
    entity target = GetPlayerByNamePrefix(args[0])
    if( target == null || !IsValid(target) )
        return
    if( !(GetPlayerUID(target) in mutes) )
        return

    SSOM_UnmutePlayer(target)
    SSOM_ChatServerPrivateMessage(player, "已解除禁言: " + target.GetPlayerName())
}

void function SSOM_MutePlayer( entity player, float time = 0)
{
    string playerName = player.GetPlayerName()
    string playerUID = GetPlayerUID(player)

    if( playerUID in mutes )
        return
    
    if(time <= 0)
    {
        mutes[playerUID] <- 0
        SSOM_ChatServerPrivateMessage( player, "你已被永久禁言！！！" )
    }
    else
    {
        mutes[playerUID] <- Time() + time
        SSOM_ChatServerPrivateMessage( player, "你已被禁言 " + time + " 秒！！！" )
    }
}

void function SSOM_UnmutePlayer( entity player )
{
    string playerUID = GetPlayerUID(player)
    if( playerUID in mutes )
    {
        delete mutes[playerUID]
        SSOM_ChatServerPrivateMessage( player, "你已被解除禁言！！！" )
    }
}

ClServer_MessageStruct function OnReceivedSayTextMessage(ClServer_MessageStruct message)
{
    if(!SSOM_IsChatEnabled())
        return message
        
    entity player = message.player
    string playerUID = GetPlayerUID(player)

    if( SSOM_IsPlayerAdmin(player) )
        return message

    if( playerUID in mutes )
    {
        float endTime = mutes[playerUID]
        
        if(endTime == 0)
        {
            message.shouldBlock = true
            SSOM_ChatServerPrivateMessage( player, "你已被永久禁言！！！" )
            return message
        }

        float remaining = endTime - Time()
        if(remaining > 0)
        {
            message.shouldBlock = true
            SSOM_ChatServerPrivateMessage( player, "你已被禁言，剩余 " + format("%.1f", remaining) + " 秒！！！" )
            return message
        }
        else
        {
            delete mutes[playerUID]
        }
    }
    return message
}