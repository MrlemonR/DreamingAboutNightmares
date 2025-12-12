using UnityEngine;

public class PressFScript : MonoBehaviour
{
    public Camera cam;
    void Start()
    {
        if (cam == null) cam = Camera.main;
    }

    void LateUpdate()
    {
        Vector3 dir = transform.position - cam.transform.position;
        dir.y = 0;
        transform.rotation = Quaternion.LookRotation(dir);

    }
}
