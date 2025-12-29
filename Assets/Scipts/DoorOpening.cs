using System.Collections;
using TMPro;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;


public class DoorOpening : MonoBehaviour
{
    PressFScript Pressf;
    public Animator DoorAnim;
    public GameObject PressF;
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
        Pressf = PressF.GetComponent<PressFScript>();
        StartCoroutine(Pressf.TextActive(false, 0f));
    }
    void OnTriggerEnter(Collider other)
    {
        if (OpenOnce && openTime > 0) return;
        StartCoroutine(Pressf.TextActive(true, 0.5f));
    }
    void OnTriggerStay(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            if (OpenOnce && openTime > 0) return;
            if (isOpened == false && Input.GetKey(KeyCode.F))
            {
                if (DoorZ) DoorAnim.Play("DoorOpenZ");
                else DoorAnim.Play("DoorOpeningAnimation");
                StopAllCoroutines();
                StartCoroutine(Pressf.TextActive(false, 0.1f));
                loadRoom.SetActive(true);
                other.GetComponent<PlayerData>().RoomNumber = RoomNumber;
                for (int i = 0; i < OtherRooms.Length; i++)
                {
                    OtherRooms[i].SetActive(false);
                }
                isOpened = true;
                openTime++;
            }
        }
    }
    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            StartCoroutine(Pressf.TextActive(false, 0.5f));
            if (isOpened)
            {
                if (DoorZ) DoorAnim.Play("DoorCloseZ");
                else DoorAnim.Play("DoorClosingAnimation");
                isOpened = false;
            }
        }
    }
}