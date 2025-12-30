using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class SaveOnReload
{
    public float[] position;
    public int RoomNumber;
    public string SceneName;
    public bool hasBullet;
    public int bulletPos;

    public SaveOnReload(PlayerData player)
    {
        RoomNumber = player.RoomNumber;
        SceneName = player.SceneName;
        hasBullet = player.hasBullet;
        bulletPos = player.bulletPos;
        
        position = new float[3];

        position[0] = player.transform.position.x;
        position[1] = player.transform.position.y;
        position[2] = player.transform.position.z;
    }
}