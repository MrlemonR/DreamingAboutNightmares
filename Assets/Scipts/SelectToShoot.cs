using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;
using TMPro;
public class SelectToShoot : MonoBehaviour
{
    public Camera cam;
    public GameObject revolver;
    public Transform[] LookPositions; //1: Head, 2: Hands, 3: Legs
    public Transform[] MovePositions; //1: Head, 2: Hands, 3: Legs
    public TMP_Text[] Texts; //1: Head, 2: Hands, 3: Legs

    bool textcourtinestart = false;
    bool textColorcourtine = false;
    bool RevoRotCourtine = false;
    bool RevoMoveCourtine = false;
    void Start()
    {
        StartCoroutine(TextActive(0f, 0f));
    }
    void Update()
    {
        if (revolver.GetComponent<Revolver>().selfAimMode == true)
        {
            if (!textcourtinestart) StartCoroutine(TextActive(1f, 0.3f));
            mouseHover();
            RevolverShake(0.007f);
        }
        else
        {
            if (!textcourtinestart) StartCoroutine(TextActive(0f, 0.3f));
        }
    }
    void mouseHover()
    {
        Vector3 MousePos = Input.mousePosition;
        MousePos.z = 10f;
        MousePos = cam.ScreenToWorldPoint(MousePos);
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 10f))
        {
            Debug.Log("Hit: " + hit.collider.gameObject.name);
            switch (hit.collider.gameObject.name)
            {
                case "Headcollider":
                    if (!RevoRotCourtine) StartCoroutine(RevolverLookAt(0));
                    if (!RevoMoveCourtine) StartCoroutine(RevolverMoveTo(0));
                    if (!textColorcourtine) StartCoroutine(TextColorChange(0));
                    RevoRotCourtine = true;
                    RevoMoveCourtine = true;
                    break;
                case "ArmCollider":
                    if (!RevoRotCourtine) StartCoroutine(RevolverLookAt(1));
                    if (!RevoMoveCourtine) StartCoroutine(RevolverMoveTo(1));
                    if (!textColorcourtine) StartCoroutine(TextColorChange(1));
                    RevoRotCourtine = true;
                    RevoMoveCourtine = true;
                    break;
                case "LegCollider":
                    if (!RevoRotCourtine) StartCoroutine(RevolverLookAt(2));
                    if (!RevoMoveCourtine) StartCoroutine(RevolverMoveTo(2));
                    if (!textColorcourtine) StartCoroutine(TextColorChange(2));
                    RevoRotCourtine = true;
                    RevoMoveCourtine = true;
                    break;
            }
        }
    }
    IEnumerator RevolverLookAt(int index)
    {
        RevoRotCourtine = true;
        Quaternion startRot = revolver.transform.localRotation;
        Quaternion endRot = LookPositions[index].localRotation;
        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            revolver.transform.localRotation = Quaternion.Slerp(startRot, endRot, frac);
            yield return null;
        }
        revolver.transform.localRotation = endRot;
        RevoRotCourtine = false;
    }


    IEnumerator RevolverMoveTo(int index)
    {
        RevoMoveCourtine = true;
        Vector3 startPos = revolver.transform.localPosition;
        Vector3 endPos = MovePositions[index].localPosition;
        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            revolver.transform.localPosition = Vector3.Slerp(startPos, endPos, frac);
            yield return null;
        }
        revolver.transform.localPosition = endPos;
        RevoMoveCourtine = false;
    }

    IEnumerator TextActive(float targetAlpha, float targetSpeed)
    {
        textcourtinestart = true;
        float elapsed = 0f;
        float[] startAlphas = new float[Texts.Length];
        for (int i = 0; i < Texts.Length; i++)
        {
            startAlphas[i] = Texts[i].color.a;
        }
        while (elapsed < targetSpeed)
        {
            elapsed += Time.deltaTime;
            float frac = elapsed / targetSpeed;

            for (int i = 0; i < Texts.Length; i++)
            {
                float alpha = Mathf.Lerp(startAlphas[i], targetAlpha, frac);
                Texts[i].color = new Color(Texts[i].color.r, Texts[i].color.g, Texts[i].color.b, alpha);
            }
            yield return null;
        }
        for (int i = 0; i < Texts.Length; i++)
        {
            Texts[i].color = new Color(Texts[i].color.r, Texts[i].color.g, Texts[i].color.b, targetAlpha);
        }
        textcourtinestart = false;
    }
    IEnumerator TextColorChange(int selectedText)
    {
        textColorcourtine = true;
        float elapsed = 0f;
        Color[] startColors = new Color[Texts.Length];
        for (int i = 0; i < Texts.Length; i++)
        {
            startColors[i] = Texts[i].color;
        }
        while (elapsed < 0.3f)
        {
            elapsed += Time.deltaTime;
            float frac = elapsed / 0.3f;

            for (int i = 0; i < Texts.Length; i++)
            {
                Color targetColor = (i == selectedText) ? Color.red : Color.white;
                Texts[i].color = Color.Lerp(startColors[i], targetColor, frac);
            }
            yield return null;
        }
        for (int i = 0; i < Texts.Length; i++)
        {
            Texts[i].color = (i == selectedText) ? Color.red : Color.white;
        }
        textColorcourtine = false;
    }
    void RevolverShake(float ShakeAmout)
    {
        revolver.transform.localPosition += new Vector3(Random.Range(-ShakeAmout, ShakeAmout), 0, Random.Range(-ShakeAmout, ShakeAmout));
    }
}