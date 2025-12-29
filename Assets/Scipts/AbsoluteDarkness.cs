using System.Collections;
using UnityEngine;

public class AbsoluteDarkness : MonoBehaviour
{
    public Light GlobalLight;
    public AudioSource WindSound;
    public GameObject Player;
    public GameObject GlichVideo;
    public Material DarkSkybox;
    public EyeSpawner eyespawner;
    public float skyFadeDuration = 2f;
    private Material originalSkybox;

    void Start()
    {
        originalSkybox = new Material(RenderSettings.skybox);
        eyespawner.StopFallingEffect();
        GlichVideo.SetActive(false);
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            eyespawner.StartFallingEffect();
            Player.GetComponent<PlayerController>().canHearSound = false;
            StartCoroutine(ChangeFov());
            StartCoroutine(trigger());
            StartCoroutine(DarkenWorld());
            StartCoroutine(SmoothSkyboxChange());
            DestroyWindmills();
        }
    }

    IEnumerator trigger()
    {
        StartCoroutine(CloseWindSound());
        yield return new WaitForSeconds(skyFadeDuration);
        Vector3 pos = new Vector3(-364.600006f, 1, 552.034119f);
        Player.GetComponent<PlayerController>().canMove = false;
        yield return new WaitForSeconds(0.1f);
        Player.transform.position = pos;
        GlichVideo.SetActive(true);
        StartCoroutine(eyespawner.SpawnEyes());
    }

    IEnumerator ChangeFov()
    {
        yield return new WaitForSeconds(1f);

        float startFov = Camera.main.fieldOfView;

        while (Camera.main.fieldOfView > 25)
        {
            Camera.main.fieldOfView -= startFov * Time.deltaTime / 2f;
            yield return null;
        }

        Camera.main.fieldOfView = 25f;
    }
    IEnumerator CloseWindSound()
    {
        float startVolume = WindSound.volume;

        while (WindSound.volume > 0)
        {
            WindSound.volume -= startVolume * Time.deltaTime / skyFadeDuration;
            yield return null;
        }

        WindSound.volume = 0;
        WindSound.Stop();
    }

    public IEnumerator DarkenWorld()
    {
        float duration = 1f;
        float startIntensity = GlobalLight.intensity;

        for (float t = 0; t < duration; t += Time.deltaTime)
        {
            GlobalLight.intensity = Mathf.Lerp(startIntensity, 0f, t / duration);
            yield return null;
        }
        GlobalLight.intensity = 0f;
    }

    IEnumerator SmoothSkyboxChange()
    {
        Material tempSky = new Material(RenderSettings.skybox);
        float elapsed = 0f;
        while (elapsed < skyFadeDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / skyFadeDuration;

            tempSky.SetColor("_Tint", Color.Lerp(originalSkybox.GetColor("_Tint"), DarkSkybox.GetColor("_Tint"), t));
            tempSky.SetFloat("_Exposure", Mathf.Lerp(originalSkybox.GetFloat("_Exposure"), DarkSkybox.GetFloat("_Exposure"), t));

            RenderSettings.skybox = tempSky;
            DynamicGI.UpdateEnvironment();
            yield return null;
        }
        RenderSettings.skybox = DarkSkybox;
        DynamicGI.UpdateEnvironment();
    }

    void DestroyWindmills()
    {
        foreach (GameObject w in WindmillSpawner.spawnedWindmills)
        {
            if (w != null) Destroy(w);
        }
        WindmillSpawner.spawnedWindmills.Clear();
    }
}