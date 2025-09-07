untyped
global function ServerChatCommand_Status_Init

struct {
    bool hp = false
    bool kill = false

    string status_hp_id = "SSOM_PlayerStatus_HP"
    string status_kill_id = "SSOM_PlayerStatus_Kill"
} statusSettings

void function ServerChatCommand_Status_Init()
{
    if( IsLobby() || IsMenuLevel() )
        return
        
    RegisterSignal( "SSOM_PlayerStatus_Health_Stop" )
    RegisterSignal( "SSOM_PlayerStatus_Kill_Stop" )

    AddCallback_OnClientConnected( OnClientConnected )
    AddCallback_OnPlayerRespawned( OnPlayerRespawned )
    AddCallback_OnPlayerKilled( OnPlayerKilled )

    AddServerChatCommandCallback( "/status", ServerChatCommand_Status )
}

void function OnClientConnected( entity player )
{
    player.s.kill <- 0
}

void function OnPlayerRespawned( entity player )
{
    if( statusSettings.hp )
        thread PlayerStatus_Health( player )
    
    if( statusSettings.kill )
        thread PlayerStatus_Kill( player )
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
    if( !IsValid( victim ) || !IsValid( attacker ) )
        return
        
    victim.s.kill = 0
    
    if( victim == attacker || !attacker.IsPlayer() )
        return
        
    attacker.s.kill = expect int( attacker.s.kill ) + 1
}

void function PlayerStatus_Health( entity player )
{
    player.EndSignal( "SSOM_PlayerStatus_Health_Stop" )
    player.EndSignal( "OnDestroy" )
    player.EndSignal( "OnDeath" )

    string STATUS_ID = statusSettings.status_hp_id
    
    NSDeleteStatusMessageOnPlayer( player, STATUS_ID )

    OnThreadEnd(
        function() : ( player, STATUS_ID ) {
            if ( IsValid( player ) )
                NSDeleteStatusMessageOnPlayer( player, STATUS_ID )
        }
    )

    NSCreateStatusMessageOnPlayer( player, "血量: ", "", STATUS_ID )
 
    while( IsValid( player ) )
    {
        WaitFrame()

        int Health = player.GetHealth()
        int MaxHealth = player.GetMaxHealth()
        
        if ( Health < 0 ) 
            Health = 0
        
        string message = "血量: " + Health + "/" + MaxHealth
        NSEditStatusMessageOnPlayer( player, message, "", STATUS_ID )
    }
}

void function PlayerStatus_Kill( entity player )
{
    player.EndSignal( "SSOM_PlayerStatus_Kill_Stop" )
    player.EndSignal( "OnDestroy" )
    player.EndSignal( "OnDeath" )

    string STATUS_ID = statusSettings.status_kill_id
    
    NSDeleteStatusMessageOnPlayer( player, STATUS_ID )

    OnThreadEnd(
        function() : ( player, STATUS_ID ) {
            if ( IsValid( player ) )
                NSDeleteStatusMessageOnPlayer( player, STATUS_ID )
        }
    )

    NSCreateStatusMessageOnPlayer( player, "擊殺: ", "", STATUS_ID )

    while( IsValid( player ) )
    {
        WaitFrame()

        int killCount = expect int( player.s.kill )
        
        string message = "擊殺: " + killCount
        NSEditStatusMessageOnPlayer( player, message, "", STATUS_ID )
    }
}

void function ServerChatCommand_Status( entity player, array<string> args )
{  
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage( player, "你没有管理员权限！！！" )
        return
    }
    
    if ( args.len() != 2 )
        return
    
    string statusType = args[0].tolower()
    string arg1 = args[1].tolower()
    bool newStatus = SSOM_IsAffirmative( arg1 )
    
    switch( statusType )
    {
        case "hp":
            statusSettings.hp = newStatus
            break
            
        case "kill":
            statusSettings.kill = newStatus
            break
            
        default:
            SSOM_ChatServerPrivateMessage( player, "未知的状态类型: " + statusType )
            return
    }
    
    UpdateAllPlayersStatus( statusType, newStatus )
    
    string statusMessage = newStatus ? "启用" : "禁用"
    string typeName = ( statusType == "hp" ) ? "血量" : "击杀"
    SSOM_ChatServerBroadcast( "已 " + statusMessage + " " + typeName + " 状态显示" )
}

void function UpdateAllPlayersStatus( string statusType, bool newStatus )
{
    foreach( p in GetPlayerArray() )
    {
        if ( !IsValid( p ) )
            continue
            
        if ( statusType == "hp" )
        {
            if ( newStatus )
                thread PlayerStatus_Health( p )
            else
                p.Signal( "SSOM_PlayerStatus_Health_Stop" )
        }
        else if ( statusType == "kill" )
        {
            if ( newStatus )
                thread PlayerStatus_Kill( p )
            else
                p.Signal( "SSOM_PlayerStatus_Kill_Stop" )
        }
    }
}