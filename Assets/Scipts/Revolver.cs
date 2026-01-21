using System.Collections;
using System.Xml.Serialization;
using TMPro;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;

public class Revolver : MonoBehaviour
{
    public PlayerController playerCon;
    public Transform PickUpPos;
    public GameObject CharacterMesh;
    bool isVisible = false;
    public bool canpickup = true;
    public Vector3 aimSelfEuler;
    Quaternion smoothAimRot;
    public float aimSensitivity = 3f;
    public float aimHorizontalLimit = 5f;
    public float aimVerticalLimit = 3f;
    public GameObject[] RevoParts;
    Vector2 aimOffset;


    void Start()
    {
        CharacterMesh.SetActive(false);
    }
    public bool selfAimMode = false;
    void Update()
    {
        if (canpickup) PickUp();

        if (Input.GetKeyDown(KeyCode.Q) && !canpickup && playerCon.canUseRevolver)
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
    public IEnumerator Aim()
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
        Interact ınteract = playerCon.gameObject.GetComponent<Interact>();

        if (ınteract.canInteract && ınteract.hitObjName == "GunStand")
        {
            if (Input.GetKeyDown(KeyCode.F))
            {
                transform.SetParent(PickUpPos);
                transform.localPosition = PickUpPos.localPosition;
                transform.rotation = PickUpPos.rotation;
                RevoOpenCloseVis(false);
            }
        }

        if (ınteract.canInteract && ınteract.hitObjName == "GunStand")
        {
            if (!isVisible)
            {
                isVisible = true;
            }

            if (Input.GetKeyDown(KeyCode.F))
            {
                canpickup = false;
                isVisible = false;
            }
        }
        else
        {
            if (isVisible)
            {
                isVisible = false;
            }
        }
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
