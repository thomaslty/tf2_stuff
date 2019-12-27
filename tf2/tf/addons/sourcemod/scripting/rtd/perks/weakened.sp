/**
* Weakened perk.
* Copyright (C) 2018 Filip Tomaszewski
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


public void Weakened_Call(int client, Perk perk, bool apply){
	if(apply) Weakened_ApplyPerk(client, perk);
	else SDKUnhook(client, SDKHook_OnTakeDamage, Weakened_OnTakeDamage);
}

void Weakened_ApplyPerk(int client, Perk perk){
	SetFloatCache(client, perk.GetPrefFloat("multiplier"));
	SDKHook(client, SDKHook_OnTakeDamage, Weakened_OnTakeDamage);
}

public Action Weakened_OnTakeDamage(int client, int &iAtk, int &iInflictor, float &fDmg, int &iType){
	if(client == iAtk)
		return Plugin_Continue;

	fDmg *= GetFloatCache(client);
	return Plugin_Changed;
}
