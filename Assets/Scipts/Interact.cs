using UnityEngine;

public class Interact : MonoBehaviour
{
    private Camera cam;
    public bool canInteract = false;
    public string hitObjName;
    public GameObject Dot1;
    public GameObject Dot2;
    void Start()
    {
        cam = Camera.main;
    }
    void Update()
    {
        if (Dot1 == null || Dot2 == null) FindDots();
        Ray ray = new Ray(cam.transform.position, cam.transform.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 3f))
        {
            if (hit.collider.CompareTag("Interact"))
            {
                hitObjName = hit.collider.gameObject.name;
                canInteract = true;
                Dot1.SetActive(false);
                Dot2.SetActive(true);
            }
            else
            {
                canInteract = false;
                Dot1.SetActive(true);
                Dot2.SetActive(false);
            }
        }
        else
        {
            canInteract = false;
            hitObjName = "";
            Dot1.SetActive(true);
            Dot2.SetActive(false);
        }
    }
    void FindDots()
    {
        Dot1 = GameObject.Find("Dot1");
        Dot2 = GameObject.Find("Dot2");
    }
}
