using UnityEngine;

public class Collectable : MonoBehaviour
{
    public Interact ınteract;
    public bool isCollected;
    void Update()
    {

        if (ınteract.canInteract && ınteract.hitObjName == gameObject.name && Input.GetKey(KeyCode.F))
        {
            gameObject.GetComponent<MeshRenderer>().enabled = false;
            isCollected = true;
        }
    }
}