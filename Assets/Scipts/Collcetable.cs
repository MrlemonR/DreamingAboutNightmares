using UnityEngine;

public class Collectable : MonoBehaviour
{
    public PressFScript PressF;
    public bool isCollected;
    private Camera cam;
    void Start()
    {
        cam = Camera.main;
        StartCoroutine(PressF.TextActive(false, 0f));
    }
    void Update()
    {
        float distance = Vector3.Distance(cam.transform.position, transform.position);
        if (distance < 4f)
        {
            if (!PressF.courtineStart && !isCollected) StartCoroutine(PressF.TextActive(true, 0.5f));
            if (Input.GetKey(KeyCode.F))
            {
                gameObject.GetComponent<MeshRenderer>().enabled = false;
                StartCoroutine(PressF.TextActive(false, 0.5f));
                isCollected = true;
            }
        }
        else
        {
            if (!PressF.courtineStart && isCollected) StartCoroutine(PressF.TextActive(false, 0.5f));
        }
    }
}