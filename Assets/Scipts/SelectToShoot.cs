using UnityEngine;
using UnityEngine.EventSystems;

public class HoverOutline : MonoBehaviour
{
    public void OnPointerEnter(GameObject Outline)
    {
        Outline.SetActive(true);
        Debug.Log("bobmo");
    }

    public void OnPointerExit(GameObject Outline)
    {
        Outline.SetActive(false);
        Debug.Log("bobmo");
    }
}
