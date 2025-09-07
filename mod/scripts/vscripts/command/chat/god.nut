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

    array<entity> subjects = []
    if(args.len() != 1)
    {
        subjects.append(player)
    }

    if(args.len() == 1)
    {
        if (args[0].tolower() ==  "all")
        {
            subjects = GetPlayerArray()
        }
        else
        {
            subjects.append(GetPlayerByNamePrefix(args[0]))
        }
    }
    
    foreach(subject in subjects)
    {
        if( IsValid(subject) || !IsAlive(subject) )
            continue
        if( !subject.IsInvulnerable() ){
            subject.SetInvulnerable()
            SSOM_ChatServerPrivateMessage(player, "已设置玩家" + subject.GetPlayerName() + "为无敌状态！！！")
        }
        else
        {
            subject.ClearInvulnerable()
            SSOM_ChatServerPrivateMessage(player, "已取消玩家" + subject.GetPlayerName() + "的无敌状态！！！")
        }
    }
}