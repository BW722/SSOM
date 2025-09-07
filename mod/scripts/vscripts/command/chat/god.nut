global function ServerChatCommand_God_Init

void function ServerChatCommand_God_Init()
{
    if (IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/god", ServerChatCommand_God)
}

void function ServerChatCommand_God(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！")
        return
    }

    array<entity> targets = SSOM_GetTargetPlayers(player, args)
    if(targets.len() == 0)
    {
        string targetName = args.len() > 0 ? args[0] : "自己"
        SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + targetName)
        return
    }

    bool isAll = args.len() > 0 && args[0].tolower() == "all"
    int successCount = 0
    int enabledCount = 0 // 启用无敌的玩家数量
    int disabledCount = 0 // 禁用无敌的玩家数量
    
    foreach(target in targets)
    {
        if(!IsValid(target) || !IsAlive(target))
            continue

        bool wasInvulnerable = target.IsInvulnerable()
        if (wasInvulnerable)
        {
            target.ClearInvulnerable()
            disabledCount++
        }
        else
        {
            target.SetInvulnerable()
            enabledCount++
        }
        
        successCount++
        
        if (!isAll)
        {
            string actionMessage = wasInvulnerable ? "取消无敌" : "设置无敌"
            string targetName = (target == player) ? " 自己" : "玩家 " + target.GetPlayerName()
            SSOM_ChatServerPrivateMessage(player, "已为" + targetName + " " + actionMessage)
        }
    }

    if (isAll)
    {
        string message = "已处理所有玩家（共" + successCount + "人）"
        
        if (enabledCount > 0 && disabledCount > 0)
        {
            message += "，其中" + enabledCount + "人开启无敌，" + disabledCount + "人关闭无敌"
        }
        else if (enabledCount > 0)
        {
            message += "，全部开启无敌"
        }
        else if (disabledCount > 0)
        {
            message += "，全部关闭无敌"
        }
        else
        {
            message += "，无敌状态无变化"
        }
        
        SSOM_ChatServerPrivateMessage(player, message)
    }
}