using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine.Rendering.Universal;

public class EyeSpawner : MonoBehaviour
{
    public GameObject eyePrefab;
    public Transform playerCamera;
    public AudioSource WisperSound;
    public AudioSource RiserSound;
    public PlayerController pc;
    public ParticleSystem fallingEffect;
    public List<GameObject> activeEyes = new List<GameObject>();
    public float spawnRadius = 7f;
    public int minEyes = 10;
    public int maxEyes = 25;

    //public AudioClip spawnSoundClip;

    public IEnumerator SpawnEyes(float duration = 6f)
    {
        int count = Random.Range(minEyes, maxEyes);
        pc.StartShake(0.05f);
        WisperSound.Play();
        RiserSound.Play();
        for (int i = 0; i < count; i++)
        {
            SpawnOneEye();
            yield return new WaitForSeconds(Random.Range(0.1f, 0.25f));
        }
    }
    public void CheckIfFinished()
    {
        if (activeEyes.Count < 1)
        {
            pc.StopShake();
            SceneManager.LoadScene("TheHub");
        }
    }
    void SpawnOneEye()
    {
        Vector3 dir = Random.onUnitSphere;
        dir.y = Mathf.Abs(dir.y);
        Vector3 pos = playerCamera.position + dir * spawnRadius;
        GameObject eye = Instantiate(eyePrefab, pos, Quaternion.identity);
        activeEyes.Add(eye);
        float s = Random.Range(0.2f, 0.8f);
        eye.transform.localScale = new Vector3(s, s, s);
        var beh = eye.GetComponent<EyeBehaviour>();
        beh.player = playerCamera.gameObject;
        beh.eyeRenderer = eye.GetComponentInChildren<Renderer>();
        beh.eyeRoot = eye.transform;
        beh.spawner = this;
        //beh.spawnSound = eye.GetComponent<AudioSource>();
    }
    public void StartFallingEffect()
    {
        fallingEffect.Play();
    }

    public void StopFallingEffect()
    {
        fallingEffect.Stop();
    }
}
