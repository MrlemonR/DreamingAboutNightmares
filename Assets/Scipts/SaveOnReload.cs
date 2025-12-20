using UnityEngine;

[System.Serializable]
public class SaveOnReload
{
    public float[] position;

    public void PlayerData (PlayerController player)
    {
        position = new float[3];

        position[0] = player.transform.position.x;
        position[1] = player.transform.position.y;
        position[2] = player.transform.position.z;
    }
}