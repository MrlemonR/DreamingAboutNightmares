using System.Collections.Generic;
using UnityEngine;

public class WindmillSpawner : MonoBehaviour
{
    public Terrain terrain;
    public GameObject windmillPrefab;
    public static List<GameObject> spawnedWindmills = new List<GameObject>();
    public int spawnCount = 10;

    void Start()
    {
        SpawnWindmills();
    }

    void SpawnWindmills()
    {
        TerrainData tData = terrain.terrainData;

        float width = tData.size.x;
        float height = tData.size.z;

        for (int i = 0; i < spawnCount; i++)
        {
            float posX = Random.Range(0, width);
            float posZ = Random.Range(0, height);

            float posY = terrain.SampleHeight(new Vector3(posX, 0, posZ));
            Vector3 spawnPos = new Vector3(posX, posY, posZ) + terrain.transform.position;

            Quaternion randomRot = Quaternion.Euler(0, Random.Range(0f, 360f), 0);

            GameObject w = Instantiate(windmillPrefab, spawnPos, randomRot);

            spawnedWindmills.Add(w);
        }
    }
}
