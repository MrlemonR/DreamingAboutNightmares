using System.Collections;
using System.Xml.Serialization;
using TMPro;
using Unity.Mathematics;
using UnityEngine;

public class Revolver : MonoBehaviour
{
    public PlayerController playerCon;
    public Transform PickUpPos;
    public GameObject PressFText;
    public GameObject CharacterMesh;
    bool isVisible = false;
    public bool canpickup = true;
    public Vector3 aimSelfEuler;
    Coroutine fadeRoutine;
    Quaternion smoothAimRot;
    public float aimSensitivity = 3f;
    public float aimHorizontalLimit = 5f;
    public float aimVerticalLimit = 3f;
    public GameObject[] RevoParts;
    Vector2 aimOffset;


    void Start()
    {
        StartCoroutine(TextActive(false, 0.1f));
        CharacterMesh.SetActive(false);
    }
    public bool selfAimMode = false;
    void Update()
    {
        if (canpickup) PickUp();

        if (Input.GetKeyDown(KeyCode.Q) && !canpickup)
        {
            if (!selfAimMode)
            {
                selfAimMode = true;
                StartCoroutine(Aim());
                CharacterMesh.SetActive(true);
                RevoOpenCloseVis(true);
            }
            else
            {
                selfAimMode = false;
                StartCoroutine(Aim());
                CharacterMesh.SetActive(false);
                RevoOpenCloseVis(false);
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
            playerCon.canMove = false;
            Cursor.lockState = CursorLockMode.None;
            playerCon.WalkingSound.Stop();
            playerCon.RunningSound.Stop();


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
            playerCon.canMove = true;
            Cursor.lockState = CursorLockMode.Locked;
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
                RevoOpenCloseVis(false);
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
    public void RevoOpenCloseVis(bool active)
    {
        for (int i = 0; i < RevoParts.Length; i++)
        {
            if (active) RevoParts[i].SetActive(true);
            if (!active) RevoParts[i].SetActive(false);
        }
    }
}
