using System.Collections;
using Unity.VisualScripting;
using UnityEngine;

public class FallingEnd : MonoBehaviour
{
    public GameObject Player;
    public GameObject Trigger;
    public ParticleSystem particle;
    public AudioSource FallSound;
    public RenderTexture RenderTexture;
    void Start()
    {
        Camera.main.targetTexture = RenderTexture;
        SaveOnReload data = SaveSystem.LoadPlayer();
        if (data != null)
        {
            Debug.Log("Loaded Scene: " + data.SceneName);

            if (data.SceneName == "TheHub")
            {
                if (particle != null)
                {
                    particle.Stop();
                }
            }
        }
        else
        {
            StartCoroutine(WaitUntillFall());
        }
    }
    void Update()
    {
        if (Player == null) FindReferences();
    }
    private IEnumerator WaitUntillFall()
    {
        Player.GetComponent<PlayerController>().canHearSound = false;
        yield return new WaitForSeconds(2f);
        Player.GetComponent<PlayerController>().canMove = false;
        Player.GetComponent<PlayerController>().canLook = false;
        yield return new WaitForSeconds(0.1f);
        Player.transform.position = new Vector3(-126.293503f, 100f, 26.5699005f);
        Player.GetComponent<PlayerController>().SetRotation(170f);
        StartCoroutine(ChangeFog());
        yield return new WaitForSeconds(0.1f);
        Player.GetComponent<PlayerController>().canLook = true;
        Player.GetComponent<PlayerController>().canMove = true;
    }
    IEnumerator ChangeFog()
    {
        float start = RenderSettings.fogDensity;
        float t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime;
            RenderSettings.fogDensity = Mathf.Lerp(start, 0.009f, t / 1);
            yield return null;
        }
        RenderSettings.fogDensity = 0.009f;
    }
    private IEnumerator FallSoundStart()
    {
        FallSound.Play();
        yield return new WaitForSeconds(0.2f);
        Player.GetOrAddComponent<PlayerController>().canHearSound = true;
        particle.Stop();
        Trigger.SetActive(false);
    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            StartCoroutine(FallSoundStart());
            Camera.main.farClipPlane = 300f;
        }
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
        particle = ParticleSystem.FindAnyObjectByType<ParticleSystem>();
    }
}