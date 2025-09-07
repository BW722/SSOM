untyped
global function ServerChatCommand_Man_Init

global function dropship

void function ServerChatCommand_Man_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    RegisterWeaponDamageSource( "Man", "Man" )
    AddServerChatCommandCallback("/man", ServerChatCommand_Man)
}

void function ServerChatCommand_Man(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if( args.len() != 1 )
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
    foreach(subject in subjects)
    {
        if( subject == null || !IsAlive(subject) )
            continue
        SSOM_ChatServerPrivateMessage( subject, "牢大来咯！！！" )
        thread dropship(subject,player)
    }
}

void function dropship(entity ent,entity target)
{
    vector entpos = ent.GetOrigin()

    // 创建效果并设置随机颜色
    entity effect = PlayFX($"P_ar_titan_droppoint", entpos)
    EffectSetControlPointVector(effect, 1, <RandomIntRangeInclusive(0,255), RandomIntRangeInclusive(0,255), RandomIntRangeInclusive(0,255)>)

    // 创建并配置运载船
    vector spawnPos = entpos + <5000, 5000, 5000>
    entity ship = CreateGunship( ent.GetTeam(), spawnPos, <0.50, -0.5, 0.5> )
    DispatchSpawn(ship)
    ship.Freeze()

    // 创建移动控制器并设置移动
    entity mover = CreateOwnedScriptMover(ship)
    ship.SetParent(mover)
    mover.NonPhysicsMoveTo(entpos, 3.0, 0.0, 0.0)

    // 等待移动完成
    wait 3.0

    // 创建爆炸效果
    vector explosionPos = entpos + <0, 0, 50>
    Explosion(
        explosionPos,            // 爆炸位置
        target,             // 爆炸所有者
        null,                    // 伤害源
        1000,                     // 伤害
        5000,                    // 半径
        700,                     // 力度
        700,                     // 垂直力度
        SF_ENVEXPLOSION_NOSOUND_FOR_ALLIES,  // 标志
        explosionPos,            // 声音位置
        100,                     // 音效范围
        damageTypes.explosive,   // 伤害类型
        eDamageSourceId.Man,  // 伤害源ID
        CLUSTER_ROCKET_FX_TABLE  // 特效表
    )

    // 清理实体
    if (IsValid(ship) && IsAlive(ship))
    {
        ship.ClearParent()
        ship.Die()
    }
    
    if (IsValid(mover))
        mover.Die()
    
    if (IsValid(effect))
        effect.Die()
}

void function DropNukeTitan( vector pos, entity player )
{
	if( !IsValid( player ) )
		return
	PlayImpactFXTable( pos, player, "exp_sonar_pulse" )

	entity titan = CreateOgre( TEAM_UNASSIGNED, pos, < 0, RandomInt( 360 ), 0 > )
	titan.EndSignal( "OnDestroy" )

	SetTeam( titan, player.GetTeam() )
	DispatchSpawn( titan )

	titan.kv.script_hotdrop = "4"
	thread PlayersTitanHotdrops( titan, pos, < 0, RandomInt( 360 ), 0 >, player, "at_hotdrop_drop_2knee_turbo" )
	//ClassicRodeo_SetSoulBatteryCount( titan.GetTitanSoul(), false )

	Remote_CallFunction_Replay( player, "ServerCallback_ReplacementTitanSpawnpoint", pos.x, pos.y, pos.z, Time() + GetHotDropImpactTime( titan, "at_hotdrop_drop_2knee_turbo" ) + 1.6 )

	DoomTitan( titan )
	titan.SetBossPlayer(player) // Do this so that if we crush something we get awarded the kill.

	entity soul = titan.GetTitanSoul()
	soul.soul.nukeAttacker = player // Use this to get credit for the explosion kills.

	NPC_SetNuclearPayload( titan )

	titan.WaitSignal( "ClearDisableTitanfall" )
	titan.ClearBossPlayer() // Stop being the boss so we don't get an award for this titan blowing up.

	titan.s.OrbitalStrikeKillStreak <- true
	thread TitanEjectPlayer( titan, true )
}

void function SSOM_Test(entity player)
{
    vector playerOrigin = player.GetOrigin()

    entity SuperSpectre = CreateSuperSpectre( 2, playerOrigin, < 0, RandomInt( 360 ), 0 > )
    DispatchSpawn( SuperSpectre )
}