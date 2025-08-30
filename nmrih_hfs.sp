




#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <clients>

public Plugin myinfo =
{
	name = "受伤满状态",
	author = "PLTAT",
	description = "玩家受伤时回满所有状态.",
	version = "20250901013030",
	url = "https://github.com/pltat"
}

public void OnPluginStart()
{
	/**
	 * 高级编译需要 布尔值 是否自动创建
	 * 无需 .cfg
	 */
	AutoExecConfig(true, "nmrih_hurt-full-status");
	
	/**
	 * 无需 .txt
	 */
	LoadTranslations("nmrih_hurt-full-status.phrases");
	
	/**
	 * 用 插件 监控 游戏
	 * 服务器内所有事件 所有玩家受伤将会被映射
	 */
	HookEvent("player_hurt", look_engine_event_player_hurt);
}

/**
 * 数据 userid attacker weapon
 * 监控的类型 player_hurt
 * 返回值 true未广播 false广播或即将广播
 */
public void look_engine_event_player_hurt(Event return_data, const char[] name, bool dontBroadcast)
{
	/**
	 * 获取数据 https://wiki.alliedmods.net/No_More_Room_in_Hell_Events#player_hurt
	 */
	int engine_random_client_number = return_data.GetInt("userid");
	
	/**
	 * 引擎随机数 转换为 插件自然数 如114514 到1-9
	 */
	int sourcemod_client_index_number = GetClientOfUserId(engine_random_client_number);
	
	char PlayerName[MAX_NAME_LENGTH];
	
	if (!GetClientName(sourcemod_client_index_number, PlayerName, sizeof(PlayerName)))
	{
	    PrintToServer("%T", LANG_SERVER, "Fail_Get_Name", sourcemod_client_index_number);
	}
	
	if (sourcemod_client_index_number >= 1 && sourcemod_client_index_number <= MaxClients)
	{
	    
		if (IsClientConnected(sourcemod_client_index_number) && IsClientInGame(sourcemod_client_index_number) && !IsClientInKickQueue(sourcemod_client_index_number) && !IsClientObserver(sourcemod_client_index_number))
		{
		    SetEntityHealth(sourcemod_client_index_number, 2147483647);
			SetEntProp(sourcemod_client_index_number, Prop_Data, "m_ArmorValue", 2147483647);
			SetEntPropFloat(sourcemod_client_index_number, Prop_Send, "m_flStamina", 2147483647.0);
			SetEntProp(sourcemod_client_index_number, Prop_Send, "_bleedingOut", 0);
			SetEntProp(sourcemod_client_index_number, Prop_Send, "_vaccinated", 1);
		}
		else
		{
		    if (!IsClientConnected(sourcemod_client_index_number))
			{
			    PrintToServer("%T", LANG_SERVER, "Client_Not_Connected", sourcemod_client_index_number, PlayerName);
			}
			else if (!IsClientInGame(sourcemod_client_index_number))
			{
			    PrintToServer("%T", LANG_SERVER, "Client_Not_In_Game", sourcemod_client_index_number, PlayerName);
			}
			else if (IsClientInKickQueue(sourcemod_client_index_number))
			{
			    PrintToServer("%T", LANG_SERVER, "Client_In_Kick_Queue", sourcemod_client_index_number, PlayerName);
			}
			else if (IsClientObserver(sourcemod_client_index_number))
			{
			    PrintToServer("%T", LANG_SERVER, "Client_Is_Observer", sourcemod_client_index_number, PlayerName);
			}
		}
		
	}
	else
	{
	    PrintToServer("%T", LANG_SERVER, "Not_Find_Index", sourcemod_client_index_number, MaxClients);
	}
}




