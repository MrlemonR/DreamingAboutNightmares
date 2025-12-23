using System.Collections;
using TMPro;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;


public class DoorOpening : MonoBehaviour
{
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
        StartCoroutine(TextActive(false, 0f));
    }
    void OnTriggerEnter(Collider other)
    {
        if (OpenOnce && openTime > 0) return;
        StartCoroutine(TextActive(true, 0.5f));
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
                StartCoroutine(TextActive(false, 0.1f));
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
            StartCoroutine(TextActive(false, 0.5f));
            if (isOpened)
            {
                if (DoorZ) DoorAnim.Play("DoorCloseZ");
                else DoorAnim.Play("DoorClosingAnimation");
                isOpened = false;
            }
        }
    }
    IEnumerator TextActive(bool active, float duration)
    {
        TMP_Text text = PressF.GetComponent<TMP_Text>();
        float startAlpha = text.color.a;
        float target = active ? 1f : 0f;

        float elapsed = 0f;

        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, target, elapsed / duration);
            text.color = new Color(text.color.r, text.color.g, text.color.b, alpha);
            yield return null;
        }

        text.color = new Color(text.color.r, text.color.g, text.color.b, target);
    }
}
