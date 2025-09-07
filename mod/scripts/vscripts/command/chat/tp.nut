global function ServerChatCommand_Tp_Init

void function ServerChatCommand_Tp_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/tp", ServerChatCommand_Tp)
}

void function ServerChatCommand_Tp(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 2)
        return

    array<entity> subjects = []
    if(args[0].tolower() == "all")
    {
        subjects = GetPlayerArray()
    }
    else
    {
        array<entity> foundPlayers = SSOM_GetTargetPlayers(player, [args[0]])
        if(foundPlayers.len() == 0)
        {
            SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + args[0])
            return
        }
        subjects = foundPlayers
    }

    array<entity> targetPlayers = SSOM_GetTargetPlayers(player, [args[1]])
    if(targetPlayers.len() == 0)
    {
        SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + args[1])
        return
    }
       
    entity target = targetPlayers[0]
    if(!IsAlive(target))
    {
        SSOM_ChatServerPrivateMessage(player, "玩家" + target.GetPlayerName() + "已经死亡")
        return
    }

    int successCount = 0
    foreach(subject in subjects)
    {
        if(IsValid(subject) && IsAlive(subject))
        {
            thread TeleportPlayerToPlayer(subject, target)
            successCount++
        }
    }

    if (args[0].tolower() == "all")
        SSOM_ChatServerPrivateMessage(player, "已传送所有玩家（共" + successCount + "人）到 " + target.GetPlayerName())
    else
        SSOM_ChatServerPrivateMessage(player, "已传送 " + subjects[0].GetPlayerName() + " 到 " + target.GetPlayerName())
}

void function TeleportPlayerToPlayer(entity subject, entity target)
{
    vector targetOrigin = target.GetOrigin()
    subject.SetInvulnerable()
    target.SetInvulnerable()
    WaitEndFrame()
    EmitSoundOnEntity(subject, "Timeshift_Scr_DeviceShift2Present")
    wait 0.25
    subject.SetOrigin(targetOrigin)
    subject.ClearInvulnerable()
    target.ClearInvulnerable()
}