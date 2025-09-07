global function ServerChatCommand_God_Init


void function ServerChatCommand_God_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback( "/god",  ServerChatCommand_God )
}

void function ServerChatCommand_God(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    array<entity> targets = []
    if(args.len() != 1)
    {
        targets.append(player)
    }

    if(args.len() == 1)
    {
        if (args[0].tolower() ==  "all")
        {
            targets = GetPlayerArray()
        }
        else
        {
            targets.append(FindPlayerByNamePrefix(args[0]))
        }
    }
    
    foreach(target in targets)
    {
        if( !IsValid(target) || !IsAlive(target) )
            continue
        if( !target.IsInvulnerable() ){
            target.SetInvulnerable()
            SSOM_ChatServerPrivateMessage(player, "已设置玩家" + target.GetPlayerName() + "为无敌状态！！！")
        }
        else
        {
            target.ClearInvulnerable()
            SSOM_ChatServerPrivateMessage(player, "已取消玩家" + target.GetPlayerName() + "的无敌状态！！！")
        }
    }
}