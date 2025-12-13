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
    void Update()
    {
        if (revolver.GetComponent<Revolver>().selfAimMode == false) return;
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
                StartCoroutine(RevolverLookAt());
                if (!textcourtinestart) StartCoroutine(TextActive(1f));
            }
        }
    }
    IEnumerator RevolverLookAt()
    {
        Quaternion startRot = cam.transform.localRotation;
        Quaternion endRot = RevolverLook.localRotation;

        float duration = 0.5f;
        float t = 0f;

        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = Mathf.Clamp01(t / duration);
            revolver.transform.localRotation = Quaternion.Slerp(startRot, endRot, frac);
            yield return null;
        }
    }
    IEnumerator TextActive(float targetAlpha)
    {
        float startAlpha = Text.color.a;
        float elapsed = 0f;

        while (elapsed < 1f)
        {
            elapsed += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, targetAlpha, elapsed / 1f);
            Text.color = new Color(Text.color.r, Text.color.g, Text.color.b, alpha);
            yield return null;
        }

        Text.color = new Color(Text.color.r, Text.color.g, Text.color.b, targetAlpha);
    }
    void OnDrawGizmos()
    {
        Vector3 MousePos = Input.mousePosition;
        MousePos.z = 10f;
        MousePos = Camera.main.ScreenToWorldPoint(MousePos);
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(Input.mousePosition, 0.1f);
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(Camera.main.transform.position, MousePos);
    }
}