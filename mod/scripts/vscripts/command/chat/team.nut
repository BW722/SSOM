global function ServerChatCommand_Team_Init


void function ServerChatCommand_Team_Init()
{
    AddServerChatCommandCallback( "/team", ServerChatCommand_Team )
}

void function ServerChatCommand_Team(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if (args.len() != 2)
        return

    int team = int(args[1])
    if( team <= 1 ) return
    array<entity> players = []

    if (args[0].tolower() == "all")
    {
        players = GetPlayerArray()
    }
    else
    {
        players.append(GetPlayerByNamePrefix(args[0]))
    }

    foreach(targetPlayer in players)
    {
        if (targetPlayer == null || !IsAlive(targetPlayer))
        {
            SSOM_ChatServerPrivateMessage( player, "设置玩家" + targetPlayer.GetPlayerName() + "队伍失败" )
            continue
        }
        try {
            SetTeam(targetPlayer, team)
            SSOM_ChatServerPrivateMessage( player, "已设置玩家" + targetPlayer.GetPlayerName() + "队伍为" + team )
        }
        catch(error)
        {
            SSOM_ChatServerPrivateMessage( player, "设置玩家" + targetPlayer.GetPlayerName() + "队伍时发生错误: " + error )
            print(error)
        }
    }
}