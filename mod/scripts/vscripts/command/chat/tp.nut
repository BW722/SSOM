global function ServerChatCommand_Tp_Init

void function ServerChatCommand_Tp_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/tp", ServerChatCommand_Tp)
}

void function ServerChatCommand_Tp(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if( args.len() != 2 )
        return

    array<entity> subjects = []

    if ( args[0].tolower() == "all" )
    {
        subjects = GetPlayerArray()
    } 
    else
    {
        subjects.append( GetPlayerByNamePrefix(args[0]) )
    }
    entity target = GetPlayerByNamePrefix(args[1])
    if( target == null || !IsAlive(target) )
        return

    foreach(subject in subjects)
    {
        if (subject == null || !IsAlive(subject))
            continue
        thread TeleportPlayerToPlayer(subject, target)
    }
}

void function TeleportPlayerToPlayer(entity subject, entity target)
{
    vector targetOrigin = target.GetOrigin()
    subject.SetInvulnerable()
    target.SetInvulnerable()
    WaitEndFrame()
    EmitSoundOnEntity( subject, "Timeshift_Scr_DeviceShift2Present" )
    wait 0.25
    subject.SetOrigin(targetOrigin)
    subject.ClearInvulnerable()
    target.ClearInvulnerable()
}