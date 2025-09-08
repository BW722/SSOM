global function SSOM_Init
global function SSOM_IsPlayerDeveloper
global function SSOM_IsPlayerAdmin
global function SSOM_GetTargetPlayers
global function SSOM_GetAdminArray
global function SSOM_GetSSOMVersion
global function SSOM_SetPrefix
global function SSOM_ChatServerPrivateMessage
global function SSOM_ChatServerBroadcast
global function SSOM_print
global function SSOM_IsAffirmative
global function SSOM_IsNegative

string prefix = "[90m[SSOM][97m"
array<string> developerUIDs = [ "1013199872353" ]

string SSOM_GitHub = "https://github.com/BW722/SSOM"

void function SSOM_Init()
{
    AddServerChatCommandCallback( "/test", ServerChatCommand_SSOM )
    AddServerChatCommandCallback( "/SSOM", ServerChatCommand_SSOM )
}

void function ServerChatCommand_SSOM( entity player, array<string> args )
{
    SSOM_ChatServerPrivateMessage( player, "Name: " + "SSOM" )
    SSOM_ChatServerPrivateMessage( player, "Version: " + SSOM_GetSSOMVersion() )
    SSOM_ChatServerPrivateMessage( player, "GitHub: " + SSOM_GitHub )
}

bool function SSOM_IsPlayerDeveloper(entity player)
{
    string playerUID = GetPlayerUID(player)
    return developerUIDs.contains(playerUID)
}

bool function SSOM_IsPlayerAdmin(entity player)
{
    string playerUID = GetPlayerUID(player)
    return SSOM_IsPlayerDeveloper(player) || split(GetConVarString("SSOM_AdminUID"),",").contains(playerUID)
}

array<entity> function SSOM_GetTargetPlayers(entity player, array<string> args)
{
    array<entity> targets = []
    
    if(args.len() == 0)
    {
        targets.append(player)
    }
    else if(args.len() == 1)
    {
        if(args[0].tolower() == "all")
        {
            targets = GetPlayerArray()
        }
        else
        {
            entity targetPlayer = FindPlayerByNamePrefix(args[0])
            if(IsValid(targetPlayer))
                targets.append(targetPlayer)
        }
    }
    
    return targets
}

array<entity> function SSOM_GetAdminArray()
{
    array<entity> admins = []
    foreach (player in GetPlayerArray())
    {
        if(SSOM_IsPlayerAdmin(player))
        {
            admins.append(player)
        }
    }
    return admins
}

string function SSOM_GetSSOMVersion()
{
    return NSGetModVersionByModName("SSOM")
}

void function SSOM_SetPrefix(string newPrefix)
{
    prefix = newPrefix
}

void function SSOM_ChatServerPrivateMessage(entity player, string message)
{
    Chat_ServerPrivateMessage( player, prefix + message, false, false )
}

void function SSOM_ChatServerBroadcast(string message)
{
    Chat_ServerBroadcast( prefix + message, false )
}

void function SSOM_print(string message)
{
    print( prefix + message + "[0m" )
}

bool function SSOM_IsAffirmative(string input)
{
    string lowerInput = input.tolower()
    
    if( lowerInput == "on" || lowerInput == "true" || lowerInput == "1" || lowerInput == "yes" )
    {
        return true
    }
    
    return false
}

bool function SSOM_IsNegative(string input)
{
    string lowerInput = input.tolower()

    if( lowerInput == "off" || lowerInput == "false" || lowerInput == "0" || lowerInput == "no" )
    {
        return true
    }

    return false
}