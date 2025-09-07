global function ServerChatCommand_Team_Init

void function ServerChatCommand_Team_Init()
{
    AddServerChatCommandCallback("/team", ServerChatCommand_Team)
}

void function ServerChatCommand_Team(entity player, array<string> args)
{
    if (!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if (args.len() != 2)
        return

    int team
    try
    {
        team = int(args[1])
    }
    catch (error)
    {
        SSOM_ChatServerPrivateMessage(player, "队伍必须是数字")
        return
    }
    
    if(team < 2)
    {
        SSOM_ChatServerPrivateMessage(player, "队伍必须大于等于2")
        return
    }

    array<entity> targetPlayers = []
    string targetName = args[0].tolower()
    
    if(targetName == "all")
    {
        targetPlayers = GetPlayerArray()
    }
    else
    {
        entity targetPlayer = FindPlayerByNamePrefix(args[0])
        if (!IsValid(targetPlayer))
        {
            SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + args[0])
            return
        }
        targetPlayers.append(targetPlayer)
    }

    int successCount = 0
    foreach(targetPlayer in targetPlayers)
    {
        if(!IsValid(targetPlayer))
            continue
            
        try
        {
            SetTeam(targetPlayer, team)
            successCount++
        }
        catch (error)
        {
            SSOM_ChatServerPrivateMessage(player, 
                "设置玩家 " + targetPlayer.GetPlayerName() + " 队伍时发生错误: " + error)
        }
    }
    
    if(targetName == "all")
    {
        SSOM_ChatServerPrivateMessage(player, 
            "已设置 " + successCount + " 名玩家的队伍为: " + team)
    }
    else if(successCount > 0)
    {
        SSOM_ChatServerPrivateMessage(player, 
            "已设置玩家 " + targetPlayers[0].GetPlayerName() + " 的队伍为: " + team)
    }
}