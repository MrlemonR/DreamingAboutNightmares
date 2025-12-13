using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;
using TMPro;
public class HoverOutline : MonoBehaviour
{
    public Camera cam;
    public GameObject revolver;
    public Transform RevolverLook;
    public TMP_Text Text;

    bool textcourtinestart = false;
    bool Revolercourtine= false;
    void Start()
    {
        StartCoroutine(TextActive(0f, 0f));
    }
    void Update()
    {
        if (revolver.GetComponent<Revolver>().selfAimMode == true)
        {
            if (!textcourtinestart) StartCoroutine(TextActive(1f, 0.5f));
            textcourtinestart = true;
        }
        else
        {
            if (!textcourtinestart) StartCoroutine(TextActive(0f, 0.5f));
            textcourtinestart = true;
        }
        Vector3 MousePos = Input.mousePosition;
        MousePos.z = 10f;
        MousePos = cam.ScreenToWorldPoint(MousePos);
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 10f))
        {
            Debug.Log("Hit: " + hit.collider.gameObject.name);
            if (hit.collider.gameObject.name == gameObject.name)
            {
                if(!Revolercourtine) StartCoroutine(RevolverLookAt());
                Revolercourtine = true;
            }
        }
    }
    IEnumerator RevolverLookAt()
    {
        Quaternion startRot = revolver.transform.localRotation;
        Quaternion endRot = RevolverLook.localRotation;

        float duration = 0.5f;
        float t = 0f;

        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = Mathf.Clamp01(t / duration);
            revolver.transform.localRotation = Quaternion.Slerp(startRot, endRot, frac);
            yield return null;
            Revolercourtine = false;
        }
    }
    IEnumerator TextActive(float targetAlpha, float targetSpeed)
    {
        float startAlpha = Text.color.a;
        float elapsed = 0f;

        while (elapsed < targetSpeed)
        {
            elapsed += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, targetAlpha, elapsed / targetSpeed);
            Text.color = new Color(Text.color.r, Text.color.g, Text.color.b, alpha);
            yield return null;
            textcourtinestart = false;
        }

        Text.color = new Color(Text.color.r, Text.color.g, Text.color.b, targetAlpha);
    }
}