using UnityEngine;
using System.Collections;
using Unity.VisualScripting;
using UnityEditor;
public class Reload : MonoBehaviour
{
    public class PlayerLocation
    {
        public Vector3 PlayerPosition;
        public Quaternion PlayerRotation;
    }

    public float reloadAimSensitivity = 2.5f;
    public float reloadHorizontalLimit = 6f;
    public float reloadVerticalLimit = 4f;

    Vector2 reloadAimOffset;
    Quaternion reloadStartRot;
    public PlayerController playerController;
    public GameObject Bullet;
    public Animator CylnderAnimator;
    public Transform ReloadPosition;
    public Transform HeadPosition;
    public MeshRenderer[] BulletLoc;
    void Start()
    {
        CloseBulletts();
    }
    void Update()
    {
        if (!gameObject.GetComponent<Revolver>().selfAimMode && Input.GetMouseButtonDown(1))
        {
            Openreload();
            Cursor.lockState = CursorLockMode.None;
        }   
        if (!gameObject.GetComponent<Revolver>().selfAimMode && Input.GetMouseButton(1))
        {
            HoverToReload();
            ReloadCameraAim();
        }
        if (!gameObject.GetComponent<Revolver>().selfAimMode && Input.GetMouseButtonUp(1))
        {
            CloseReload();
            Cursor.lockState = CursorLockMode.Locked;
            CloseBulletts();
        }
    }
    int ExistBulletPos;
    Vector3 HitPoint;
    void HoverToReload()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 10f))
        {
            HitPoint = hit.point;
            Debug.Log(hit.collider.gameObject.name);
            switch (hit.collider.gameObject.name)
            {
                case "BulletPos1":
                    if (ExistBulletPos == 0) return;
                    CloseBulletts();
                    BulletLoc[0].enabled = true;
                    PlaceBullet(0);
                    break;
                case "BulletPos2":
                    if (ExistBulletPos == 1) return;
                    CloseBulletts();
                    BulletLoc[1].enabled = true;
                    PlaceBullet(1);
                    break;
                case "BulletPos3":
                    if (ExistBulletPos == 2) return;
                    CloseBulletts();
                    BulletLoc[2].enabled = true;
                    PlaceBullet(2);
                    break;
                case "BulletPos4":
                    if (ExistBulletPos == 3) return;
                    CloseBulletts();
                    BulletLoc[3].enabled = true;
                    PlaceBullet(3);
                    break;
                case "BulletPos5":
                    if (ExistBulletPos == 4) return;
                    CloseBulletts();
                    BulletLoc[4].enabled = true;
                    PlaceBullet(4);
                    break;
                case "BulletPos6":
                    if (ExistBulletPos == 5) return;
                    CloseBulletts();
                    BulletLoc[5].enabled = true;
                    PlaceBullet(5);
                    break;
            }
        }
    }
    GameObject currentBullet;
    void PlaceBullet(int position)
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (currentBullet != null)
            {
                Destroy(currentBullet);
            }
            currentBullet = Instantiate(Bullet, BulletLoc[position].transform.position, BulletLoc[position].transform.rotation);
            currentBullet.transform.SetParent(BulletLoc[position].transform);
            ExistBulletPos = position;
        }
    }

    void CloseBulletts()
    {
        for (int i = 0; i < BulletLoc.Length; i++)
        {
            BulletLoc[i].enabled = false;
        }
    }
    void ReloadCameraAim()
    {
        float mx = Input.GetAxis("Mouse X");
        float my = Input.GetAxis("Mouse Y");

        reloadAimOffset.x += mx * reloadAimSensitivity;
        reloadAimOffset.y -= my * reloadAimSensitivity;

        reloadAimOffset.x = Mathf.Clamp(reloadAimOffset.x, -reloadHorizontalLimit, reloadHorizontalLimit);
        reloadAimOffset.y = Mathf.Clamp(reloadAimOffset.y, -reloadVerticalLimit, reloadVerticalLimit);
        Quaternion targetRot = reloadStartRot * Quaternion.Euler(reloadAimOffset.y, reloadAimOffset.x, 0);
        Camera.main.transform.rotation = Quaternion.Slerp(Camera.main.transform.rotation, targetRot, Time.deltaTime * 8f);
    }

    void Openreload()
    {
        StopAllCoroutines();
        RevoChangeParent(true);
        reloadAimOffset = Vector2.zero;
        reloadStartRot = Camera.main.transform.rotation;
        CylnderAnimator.Play("RevolverOpenClynder");
        playerController.canLook = false;
        playerController.canMove = false;
        gameObject.GetComponent<Revolver>().RevoOpenCloseVis(transform);
        StartCoroutine(RevoChangePos());
        StartCoroutine(RevoChangeRot());
        StartCoroutine(ChangeFov(true));
        if (currentBullet != null) currentBullet.SetActive(true);
    }
    void CloseReload()
    {
        StopAllCoroutines();
        RevoChangeParent(false);
        CylnderAnimator.Play("RevolverCloseClynder");
        playerController.canLook = true;
        playerController.canMove = true;
        gameObject.GetComponent<Revolver>().RevoOpenCloseVis(false);
        StartCoroutine(ChangeFov(false));
        if (currentBullet != null) currentBullet.SetActive(false);
    }
    void RevoChangeParent(bool active)
    {
        if (active) transform.SetParent(Camera.main.transform);
        if (!active) transform.SetParent(HeadPosition);
    }

    IEnumerator ChangeFov(bool active)
    {

        float startFov = Camera.main.fieldOfView;
        float endFov = active ? 25f : 60f;

        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            Camera.main.fieldOfView = Mathf.Lerp(startFov, endFov, frac);
            yield return null;
        }
        Camera.main.fieldOfView = endFov;
    }
    IEnumerator RevoChangePos()
    {
        Vector3 StartPos = transform.localPosition;
        Vector3 EndPos = ReloadPosition.localPosition;

        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            transform.localPosition = Vector3.Slerp(StartPos, EndPos, frac);
            yield return null;
        }
        transform.localPosition = EndPos;
    }
    IEnumerator RevoChangeRot()
    {
        Quaternion StartRot = transform.localRotation;
        Quaternion EndRot = ReloadPosition.localRotation;

        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            transform.localRotation = Quaternion.Slerp(StartRot, EndRot, frac);
            yield return null;
        }
    }
    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(HitPoint, 0.1f);

        Gizmos.DrawLine(Camera.main.transform.position, HitPoint);
    }
}
