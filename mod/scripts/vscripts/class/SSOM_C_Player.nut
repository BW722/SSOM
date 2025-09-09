untyped
global function SSOM_C_Player_Init


void function SSOM_C_Player_Init()
{
	function C_Player::GetPlayerPing()
    {
		entity player = expect entity( this ) 
		return GetPlayerPing(player)
    }
	function C_Player::GetPing()
    {
		return this.GetPlayerPing()
    }
}