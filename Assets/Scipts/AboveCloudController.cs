using UnityEngine;

public class AboveCloudController : MonoBehaviour
{
    private GameObject Player;
    public RenderTexture RendererTexture;

    void Start()
    {
        FindReferences();
        Player.transform.position = new Vector3(200f,100f,-105f);
        Camera.main.targetTexture = RendererTexture;
    }
    void FindReferences()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }
}
