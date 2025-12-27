using UnityEngine;
using TMPro;
using System.Collections;
using UnityEngine.UI;

public class GotoSleep : MonoBehaviour
{
    public bool IsInRoomn = false;
    public GameObject Player;
    public TMP_Text text;
    void Update()
    {
        if (!IsInRoomn) return;
        float distance = Vector3.Distance(Player.transform.position, this.transform.position);
        Vector3 Look = (this.transform.position - Camera.main.transform.position).normalized;
        float dir = Vector3.Dot(Camera.main.transform.forward, Look);
        if (dir < 0.4f && distance < 2f)
        {
            StartCoroutine(TextOpenClose(true));
        }
        else
        {
            StartCoroutine(TextOpenClose(false));
        }
    }
    IEnumerator TextOpenClose(bool isActive)
    {
        float startAlpha = text.color.a;
        float endAlpha = isActive ? 1f : 0f;
        float t = 0f;
        while (t < 0.5f)
        {
            t += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, t / 1f);
            text.color = new Color(text.color.r, text.color.g, text.color.b, alpha);
            yield return null;
        }
        text.color = new Color(text.color.r, text.color.g, text.color.b, endAlpha);
    }
}