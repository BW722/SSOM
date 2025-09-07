global function ServerChatCommand_AntiAFK_Init
global function SSOM_SetAntiAFKEnabled
global function SSOM_IsAntiAFKEnabled

int AFK_WARN_TIME = 70

void function ServerChatCommand_AntiAFK_Init()
{
    if( IsLobby() || IsMenuLevel() )
        return
    RegisterSignal( "SSOM_AntiAFK_Stop" )
    AddCallback_OnPlayerRespawned( OnPlayerRespawned )
    AddServerChatCommandCallback( "/anti_afk", ServerChatCommand_AntiAFK )
}

void function OnPlayerRespawned( entity player )
{
    if(SSOM_IsPlayerAdmin(player))
        return
    if( SSOM_IsAntiAFKEnabled() )
    {
        thread AntiAFKMonitor( player )
    }
}

void function AntiAFKMonitor( entity player )
{
    player.EndSignal( "OnDestroy" )
    player.EndSignal( "OnDeath" )
    player.EndSignal( "SSOM_AntiAFK_Stop" )

    vector lastOrigin = player.GetOrigin()
    int afkTime = 0
    bool warned = false
    
    while( true )
    {
        wait 1.0
        
        if( !SSOM_IsAntiAFKEnabled() )
            break
            
        vector currentOrigin = player.GetOrigin()
        
        if( Distance( currentOrigin, lastOrigin ) < 10.0 )
        {
            afkTime++
            
            if( afkTime >= AFK_WARN_TIME / 2 )
            {
                SSOM_ChatServerPrivateMessage( player, "警告：检测到挂机行为，请移动以避免被踢出！！！" )
                warned = true
            }
            
            if ( afkTime >= AFK_WARN_TIME )
            {
                SSOM_KickPlayer( player, "挂机" )
                break
            }
        }
        else
        {
            afkTime = 0
            lastOrigin = currentOrigin
        }
    }
}

void function ServerChatCommand_AntiAFK( entity player, array<string> args )
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage( player, "你没有管理员权限！！！" )
        return
    }
    
    if ( args.len() != 1 )
        return
    
    string arg0 = args[0].tolower()
    bool newStatus = SSOM_IsAffirmative( arg0 )

    if( newStatus == SSOM_IsAntiAFKEnabled() )
        return
    
    SSOM_SetAntiAFKEnabled( newStatus )
    
    string statusMessage = newStatus ? "开启" : "关闭"
    SSOM_ChatServerBroadcast( "反挂机已" + statusMessage + "！！！" )
}

void function SSOM_SetAntiAFKEnabled( bool enabled )
{
    if( SSOM_IsAntiAFKEnabled() == enabled )
        return
    
    SetConVarBool( "SSOM_AntiAFKEnabled", enabled )
    
    if( enabled )
    {
        foreach( player in GetPlayerArray() )
        {
            if( !IsAlive( player ) )
                continue
            if( SSOM_IsPlayerAdmin(player) )
                continue
            thread AntiAFKMonitor( player )
        }
    }
    else
    {
        foreach( player in GetPlayerArray() )
        {
            player.Signal( "SSOM_AntiAFK_Stop" )
        }
    }
}

bool function SSOM_IsAntiAFKEnabled()
{
    return GetConVarBool("SSOM_AntiAFKEnabled")
}