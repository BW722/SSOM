global function ServerChatCommand_Tf_Init
global function SSOM_Titanfall

void function ServerChatCommand_Tf_Init()
{
    if (IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/tf", ServerChatCommand_Tf)
}

void function ServerChatCommand_Tf(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 1)
        return

    array<entity> targets = SSOM_GetTargetPlayers(player, args)
    if(targets.len() == 0)
    {
        SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + args[0])
        return
    }

    int successCount = 0
    foreach(target in targets)
    {
        if(IsValid(target) && IsAlive(target))
        {
            thread SSOM_Titanfall(target)
            successCount++
        }
    }

    if(args[0].tolower() == "all")
        SSOM_ChatServerPrivateMessage(player, "已为所有玩家降落泰坦（共" + successCount + "人）")
    else if (args.len() > 0)
        SSOM_ChatServerPrivateMessage(player, "已为玩家: " + targets[0].GetPlayerName() + " 降落泰坦")
    else
        SSOM_ChatServerPrivateMessage(player, "已为自己降落泰坦")
}

void function SSOM_Titanfall(entity player)
{
    if(player.IsTitan())
        return
        
    if(SpawnPoints_GetTitan().len() > 0)
    {
        CreateTitanForPlayerAndHotdrop(player, GetTitanReplacementPoint(player, false))
    }
}