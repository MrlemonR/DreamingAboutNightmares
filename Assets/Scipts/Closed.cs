using UnityEngine;

public class Closed : MonoBehaviour
{
    public GameObject Player;
    public GameObject Dormitory;
    private Animator animator;
    void Start()
    {
        animator = this.GetComponent<Animator>();
        FindReferences();
    }
    bool isOpen = false;
    void Update()
    {
        if (!Dormitory.activeInHierarchy) return;
        float distance = Vector3.Distance(Player.transform.position, this.transform.position);
        if (distance < 4.5f)
        {
            if (isOpen) return;
            animator.Play("ClosedOpen");
            isOpen = true;
        }
        else
        {
            if (!isOpen) return;
            animator.Play("ClosedClose");
            isOpen = false;
        }
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
}