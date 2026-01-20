using UnityEngine;

public class CloudMan : MonoBehaviour
{   
    public GameObject Player;
    void Start()
    {
        FindReferences();
    }
    void Update()
    {
        float distance = Vector3.Distance(Camera.main.transform.position, transform.position);
        if (distance < 30f)
        {
            Player.GetComponent<CharacterController>().stepOffset = 0.3f;
        }
        else
        {
            Player.GetComponent<CharacterController>().stepOffset = 1f;
        }
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
}