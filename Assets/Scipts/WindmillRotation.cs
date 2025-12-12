using System.Collections;
using UnityEngine;
using Unity.Mathematics;

public class WindmillRotation : MonoBehaviour
{
    public GameObject Windmill;
    private float rotation = 0f;

    void Start()
    {
        StartCoroutine(Rotation());
    }

    IEnumerator Rotation()
    {
        while (true)
        {
            Windmill.transform.localRotation = Quaternion.Euler(Windmill.transform.localEulerAngles.x,Windmill.transform.localEulerAngles.y,rotation);

            rotation = rotation + 1f;
            if (rotation >= 360) rotation = 0;

            yield return new WaitForSeconds(0.009f);
        }
    }
}
