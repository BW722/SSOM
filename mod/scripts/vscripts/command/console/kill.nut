global function ServerConsoleCommand_Kill_Init


void function ServerConsoleCommand_Kill_Init()
{
    if(IsServerConsoleCommandRegistered("kill"))    RemoveServerConsoleCommandCallback("kill")
    AddServerConsoleCommandCallback( "kill", ServerConsoleCommand_Kill )
}

bool function ServerConsoleCommand_Kill( entity player, array<string> args )
{
    if( !IsAlive(player) || args.len() != 0 )
        return false
    player.Die()
	return true
}