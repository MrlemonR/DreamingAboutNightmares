using UnityEngine;
using System.Collections;
using TMPro;

public class PressFScript : MonoBehaviour
{
    public Camera cam;
    void LateUpdate()
    {
        if (cam == null) cam = Camera.main;
        Vector3 dir = transform.position - cam.transform.position;
        dir.y = 0;
        transform.rotation = Quaternion.LookRotation(dir);
    }
    public bool courtineStart = false;
    public IEnumerator TextActive(bool active, float duration)
    {
        courtineStart = true;
        TMP_Text text = this.gameObject.GetComponent<TMP_Text>();
        float startAlpha = text.color.a;
        float endAlpha = active ? 1f : 0f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, t / duration);
            text.color = new Color(text.color.r, text.color.g, text.color.b, alpha);
            yield return null;
        }
        text.color = new Color(text.color.r, text.color.g, text.color.b, endAlpha);
        courtineStart = false;
    }
}
