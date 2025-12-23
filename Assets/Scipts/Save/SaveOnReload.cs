using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class SaveOnReload
{
    public float[] position;
    public int RoomNumber;

    public SaveOnReload (PlayerData player) 
    {
        RoomNumber = player.RoomNumber;
        position = new float[3];

        position[0] = player.transform.position.x;
        position[1] = player.transform.position.y;
        position[2] = player.transform.position.z;
    }
}