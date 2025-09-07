global function ServerChatCommand_Show_Init


void function ServerChatCommand_Show_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback( "/show", ServerChatCommand_Show )
}

void function ServerChatCommand_Show(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    array<entity> targets = []

    if (args.len() != 1)
    {
        targets.append(player)
    }
    else if(args.len() == 1)
    {
        if (args[0].tolower() == "all")
        {
            targets = GetPlayerArray()
        }
        else
        {
            targets.append(GetPlayerByNamePrefix(args[0]))
        }
    }

    foreach(target in targets)
    {
        if(target == null || !IsAlive(target))
            continue
        target.Show()
        foreach(weapon in target.GetMainWeapons())
        {
            weapon.Show()
        }
    }
}