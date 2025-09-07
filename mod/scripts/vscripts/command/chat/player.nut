global function ServerChatCommand_Player_Init


void function ServerChatCommand_Player_Init()
{
    AddServerChatCommandCallback( "/player", ServerChatCommand_Player )
}

void function ServerChatCommand_Player(entity player, array<string> args)
{
    if(args.len() != 1)
        return
    if (args[0] == "list")
    {
        foreach ( targetPlayer in GetPlayerArray() )
        {
            string name = "[Name: " + targetPlayer.GetPlayerName() + "]"
            string uid = "[UID: " + targetPlayer.GetUID() + "]"
            string team = "[Team: " + targetPlayer.GetTeam() + "]"
            SSOM_ChatServerPrivateMessage( player , team + uid + name )
        }
        return
    }
}