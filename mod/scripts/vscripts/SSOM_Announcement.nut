global function SSOM_Announcement_Init


void function SSOM_Announcement_Init()
{
    AddCallback_OnClientConnected(OnClientConnected)
}

void function OnClientConnected(entity player)
{
    thread ClientConnected(player)
}

void function ClientConnected(entity player)
{
    string announcement = GetConVarString("SSOM_Announcement")
    if(announcement != "")
    {
        SSOM_ChatServerPrivateMessage(player, "公告：" + announcement)
    }
}