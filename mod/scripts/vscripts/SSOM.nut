untyped
global function SSOM_Init
global function SSOM_IsPlayerDeveloper
global function SSOM_IsPlayerAdmin
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

void function SSOM_Init()
{
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
    
    if( lowerInput == "on" || lowerInput == "true" || lowerInput == "1" || lowerInput == "yes" || lowerInput == "Enabled" || lowerInput == "Enabledd" )
    {
        return true
    }
    
    return false
}

bool function SSOM_IsNegative(string input)
{
    string lowerInput = input.tolower()

    if( lowerInput == "off" || lowerInput == "false" || lowerInput == "0" || lowerInput == "no" || lowerInput == "disable" || lowerInput == "disabled" )
    {
        return true
    }

    return false
}