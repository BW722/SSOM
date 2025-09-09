global function ServerChatCommand_Kill_Init
global function SSOM_KillAllPlayers

void function ServerChatCommand_Kill_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
        
    AddServerChatCommandCallback("/kill", ServerChatCommand_Kill)
}

void function ServerChatCommand_Kill(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if(args.len() == 0)
    {
        if(IsAlive(player))
        {
            player.Die()
            SSOM_ChatServerPrivateMessage(player, "已杀死玩家 " + player.GetPlayerName())
        }
        return
    }

    if(args.len() != 1)
        return

    string targetName = args[0].tolower()
    
    if(targetName == "all")
    {
        int killCount = 0
        foreach(targetPlayer in GetPlayerArray())
        {
            if(IsValid(targetPlayer) && IsAlive(targetPlayer))
            {
                targetPlayer.Die()
                killCount++
            }
        }
        SSOM_ChatServerPrivateMessage(player, "已杀死所有玩家（共" + killCount + "人）")
    }
    else
    {
        entity targetPlayer = GetPlayerByNamePrefix(args[0])
        if(!IsValid(targetPlayer))
        {
            SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + args[0])
            return
        }
        
        if(!IsAlive(targetPlayer))
        {
            SSOM_ChatServerPrivateMessage(player, "玩家" + targetPlayer.GetPlayerName() + "已经死亡")
            return
        }
        
        targetPlayer.Die()
        SSOM_ChatServerPrivateMessage(player, "已杀死玩家 " + targetPlayer.GetPlayerName())
    }
}

void function SSOM_KillAllPlayers()
{
    foreach (player in GetPlayerArray())
    {
        if(IsAlive(player))
            player.Die()
    }
}