using System.Collections;
using TMPro;
using UnityEngine;

public class Talking : MonoBehaviour
{
    public GameObject AssingText;
    public string[] texts;
    public float[] times;
    public float fadeDuration = 1f;

    private TMP_Text tmpText;

    void Start()
    {
        tmpText = AssingText.GetComponent<TMP_Text>();
        if(tmpText == null)
        {
            Debug.LogError("AssingText üzerinde TMP_Text bulunamadı!");
            return;
        }

        tmpText.color = new Color(tmpText.color.r, tmpText.color.g, tmpText.color.b, 0);
        StartCoroutine(TextCoroutine());
    }

    IEnumerator TextCoroutine()
    {
        yield return new WaitForSeconds(1f);

        for (int i = 0; i < texts.Length; i++)
        {
            yield return StartCoroutine(FadeText(0));
            tmpText.text = texts[i];
            yield return StartCoroutine(FadeText(1));
            yield return new WaitForSeconds(times[i]);
        }
    }

    IEnumerator FadeText(float targetAlpha)
    {
        float startAlpha = tmpText.color.a;
        float elapsed = 0f;

        while (elapsed < fadeDuration)
        {
            elapsed += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, targetAlpha, elapsed / fadeDuration);
            tmpText.color = new Color(tmpText.color.r, tmpText.color.g, tmpText.color.b, alpha);
            yield return null;
        }

        tmpText.color = new Color(tmpText.color.r, tmpText.color.g, tmpText.color.b, targetAlpha);
    }
}
