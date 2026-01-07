using UnityEngine;

public class CloudMan : MonoBehaviour
{
    public GameObject PressF;
    public Vector3 pressFPos;
    public int distance1;
    void Update()
    {
        float distance = Vector3.Distance(Camera.main.transform.position, transform.position);
        if (distance < distance1)
        {
            Vector3 dir = transform.position - Camera.main.transform.position;
            dir.y = 0;
            transform.rotation = Quaternion.LookRotation(dir);
            PressF.transform.position = transform.position - pressFPos;
            PressF.GetComponent<PressFScript>().TextActive(true, 0.5f);
        }
        else
        {
            PressF.GetComponent<PressFScript>().TextActive(false, 0.5f);
        }
    }
}
