using UnityEngine;
using TMPro;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using Unity.VisualScripting;

public class GotoSleep : MonoBehaviour
{
    public GameObject Player;
    public GameObject Dormitory;
    public GameObject Pillow;
    public GameObject Duvet;
    public TMP_Text talkText;
    public Image SleepImage;
    public Transform SleepCamLoc;
    private bool GetPillow = false;
    private bool Getduvet = false;
    private Camera cam;
    void Start()
    {
        cam = Camera.main;
    }
    void Update()
    {
        FindReferences();
        StartCoroutine(Sleep());
        if (Input.GetKey(KeyCode.L))
        {
            ParticleSystem fallingparticals = FindAnyObjectByType<ParticleSystem>();
            fallingparticals.Stop();
            SceneManager.LoadScene("AboveClouds");
        }
    }
    IEnumerator Sleep()
    {
        Interact ınteract = Player.GetComponent<Interact>();
        if (ınteract.canInteract && ınteract.hitObjName == gameObject.name && Input.GetKey(KeyCode.F))
        {
            if (Pillow.GetComponent<Collectable>().isCollected) GetPillow = true;
            if (Duvet.GetComponent<Collectable>().isCollected) Getduvet = true;
            if (!GetPillow && !Getduvet)
            {
                if (TalkCourtineStart) StopCoroutine(Sleep());
                talkText.text = "I cant't sleep now, I need pillow and duvet.";
                StartCoroutine(TalkTextFade(true));
                yield return new WaitForSeconds(2f);
                StartCoroutine(TalkTextFade(false));
            }
            else if (!GetPillow && Getduvet)
            {
                if (TalkCourtineStart) StopCoroutine(Sleep());
                talkText.text = "I cant't sleep now, I need pillow.";
                StartCoroutine(TalkTextFade(true));
                yield return new WaitForSeconds(2f);
                StartCoroutine(TalkTextFade(false));
            }
            else if (!Getduvet && GetPillow)
            {
                if (TalkCourtineStart) StopCoroutine(Sleep());
                talkText.text = "I cant't sleep now, I need duvet.";
                StartCoroutine(TalkTextFade(true));
                yield return new WaitForSeconds(2f);
                StartCoroutine(TalkTextFade(false));
            }
            else
            {
                //Going To Sleep
                PlayerController player = Player.GetComponent<PlayerController>();
                player.canUseRevolver = false;
                player.canMove = false;
                player.canLook = false;
                player.canHearSound = false;
                player.WalkingSound.Stop();
                player.RunningSound.Stop();
                StartCoroutine(ChangeCamLoc());
                StartCoroutine(ChangeCamRot());
                StartCoroutine(GoDark());
            }
        }
    }
    IEnumerator GoDark()
    {
        yield return new WaitForSeconds(3f);
        float startAlpha = SleepImage.color.a;
        float endAlpha = 1f;
        float t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, t / 1f);
            SleepImage.color = new Color(SleepImage.color.r, SleepImage.color.g, SleepImage.color.b, alpha);
            yield return null;
        }
        SleepImage.color = new Color(SleepImage.color.r, SleepImage.color.g, SleepImage.color.b, endAlpha);
        yield return new WaitForSeconds(1f);
        SceneManager.LoadScene("AboveClouds");
    }
    IEnumerator ChangeCamLoc()
    {
        Vector3 StartPos = cam.transform.position;
        Vector3 EndPos = SleepCamLoc.position;
        float t = 0f;
        while (t < 2f)
        {
            t += Time.deltaTime;
            float frac = t / 2f;
            cam.transform.position = Vector3.Lerp(StartPos, EndPos, frac);
            yield return null;
        }
        cam.transform.position = EndPos;
    }
    IEnumerator ChangeCamRot()
    {
        Quaternion startRot = cam.transform.rotation;
        Quaternion endRot = SleepCamLoc.rotation;
        float t = 0f;
        while (t < 2f)
        {
            t += Time.deltaTime;
            float frac = t / 2f;
            cam.transform.rotation = Quaternion.Lerp(startRot, endRot, frac);
            yield return null;

        }

        cam.transform.rotation = Quaternion.Lerp(startRot, endRot, t);
        cam.transform.rotation = endRot;
    }
    bool TalkCourtineStart = false;
    IEnumerator TalkTextFade(bool isActive)
    {
        TalkCourtineStart = true;

        float startAlpha = talkText.color.a;
        float endAlpha = isActive ? 1f : 0f;
        float t = 0f;

        while (t < 0.5f)
        {
            t += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, t / 0.5f);
            talkText.color = new Color(talkText.color.r, talkText.color.g, talkText.color.b, alpha);
            yield return null;
        }

        talkText.color = new Color(talkText.color.r, talkText.color.g, talkText.color.b, endAlpha);

        TalkCourtineStart = false;
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
}