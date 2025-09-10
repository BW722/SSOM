global function ServerChatCommand_Admin_Init


void function ServerChatCommand_Admin_Init(){
    AddServerChatCommandCallback( "/admin", ServerChatCommand_Admin )
}

void function ServerChatCommand_Admin( entity player, array<string> args ){
    SSOM_ChatServerPrivateMessage(player, "开发中...")
}