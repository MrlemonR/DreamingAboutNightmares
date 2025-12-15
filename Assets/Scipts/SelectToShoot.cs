using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;
using TMPro;
using Unity.VisualScripting;
public class SelectToShoot : MonoBehaviour
{
    public Camera cam;
    public GameObject revolver;
    public Transform[] LookPositions; //1: Head, 2: Hands, 3: Legs
    public Transform[] MovePositions; //1: Head, 2: Hands, 3: Legs
    public TMP_Text[] Texts; //1: Head, 2: Hands, 3: Legs

    bool textcourtinestart = false;
    void Start()
    {
        StartCoroutine(TextActive(0f, 0f));
    }
    void Update()
    {
        if (revolver.GetComponent<Revolver>().selfAimMode)
        {
            if (!textcourtinestart) StartCoroutine(TextActive(1f, 0.3f));
            mouseHover();
            RevolverShakeByTarget();
        }
        else
        {
            if (!textcourtinestart) StartCoroutine(TextActive(0f, 0.3f));
        }
    }
    void mouseHover()
    {
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        AimTarget newTarget = AimTarget.None;
        if (Physics.Raycast(ray, out hit, 10f))
        {
            switch (hit.collider.gameObject.name)
            {
                case "Headcollider":
                    newTarget = AimTarget.Head;
                    break;
                case "ArmCollider":
                    newTarget = AimTarget.Arm;
                    break;
                case "LegCollider":
                    newTarget = AimTarget.Leg;
                    break;
            }
        }
        if (newTarget != currentTarget)
        {
            currentTarget = newTarget;
            if (currentTarget != AimTarget.None)
            {
                int index = TargetToIndex(currentTarget);
                StartCoroutine(RevolverLookAt(index));
                StartCoroutine(RevolverMoveTo(index));
                StartCoroutine(TextColorChange(index));
            }
        }
    }
    int TargetToIndex(AimTarget target)
    {
        switch (target)
        {
            case AimTarget.Head: return 0;
            case AimTarget.Arm: return 1;
            case AimTarget.Leg: return 2;
            default: return 0;
        }
    }


    IEnumerator RevolverLookAt(int index)
    {
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
    }

    IEnumerator RevolverMoveTo(int index)
    {
        Vector3 startPos = revolver.transform.localPosition;
        Vector3 endPos = MovePositions[index].localPosition;
        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime; float frac = t / duration; revolver.transform.localPosition = Vector3.Slerp(startPos, endPos, frac);
            yield return null;
        }
        revolver.transform.localPosition = endPos;
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
    }
    void RevolverShake(float ShakeAmout)
    {
        revolver.transform.localPosition += new Vector3(Random.Range(-ShakeAmout, ShakeAmout), 0, Random.Range(-ShakeAmout, ShakeAmout));
    }
    public enum AimTarget
    {
        None, Head, Arm, Leg
    }
    AimTarget currentTarget = AimTarget.None;
    void RevolverShakeByTarget()
    {
        switch (currentTarget)
        {
            case AimTarget.Head:
                RevolverShake(0.002f);
                break;
            case AimTarget.Arm:
                RevolverShake(0.001f);
                break;
            case AimTarget.Leg:
                RevolverShake(0.001f);
                break;
        }
    }
}