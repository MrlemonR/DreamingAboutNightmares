using UnityEngine;

public class EyeBehaviour : MonoBehaviour
{
    public GameObject player;
    public float moveSpeed = 0.8f;
    public float stopDistance = 2f;
    public float fadeStartDistance = 5f;
    public EyeSpawner spawner;
    public Renderer eyeRenderer;
    public Transform eyeRoot;

    Material mat;

    void Start()
    {
        mat = eyeRenderer.material;
        Color c = mat.color;
        c.a = 1f;
        mat.color = c;
    }

    void Update()
    {
        float dist = Vector3.Distance(transform.position, player.transform.position);

        if (dist > stopDistance)
        {
            Vector3 directionToPlayer = player.transform.position - transform.position;
            transform.rotation = Quaternion.LookRotation(-directionToPlayer);
            transform.position = Vector3.MoveTowards(transform.position, player.transform.position, moveSpeed * Time.deltaTime);

            float fadeFactor = Mathf.Clamp01((fadeStartDistance - dist) / (fadeStartDistance - stopDistance));
            Color c = mat.color;
            c.a = 1f - fadeFactor;
            mat.color = c;
        }
        else
        {
            spawner.activeEyes.Remove(gameObject);
            spawner.CheckIfFinished();
            Destroy(gameObject);
        }
    }
}
