using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;
using TMPro;
public class SelectToShoot : MonoBehaviour
{
    public Camera cam;
    public GameObject Player;
    public GameObject revolver;
    public Transform[] LookPositions; //1: Head, 2: Hands, 3: Legs
    public Transform[] MovePositions; //1: Head, 2: Hands, 3: Legs
    public TMP_Text[] Texts; //1: Head, 2: Hands, 3: Legs
    public GameObject[] Rooms;
    public GameObject ShotExplosion;
    public AudioSource EmptySound;
    public AudioSource ShotSound;
    public AudioSource[] AfterShotSounds;

    bool textcourtinestart = false;
    void Start()
    {
        StartCoroutine(TextActive(0f, 0f));
        ShotExplosion.GetComponent<MeshRenderer>().material.color = new Color(1f, 1f, 1f, 0f);
    }
    void Update()
    {
        if (revolver.GetComponent<Revolver>().selfAimMode)
        {
            if (!textcourtinestart) StartCoroutine(TextActive(1f, 0.3f));
            mouseHover();
            RevolverShakeByTarget();
        }
        else
        {
            if (!textcourtinestart) StartCoroutine(TextActive(0f, 0.3f));
        }
    }
    void mouseHover()
    {
        float DistanceHead = Vector3.Distance(Input.mousePosition, Texts[0].transform.position);
        float DistanceHand = Vector3.Distance(Input.mousePosition, Texts[1].transform.position);
        float DistanceLeg = Vector3.Distance(Input.mousePosition, Texts[2].transform.position);
        AimTarget newTarget = AimTarget.None;
        if (DistanceHead < 60f)
        {
            newTarget = AimTarget.Head;
        }
        if (DistanceHand < 200f)
        {
            newTarget = AimTarget.Arm;
        }
        if (DistanceLeg < 60f)
        {
            newTarget = AimTarget.Leg;
        }

        if (newTarget != currentTarget)
        {
            currentTarget = newTarget;
            if (currentTarget != AimTarget.None)
            {
                int index = TargetToIndex(currentTarget);
                StartCoroutine(RevolverLookAt(index));
                StartCoroutine(RevolverMoveTo(index));
                StartCoroutine(TextColorChange(index));
            }
        }
        if (Input.GetMouseButtonDown(0))
        {
            StartCoroutine(ShootSelf());
        }
    }
    IEnumerator ShootSelf()
    {
        Reload reload = gameObject.GetComponent<Reload>();
        if (reload.currentBullet != null)
        {
            Revolver revo = gameObject.GetComponent<Revolver>();
            revo.selfAimMode = false;
            Cursor.lockState = CursorLockMode.Locked;
            ShotSound.Play();
            yield return new WaitForSeconds(0.2f);
            ShotSound.Stop();
            ShotExplosion.GetComponent<MeshRenderer>().material.color = new Color(1f, 1f, 1f, 1f);
            yield return new WaitForSeconds(1f);
            RevolverShake(0f);
            PlayerData player = Player.GetComponent<PlayerData>();
            player.LoadPlayer();
            if (player.SceneName == SceneManager.GetActiveScene().name)
            {
                LoadRoom(player.RoomNumber);
                BackInTimeEffect();
                reload.ExistBulletPos = 5;
                reload.DestroyBullet();
                reload.currentBullet = null;
                yield return new WaitForSeconds(1f);
                SaveSystem.DeleteSaveFile();

            }
            else
            {
                SceneManager.LoadScene(player.SceneName);
                BackInTimeEffect();
                reload.ExistBulletPos = 5;
                reload.DestroyBullet();
                reload.currentBullet = null;
                yield return new WaitForSeconds(1f);
                SaveSystem.DeleteSaveFile();
                yield break;
            }
        }
        else
        {
            EmptySound.Play();
        }
    }
    void LoadRoom(int index)
    {
        if (Rooms == null || Rooms.Length == 0) return;
        switch (index)
        {
            case 0:
                break;
            case 1:
                Rooms[0].SetActive(true);
                break;
            case 2:
                Rooms[1].SetActive(true);
                break;
            case 3:
                Rooms[2].SetActive(true);
                break;
        }
    }
    void BackInTimeEffect()
    {
        Revolver revo = gameObject.GetComponent<Revolver>();
        revo.CharacterMesh.SetActive(false);
        revo.RevoOpenCloseVis(false);
        StartCoroutine(revo.TextActive(false, 0f));
        Player.GetComponent<PlayerController>().canLook = true;
        Player.GetComponent<PlayerController>().canMove = true;
        StartCoroutine(FadeExplosion());
        StartCoroutine(ChangeFov());
        StartCoroutine(ChangeGamma());
        for (int i = 0; i < AfterShotSounds.Length; i++)
        {
            AfterShotSounds[i].Play();
        }
    }
    IEnumerator FadeExplosion()
    {
        Color startColor = new Color(1f, 1f, 1f, 1f);
        Color endColor = new Color(1f, 1f, 1f, 0f);
        float t = 0f;
        while (t < 2f)
        {
            t += Time.deltaTime;
            ShotExplosion.GetComponent<MeshRenderer>().material.color = Color.Lerp(startColor, endColor, t / 2f);
            yield return null;
        }
        ShotExplosion.GetComponent<MeshRenderer>().material.color = endColor;
    }
    IEnumerator ChangeGamma()
    {
        Color startColor = new Color(1.5f, 1.5f, 1.5f, 1f);
        Color endColor = new Color(0.566f, 0.566f, 0.566f, 1);
        RenderSettings.ambientLight = startColor;
        yield return new WaitForSeconds(1f);
        float t = 0f;
        while (t < 2f)
        {
            t += Time.deltaTime;
            RenderSettings.ambientLight = Color.Lerp(startColor, endColor, t / 2f);
            yield return null;
        }
        RenderSettings.ambientLight = endColor;
    }
    IEnumerator ChangeFov()
    {
        float startFov = 25f;
        float endFov = 60f;
        float duration = 1f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            Camera.main.fieldOfView = Mathf.Lerp(startFov, endFov, frac);
            yield return null;
        }
        Camera.main.fieldOfView = 60f;
    }
    int TargetToIndex(AimTarget target)
    {
        switch (target)
        {
            case AimTarget.Head: return 0;
            case AimTarget.Arm: return 1;
            case AimTarget.Leg: return 2;
            default: return 0;
        }
    }


    IEnumerator RevolverLookAt(int index)
    {
        Quaternion startRot = revolver.transform.localRotation;
        Quaternion endRot = LookPositions[index].localRotation;
        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float frac = t / duration;
            revolver.transform.localRotation = Quaternion.Slerp(startRot, endRot, frac);
            yield return null;
        }
        revolver.transform.localRotation = endRot;
    }

    IEnumerator RevolverMoveTo(int index)
    {
        Vector3 startPos = revolver.transform.localPosition;
        Vector3 endPos = MovePositions[index].localPosition;
        float duration = 0.5f;
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime; float frac = t / duration; revolver.transform.localPosition = Vector3.Slerp(startPos, endPos, frac);
            yield return null;
        }
        revolver.transform.localPosition = endPos;
    }

    IEnumerator TextActive(float targetAlpha, float targetSpeed)
    {
        textcourtinestart = true;
        float elapsed = 0f;
        float[] startAlphas = new float[Texts.Length];
        for (int i = 0; i < Texts.Length; i++)
        {
            startAlphas[i] = Texts[i].color.a;
        }
        while (elapsed < targetSpeed)
        {
            elapsed += Time.deltaTime;
            float frac = elapsed / targetSpeed;

            for (int i = 0; i < Texts.Length; i++)
            {
                float alpha = Mathf.Lerp(startAlphas[i], targetAlpha, frac);
                Texts[i].color = new Color(Texts[i].color.r, Texts[i].color.g, Texts[i].color.b, alpha);
            }
            yield return null;
        }
        for (int i = 0; i < Texts.Length; i++)
        {
            Texts[i].color = new Color(Texts[i].color.r, Texts[i].color.g, Texts[i].color.b, targetAlpha);
        }
        textcourtinestart = false;
    }
    IEnumerator TextColorChange(int selectedText)
    {
        float elapsed = 0f;
        Color[] startColors = new Color[Texts.Length];
        for (int i = 0; i < Texts.Length; i++)
        {
            startColors[i] = Texts[i].color;
        }
        while (elapsed < 0.3f)
        {
            elapsed += Time.deltaTime;
            float frac = elapsed / 0.3f;

            for (int i = 0; i < Texts.Length; i++)
            {
                Color targetColor = (i == selectedText) ? Color.red : Color.white;
                Texts[i].color = Color.Lerp(startColors[i], targetColor, frac);
            }
            yield return null;
        }
        for (int i = 0; i < Texts.Length; i++)
        {
            Texts[i].color = (i == selectedText) ? Color.red : Color.white;
        }
    }
    void RevolverShake(float ShakeAmout)
    {
        revolver.transform.localPosition += new Vector3(Random.Range(-ShakeAmout, ShakeAmout), 0, Random.Range(-ShakeAmout, ShakeAmout));
    }
    public enum AimTarget
    {
        None, Head, Arm, Leg
    }
    AimTarget currentTarget = AimTarget.None;
    void RevolverShakeByTarget()
    {
        switch (currentTarget)
        {
            case AimTarget.Head:
                RevolverShake(0.002f);
                break;
            case AimTarget.Arm:
                RevolverShake(0.001f);
                break;
            case AimTarget.Leg:
                RevolverShake(0.001f);
                break;
        }
    }
}