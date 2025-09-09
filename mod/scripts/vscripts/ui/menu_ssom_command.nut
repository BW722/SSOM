global function Menu_SSOMCommand_Init
global function OpenSSOMCommand

struct Command
{
	string label
	string command
	var opParm
	void functionref( var ) func
	bool storeAsLastCommand = true
}

struct
{
	array<var> buttons
    array<Command> Commands
}
file

void function Menu_SSOMCommand_Init()
{
	AddMenu( "SSOMCommand", $"resource/ui/menus/ssom_command.menu" )
	var menu = GetMenu( "SSOMCommand" )

	//RuiSetString( menu, "labelText", "SSOM COMMAND " + "v" + SSOM_GetVersion() )

	file.buttons = GetElementsByClassname( menu, "DevButtonClass" )
	foreach( button in file.buttons )
	{
		Hud_SetText( button, "" )
		Hud_SetEnabled( button, false )
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
	}
}

void function SetupDefaultCommands()
{
	file.Commands.clear()
    SetupCommand("Noclip", "say /noclip")

	string command = "say /cheats 1"

	if(GetConVarBool("sv_cheats"))	command = "say /cheats 0"

    SetupCommand("Cheats", command)

    SetupCommand("Fold Start", "say /fold start")
    SetupCommand("Fold Stop", "say /fold stop")

    SetupCommand("Chat on", "say /chat on")
    SetupCommand("Chat off", "say /chat off")

    SetupCommand("God", "say /god")

    SetupCommand("Hide", "say /hide")
    SetupCommand("Show", "say /show")

    SetupCommand("Player list", "say /player list")

    SetupCommand("Kill", "say /kill")

	SetupCommand("Anti Afk on", "say /anti_afk on")
	SetupCommand("Anti Afk off", "say /anti_afk off")

	SetupCommand("Msg on", "say /msg on")
	SetupCommand("Msg off", "say /msg off")

	SetupCommand("Skip", "say /skip")

	SetupCommand("Balance", "say /balance")

    SetupCommand("Kill All Boss", "say /kill_all_boss")
    SetupCommand("CreateBoss ash", "say /create_boss ash")
    SetupCommand("CreateBoss viper", "say /create_boss viper")
    SetupCommand("CreateBoss richter", "say /create_boss richter")
    SetupCommand("CreateBoss slone", "say /create_boss slone")
    SetupCommand("CreateBoss kane", "say /create_boss kane")
    SetupCommand("CreateBoss blisk", "say /create_boss blisk")
    SetupCommand("CreateBoss all", "say /create_boss all")
}

void function OnButton_Activate( var button )
{
    int buttonID = int( Hud_GetScriptID( button ) )
	Command cmd = file.Commands[buttonID]

	RunCommand( cmd )
}

void function RunCommand( Command cmd )
{
	if ( cmd.command != "" )
	{
		ClientCommand( cmd.command )
		CloseAllInGameMenus()
	}
	else
	{
		cmd.func( cmd.opParm )
	}
}

void function OpenSSOMCommand()
{
	SetupDefaultCommands()
    UpdateMenuButtons()
	AdvanceMenu(GetMenu("SSOMCommand"))
}

void function SetupCommand( string label, string command )
{
	Command cmd
	cmd.label = label
	cmd.command = command

	file.Commands.append( cmd )
}

void function SetupFunc( string label, void functionref( var ) func, var opParm = null )
{
	Command cmd
	cmd.label = label
	cmd.func = func
	cmd.opParm = opParm

	file.Commands.append( cmd )
}

void function UpdateMenuButtons()
{

	foreach ( index, button in file.buttons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID < file.Commands.len() )
		{
			RuiSetString( Hud_GetRui( button ), "buttonText", file.Commands[buttonID].label )
			Hud_SetEnabled( button, true )
		}
		else
		{
			RuiSetString( Hud_GetRui( button ), "buttonText", "" )
			Hud_SetEnabled( button, false )
		}
	}
}