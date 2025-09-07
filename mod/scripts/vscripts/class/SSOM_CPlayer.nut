untyped
global function SSOM_CPlayer_Init


void function SSOM_CPlayer_Init()
{
	function CPlayer::Kick( reason )
  {
		entity player = expect entity( this ) 
        SSOM_KickPlayer( player, string(reason) )
  }

	function CPlayer::Ban()
  {
		entity player = expect entity( this ) 
		SSOM_BanPlayer( player ) 
  }

	function CPlayer::GetPlayerUID()
  {
		return this.GetUID()
  }
}