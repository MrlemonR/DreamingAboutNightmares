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

            return data;
        }
        else
        {
            Debug.Log("File Not Found nigga " + path);
            return null;
        }
    }
}
