global function SSOM_MenuCommand_Init


void function SSOM_MenuCommand_Init()
{
    if( IsLobby() || IsMenuLevel() )
        return
    RegisterButtonPressedCallback( KEY_4, MenuSSOMCommand )
}

void function MenuSSOMCommand(entity player)
{
    RunUIScript( "OpenSSOMCommand" )
    EmitSoundOnEntity( GetLocalClientPlayer(), "UI_InGame_FD_ArmoryOpen" )
}