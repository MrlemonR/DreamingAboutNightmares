using UnityEngine;


public class DoorOpening : MonoBehaviour
{
    public Animator DoorAnim;
    public GameObject Player;
    private bool isOpened = false;
    public bool DoorZ = false;
    public bool OpenOnce = false;
    private int openTime = 0;
    public GameObject loadRoom;
    public GameObject[] OtherRooms;
    public int RoomNumber;
    void Start()
    {
        FindReferences();
    }
    void Update()
    {
        Interact ınteract = Player.GetComponent<Interact>();
        PlayerData playerData = Player.GetComponent<PlayerData>();

        if (ınteract.canInteract && ınteract.hitObjName == gameObject.name)
        {
            if (OpenOnce && openTime > 0) return;
            if (Input.GetKeyDown(KeyCode.F) && !isOpened)
            {
                if (DoorZ) DoorAnim.Play("DoorOpenZ");
                else DoorAnim.Play("DoorOpeningAnimation");
                loadRoom.SetActive(true);
                playerData.RoomNumber = RoomNumber;
                for (int i = 0; i < OtherRooms.Length; i++)
                {
                    OtherRooms[i].SetActive(false);
                }
                isOpened = true;
                openTime++;

            }
        }

        float distance = Vector3.Distance(transform.position, Player.transform.position);
        if (distance > 4f)
        {
            if (isOpened)
            {
                if (DoorZ) DoorAnim.Play("DoorCloseZ");
                else DoorAnim.Play("DoorClosingAnimation");
                isOpened = false;
            }

        }
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
}