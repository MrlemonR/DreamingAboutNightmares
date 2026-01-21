using System.Collections;
using TMPro;
using UnityEngine;

public class CloudMan : MonoBehaviour
{
    public GameObject Player;
    public TMP_Text talkText;
    void Start()
    {
        FindReferences();
    }
    void Update()
    {
        StartCoroutine(BullShit());
    }
    IEnumerator BullShit()
    {
        float distance = Vector3.Distance(Camera.main.transform.position, transform.position);
        if (distance < 20f)
        {
            Player.GetComponent<CharacterController>().stepOffset = 0.3f;
        }
        else
        {
            Player.GetComponent<CharacterController>().stepOffset = 1f;
        }
        Interact ınteract = Player.GetComponent<Interact>();
        if (ınteract.canInteract && ınteract.hitObjName == gameObject.name && Input.GetKeyDown(KeyCode.F))
        {
            talkText.text = "Yiğitle Tornoooooo!==!";
            StartCoroutine(TalkTextFade(true));
            yield return new WaitForSeconds(2f);
            StartCoroutine(TalkTextFade(false));
        }
    }
    IEnumerator TalkTextFade(bool isActive)
    {
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
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
}