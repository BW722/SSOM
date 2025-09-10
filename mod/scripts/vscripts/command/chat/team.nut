global function ServerChatCommand_Team_Init


void function ServerChatCommand_Team_Init()
{
    AddServerChatCommandCallback("/team", ServerChatCommand_Team)
}

void function ServerChatCommand_Team(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if(args.len() != 2){
        SSOM_ChatServerPrivateMessage(player, "用法：/team < playerName/all > < team >")
        return
    }

    string command0 = args[0]
    string command1 = args[1]

    if(hasNonDigit(command0)){
        SSOM_ChatServerPrivateMessage(player, "队伍必须是数字")
        return
    }

    int team
    try{
        team = int(command0)
    }catch(error){
        SSOM_ChatServerPrivateMessage(player, "错误: " + string(error))
        return
    }
    
    if(team < 2)
    {
        SSOM_ChatServerPrivateMessage(player, "队伍必须大于等于2")
        return
    }

    array<entity> targets = []
    switch(command1.tolower()){
        case "all":
            targets = GetPlayerArray()
            break
        default:
            targets = GetPlayersByNamePrefix(command1)
            break
    }

    foreach(target in targets)
    {
        if( !IsValid(target) || !IsValid(target) ){
            SSOM_ChatServerPrivateMessage(player, "玩家 " + target.GetPlayerName() + " 跳过设置队伍")
            continue
        }
        try{
            SetTeam(target, team)
            SSOM_ChatServerPrivateMessage(player, "已设置玩家 " + target.GetPlayerName() + " 的队伍为 " + team)
        }catch (error){
            SSOM_ChatServerPrivateMessage(player, "错误: " + string(error))
        }
    }
}