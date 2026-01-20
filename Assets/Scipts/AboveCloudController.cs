using UnityEngine;
using System.Collections;

public class AboveCloudController : MonoBehaviour
{
    private GameObject Player;
    private Transform sphereCenter;
    public RenderTexture RendererTexture;
    public GameObject LightHouse;
    public GameObject CloudMan;
    void Start()
    {
        StartCoroutine(StartShi());
    }
    IEnumerator StartShi()
    {
        FindReferences();
        Player.transform.position = new Vector3(200f, 100f, -105f);
        yield return new WaitForSeconds(0.01f);
        Camera.main.targetTexture = RendererTexture;
        PlayerController player = Player.GetComponent<PlayerController>();
        player.canMove = true;
        player.canLook = true;
        player.canHearSound = true;
        player.canUseRevolver = true;
        player.GetComponent<CharacterController>().stepOffset = 1;

        if (sphereCenter == null)
        {
            sphereCenter = transform;
        }
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            StartCoroutine(TeleportToOppositeSide(other.transform));
        }
    }
    private bool isSpawned = false;
    IEnumerator TeleportToOppositeSide(Transform target)
    {
        PlayerController player = Player.GetComponent<PlayerController>();
        player.canMove = false;
        float originalY = target.position.y;
        yield return new WaitForSeconds(0.01f);
        Vector3 directionFromCenter = target.position - sphereCenter.position;
        Vector3 oppositePoint = sphereCenter.position - directionFromCenter;
        oppositePoint.y = originalY;
        target.position = oppositePoint;
        yield return new WaitForSeconds(0.01f);
        player.canMove = true;

        if (!isSpawned)
        {
            LightHouse.SetActive(true);
            CloudMan.SetActive(true);
            isSpawned = true;
        }
    }
}
