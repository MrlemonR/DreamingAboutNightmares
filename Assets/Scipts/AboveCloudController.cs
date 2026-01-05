using UnityEngine;
using System.Collections;
using NUnit.Framework;

public class AboveCloudController : MonoBehaviour
{
    private GameObject Player;
    private Transform sphereCenter;
    private int exitCount = 0;
    public RenderTexture RendererTexture;
    public GameObject CloudMan;
    public Transform[] SpawnLocations;
    void Start()
    {
        FindReferences();
        Player.transform.position = new Vector3(200f, 100f, -105f);
        Camera.main.targetTexture = RendererTexture;
        PlayerController player = Player.GetComponent<PlayerController>();
        player.canMove = true;
        player.canLook = true;
        player.canHearSound = true;
        player.canUseRevolver = true;

        if (sphereCenter == null)
        {
            sphereCenter = transform;
        }
    }
    private bool isSpawned = false;
    void Update()
    {
        if (exitCount >= 2 && !isSpawned)
        {
            int randomNumber = Random.Range(0, SpawnLocations.Length);
            CloudMan.transform.position = SpawnLocations[randomNumber].position;
            isSpawned = true;
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
        exitCount++;
    }
}
