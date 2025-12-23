using UnityEngine;

public class TerrainTrigger : MonoBehaviour
{
    public GameObject Terrain;
    public Camera cam;
    public Transform[] target;
    public float minDistance = 1f;
    public float maxDistance = 10f;
    public Material DarkSkybox;
    public Material originalSkybox;
    private Material tempSkybox;
    private bool changedToOriginal = false;
    void Start()
    {
        tempSkybox = new Material(originalSkybox);
        tempSkybox.SetColor("_Tint", DarkSkybox.GetColor("_Tint"));
        tempSkybox.SetFloat("_Exposure", DarkSkybox.GetFloat("_Exposure"));
        RenderSettings.skybox = tempSkybox;
    }
    void Update()
    {
        if (!Terrain.activeInHierarchy) return;
        float distance = Vector3.Distance(cam.transform.position, target[0].position);
        Vector3 dir = (target[0].position - cam.transform.position).normalized;
        float dot = Vector3.Dot(cam.transform.forward, dir);
        if (dot < 0.4f && distance > 7f)
        {
            foreach (var obj in target)obj.gameObject.SetActive(false);
        }
        if (!changedToOriginal)
        {
            float t = Mathf.InverseLerp(minDistance, maxDistance, distance);
            tempSkybox.SetColor("_Tint",Color.Lerp(DarkSkybox.GetColor("_Tint"), originalSkybox.GetColor("_Tint"), t));
            tempSkybox.SetFloat("_Exposure",Mathf.Lerp(DarkSkybox.GetFloat("_Exposure"), originalSkybox.GetFloat("_Exposure"), t));
            DynamicGI.UpdateEnvironment();
            if (t >= 1f)changedToOriginal = true;
        }
    }
}