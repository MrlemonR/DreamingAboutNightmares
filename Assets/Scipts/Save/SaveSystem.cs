using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
public static class SaveSystem
{
    public static void SavePlayer(PlayerData player)
    {
        BinaryFormatter formatter = new BinaryFormatter();
        string path = Application.persistentDataPath + "/player.bombo";
        FileStream stream = new FileStream(path, FileMode.Create);

        SaveOnReload data = new SaveOnReload(player);
        Debug.Log("Saved" + path);
        Debug.Log($"Scene: {data.SceneName}, Room: {data.RoomNumber}, HasBullet: {data.hasBullet}, BulletPos: {data.bulletPos}");
        formatter.Serialize(stream, data);
        stream.Close();
    }

    public static SaveOnReload LoadPlayer()
    {
        string path = Application.persistentDataPath + "/player.bombo";
        if (File.Exists(path))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(path, FileMode.Open);

            SaveOnReload data = formatter.Deserialize(stream) as SaveOnReload;
            stream.Close();
            Debug.Log("Loaded" + path);
            Debug.Log($"Scene: {data.SceneName}, Room: {data.RoomNumber}, HasBullet: {data.hasBullet}, BulletPos: {data.bulletPos}");
            return data;
        }
        else
        {
            Debug.Log("File Not Found" + path);
            return null;
        }
    }
    public static void DeleteSaveFile()
    {
        string path = Application.persistentDataPath + "/player.bombo";
        if (File.Exists(path))
        {
            Debug.Log("Deleted" + path);
            File.Delete(path);
        }
    }
}
