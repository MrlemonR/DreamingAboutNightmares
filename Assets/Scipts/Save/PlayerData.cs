using UnityEngine;

public class PlayerData : MonoBehaviour
{
    public int RoomNumber;
    public void SavePlayer()
    {
        SaveSystem.SavePlayer(this);
    }
    
    public void LoadPlayer()
    {
        SaveOnReload data = SaveSystem.LoadPlayer();
        
        RoomNumber = data.RoomNumber;

        Vector3 position;
        position.x = data.position[0];
        position.y = data.position[1];
        position.z = data.position[2];
        transform.position = position;
    }
}
