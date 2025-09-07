global function ServerChatCommand_Hack_Init
global function SSOM_GiveAntiCheatWeapon

const int HACK_TEAM = 3
const int PLAYER_TEAM = 2

string HACK_NAME = ""
string HACK_UID = ""

void function ServerChatCommand_Hack_Init()
{
    if (IsLobby() || IsMenuLevel())
        return
        
    FlagInit("CoopGeneratorUnderattackAlarmStop")
    AddCallback_OnClientConnected(OnClientConnected)
    AddCallback_OnClientDisconnected(OnClientDisconnected)
    AddCallback_OnPlayerRespawned(OnPlayerRespawned)
    AddServerChatCommandCallback("/hack", ServerChatCommand_Hack)
}

void function OnClientConnected(entity player)
{        
    if(SSOM_IsHackPlayer(player))
    {
        SSOM_print("外挂: " + HACK_NAME + " (" + HACK_UID + ") 已加入游戏")
        SSOM_ChatServerBroadcast("外挂: " + HACK_NAME + " (" + HACK_UID + ") 已加入游戏")
        thread SSOM_SetHackPlayer(player)
        thread HighlightPlayer(player)
    }
    else if(SSOM_IsHackMode())
    {
        SetTeam(player, PLAYER_TEAM)
        SSOM_BroadcastHackInfo()
    }
}

void function OnClientDisconnected(entity player)
{
    if(!SSOM_IsHackMode())
        return

    if(SSOM_IsHackPlayer(player))
    {
        SSOM_print("外挂: " + HACK_NAME + " (" + HACK_UID + ") 已退出游戏")
        SSOM_ChatServerBroadcast("外挂: " + HACK_NAME + " (" + HACK_UID + ") 已退出游戏")
        thread SSOM_SetHackPlayer(null)
    }
}

void function OnPlayerRespawned(entity player)
{
    if(!SSOM_IsHackMode())
        return

    if(SSOM_IsHackPlayer(player))
    {
        TakeWeaponsForArray(player, player.GetMainWeapons())
        thread HighlightPlayer(player)
    }
    else
    {
        SSOM_GiveAntiCheatWeapon(player)
    }
}

void function ServerChatCommand_Hack(entity player, array<string> args)
{    
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！")
        return
    }

    if(args.len() != 1)
        return
        
    string arg0 = args[0].tolower()
    if(arg0 == "stop")
    {
        if(HACK_NAME == "" || HACK_UID == "")
            return
        thread SSOM_SetHackPlayer(null)
    }
    else
    {
        if(HACK_NAME != "" || HACK_UID != "")
            return
        
        entity hackPlayer = FindPlayerByNamePrefix(arg0)
        if(hackPlayer == null || !IsValid(hackPlayer))
            return
        
        if(SSOM_IsHackPlayer(hackPlayer))
            return
        
        thread SSOM_SetHackPlayer(hackPlayer)
    }
}

void function SSOM_GiveAntiCheatWeapon(entity player)
{  
    player.SetModel($"models/humans/heroes/mlt_hero_jack.mdl")
    player.SetMaxHealth(1000)
    player.SetHealth(player.GetMaxHealth())

    TakeWeaponsForArray(player, player.GetMainWeapons())

    player.TakeOffhandWeapon(OFFHAND_MELEE)
    player.TakeOffhandWeapon(OFFHAND_SPECIAL)
    player.TakeOffhandWeapon(OFFHAND_ANTIRODEO)
    player.TakeOffhandWeapon(OFFHAND_ORDNANCE)

    player.GiveWeapon("mp_titanweapon_sticky_40mm", ["gunship_gunner", "splasher_rounds", "fast_reload"])
    player.GiveWeapon("mp_titanweapon_predator_cannon", ["Smart_Core"])
    player.GiveWeapon("mp_titanweapon_xo16_vanguard", ["arc_rounds_with_battle_rifle", "rapid_reload", "fd_vanguard_utility_2"])

    player.GiveOffhandWeapon("melee_titan_punch_fighter", OFFHAND_MELEE)
    player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_SPECIAL)
    player.GiveOffhandWeapon("mp_ability_holopilot_nova", OFFHAND_ANTIRODEO)
    player.GiveOffhandWeapon("mp_titanability_electric_smoke", OFFHAND_ORDNANCE)
}

void function SSOM_BroadcastHackInfo()
{
    if(HACK_NAME == "" || HACK_UID == "")
        return
        
    SSOM_ChatServerBroadcast("|==================[HACK]==================|")
    SSOM_ChatServerBroadcast(" 玩家: " + HACK_NAME + " (" + HACK_UID + ")")
    SSOM_ChatServerBroadcast("|========================================|")
}

void function CoopGeneratorUnderattackAlarm()
{
    FlagEnd("CoopGeneratorUnderattackAlarmStop")
    
    while(true)
    {
        EmitSoundToAllPlayers("coop_generator_underattack_alarm")
        wait 2.0
    }
}

void function HighlightPlayer(entity player)
{     
    player.EndSignal("OnDestroy")
    player.EndSignal("OnDeath")
    
    while(true)
    {
        if(!Hightlight_HasEnemyHighlight(player, "enemy_boss_bounty"))
        {
            Highlight_SetEnemyHighlight(player, "enemy_boss_bounty")
        }
        WaitFrame()
    }
}

void function SSOM_SetHackPlayer(entity player)
{
    if(player == null || !IsValid(player))
    {
        HACK_NAME = ""
        HACK_UID = ""
        
        FlagSet("CoopGeneratorUnderattackAlarmStop")
        FlagClear("CoopGeneratorUnderattackAlarmStop")

        SSOM_KillAllPlayers()

        SSOM_Balance()
        return
    }
    
    HACK_NAME = player.GetPlayerName()
    HACK_UID = GetPlayerUID(player)
    SetTeam(player, HACK_TEAM)
    
    thread HighlightPlayer(player)
    SSOM_BroadcastHackInfo()

    SendAnnouncementMessageToAllAlivePlayers("外掛", "玩家: " + HACK_NAME + " (" + HACK_UID + ")", <255, 0, 0>, 1, 1)
    SendLargeMessageToAllAlivePlayers("外掛", "玩家: " + HACK_NAME + " (" + HACK_UID + ")", 6, "rui/callsigns/callsign_16_col")
    SendPopUpMessageToAllAlivePlayers("外掛: " + HACK_NAME + " (" + HACK_UID + ")")
    SendInfoMessageToAllAlivePlayers("外掛: " + HACK_NAME + " (" + HACK_UID + ")")

    thread CoopGeneratorUnderattackAlarm()

    foreach(p in GetPlayerArray())
    {
        if(SSOM_IsHackPlayer(p))
            continue
            
        SetTeam(p, PLAYER_TEAM)
        if (IsAlive(p))
            SSOM_GiveAntiCheatWeapon(p)
    }
    
    wait 7.0
    SendAnnouncementMessageToAllAlivePlayers("擊殺", "玩家: " + HACK_NAME + " (" + HACK_UID + ")", <255, 0, 0>, 10, 5)
    SendLargeMessageToAllAlivePlayers("擊殺", "玩家: " + HACK_NAME + " (" + HACK_UID + ")", 10, "rui/callsigns/callsign_16_col")
    SendPopUpMessageToAllAlivePlayers("擊殺: " + HACK_NAME + " (" + HACK_UID + ")")
    SendInfoMessageToAllAlivePlayers("擊殺: " + HACK_NAME + " (" + HACK_UID + ")")
    SSOM_ChatServerBroadcast("擊殺: " + HACK_NAME + " (" + HACK_UID + ")")
}

bool function SSOM_IsHackMode()
{
    return HACK_UID != "" && HACK_NAME != ""
}

bool function SSOM_IsHackPlayer(entity player)
{        
    string playerUID = player.GetUID()
    if(playerUID == HACK_UID)
        return true
        
    string hackUIDs = GetConVarString("SSOM_HackUID")
    array<string> uids = split(hackUIDs, ",")
    return uids.contains(playerUID)
}