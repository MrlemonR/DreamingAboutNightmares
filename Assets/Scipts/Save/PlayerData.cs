using UnityEngine;

public class PlayerData : MonoBehaviour
{
    public int RoomNumber;
    public string SceneName;
    public bool hasBullet;
    public int bulletPos;
    void Start()
    {
        SaveOnReload data = SaveSystem.LoadPlayer();
        if (data != null)
        {
            LoadPlayer();
        }
    }

    public void SavePlayer()
    {
        SaveSystem.SavePlayer(this);
    }

    public void LoadPlayer()
    {
        SaveOnReload data = SaveSystem.LoadPlayer();

        RoomNumber = data.RoomNumber;
        hasBullet = data.hasBullet;
        bulletPos = data.bulletPos;
        SceneName = data.SceneName;

        Vector3 position;
        position.x = data.position[0];
        position.y = data.position[1];
        position.z = data.position[2];
        transform.position = position;
    }
}
