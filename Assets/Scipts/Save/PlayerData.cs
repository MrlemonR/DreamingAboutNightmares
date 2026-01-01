using UnityEngine;

public class PlayerData : MonoBehaviour
{
    public int RoomNumber;
    public string SceneName;
    public bool hasBullet;
    public int bulletPos;
    
    private static PlayerData instance;

    void Awake()
    {
        // Singleton pattern - sadece bir PlayerData instance olsun
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
            return;
        }
    }

    public void SavePlayer()
    {
        SaveSystem.SavePlayer(this);
    }

    public void LoadPlayer()
    {
        SaveOnReload data = SaveSystem.LoadPlayer();
        if (data != null)
        {
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
}