using System.Collections;
using TMPro;
using Unity.Mathematics;
using UnityEngine;

public class Revolver : MonoBehaviour
{
    public PlayerController playerCon;
    public Transform PickUpPos;
    public GameObject PressFText;
    bool isVisible = false;
    bool canpickup = true;
    public Vector3 aimSelfEuler;
    Coroutine fadeRoutine;
    Quaternion smoothAimRot;
    public float aimSensitivity = 3f;
    public float aimHorizontalLimit = 5f;
    public float aimVerticalLimit = 3f;
    Vector2 aimOffset;


    void Start()
    {
        StartCoroutine(TextActive(false, 0.1f));
        StartCoroutine(BodyParts(false, 0f));
    }
    bool selfAimMode = false;
    void Update()
    {
        if (canpickup) PickUp();

        if (Input.GetKeyDown(KeyCode.Q) && !canpickup)
        {
            if (!selfAimMode)
            {
                selfAimMode = true;
                StartCoroutine(Aim());
            }
            else
            {
                selfAimMode = false;
                StartCoroutine(Aim());
            }
        }

        if (selfAimMode)
        {
            float mx = Input.GetAxis("Mouse X");
            float my = Input.GetAxis("Mouse Y");
            aimOffset.x += mx;
            aimOffset.y -= my;
            aimOffset.x = Mathf.Clamp(aimOffset.x, -aimHorizontalLimit, aimHorizontalLimit);
            aimOffset.y = Mathf.Clamp(aimOffset.y, -aimVerticalLimit, aimVerticalLimit);
            Quaternion targetRot = selfAimPose.rotation * Quaternion.Euler(aimOffset.y, aimOffset.x, 0);
            smoothAimRot = Quaternion.Slerp(smoothAimRot, targetRot, Time.deltaTime * 8f);
            Camera.main.transform.rotation = smoothAimRot;
        }


        if (selfAimMode) BdpartsTextFollow();
    }

    public Transform selfAimPose;
    IEnumerator Aim()
    {
        Camera cam = Camera.main;
        Quaternion startRot = cam.transform.localRotation;
        Quaternion endRot = selfAimPose.localRotation;

        if (selfAimMode)
        {
            playerCon.canLook = false;
            Cursor.lockState = CursorLockMode.None;
            StartCoroutine(BodyParts(true, 0.1f));


            float duration = 0.5f;
            float t = 0f;
            while (t < duration)
            {
                t += Time.deltaTime;
                float frac = Mathf.Clamp01(t / duration);
                cam.transform.localRotation = Quaternion.Slerp(startRot, endRot, frac);
                yield return null;
            }

            cam.transform.localRotation = endRot;
        }
        else
        {
            playerCon.canLook = true;
            Cursor.lockState = CursorLockMode.Locked;
            StartCoroutine(BodyParts(false, 0.1f));
        }

    }
    public TMP_Text[] BdParts;
    public Vector3 testPos;
    IEnumerator BodyParts(bool on, float duration)
    {
        for (int i = 0; i < BdParts.Length; i++)
        {
            float startAlpha = BdParts[i].color.a;
            float target = on ? 1f : 0f;
            float elapsed = 0f;
            while (elapsed < duration)
            {
                elapsed += Time.deltaTime;
                float alpha = Mathf.Lerp(startAlpha, target, elapsed / duration);
                BdParts[i].color = new Color(BdParts[i].color.r, BdParts[i].color.g, BdParts[i].color.b, alpha);
                yield return null;
            }
            BdParts[i].color = new Color(BdParts[i].color.r, BdParts[i].color.g, BdParts[i].color.b, target);
        }

    }
    void BdpartsTextFollow()
    {
        for (int i = 0; i < BdParts.Length; i++)
        {
            BdParts[i].transform.forward = selfAimPose.forward;
        }
    }

    void PickUp()
    {
        float distance = Vector3.Distance(Camera.main.transform.position, transform.position);
        Vector3 dir = (transform.position - Camera.main.transform.position).normalized;
        float dot = Vector3.Dot(Camera.main.transform.forward, dir);
        if (dot > 0.4f && distance < 2f)
        {
            if (Input.GetKeyDown(KeyCode.F))
            {
                transform.SetParent(PickUpPos);
                transform.localPosition = PickUpPos.localPosition;
                transform.rotation = PickUpPos.rotation;
            }
        }
        if (dot > 0.4f && distance < 2f)
        {
            if (!isVisible)
            {
                isVisible = true;
                if (fadeRoutine != null) StopCoroutine(fadeRoutine);
                fadeRoutine = StartCoroutine(TextActive(true, 0.5f));
            }

            if (Input.GetKeyDown(KeyCode.F))
            {
                canpickup = false;
                isVisible = false;
                if (fadeRoutine != null) StopCoroutine(fadeRoutine);
                fadeRoutine = StartCoroutine(TextActive(false, 0.1f));
            }
        }
        else
        {
            if (isVisible)
            {
                isVisible = false;
                if (fadeRoutine != null) StopCoroutine(fadeRoutine);
                fadeRoutine = StartCoroutine(TextActive(false, 0.5f));
            }
        }
    }
    IEnumerator TextActive(bool active, float duration)
    {
        TMP_Text text = PressFText.GetComponent<TMP_Text>();
        float startAlpha = text.color.a;
        float target = active ? 1f : 0f;
        float elapsed = 0f;
        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, target, elapsed / duration);
            text.color = new Color(text.color.r, text.color.g, text.color.b, alpha);
            yield return null;
        }
        text.color = new Color(text.color.r, text.color.g, text.color.b, target);
    }
}
