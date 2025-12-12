using System.Collections;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [Header("Movement")]
    public float moveSpeed = 3f;
    public float sprintSpeed = 5.5f;
    public float gravity = -9.81f;
    public float jumpHeight = 1f;
    public AudioSource WalkingSound;
    public AudioSource RunningSound;

    [Header("Mouse Look (Slow / Heavy Style)")]
    public float mouseSensitivity = 60f;
    public float lookSmoothVertical = 5f;
    public float lookSmoothHorizontal = 8f;

    [Header("Camera Effects")]
    public Transform cam;
    public float headBobAmount = 0.15f;
    public float headBobSpeed = 6f;
    public float cameraShakeAmount = 0.002f;

    [Header("🎥 Found Footage Camera Sway")]
    public float cameraSwayAmount = 0.12f;
    public float cameraSwaySpeed = 8f;
    public float cameraTiltAmount = 2.5f;
    public float breathingAmount = 0.02f;
    public float breathingSpeed = 1.5f;

    private float xRotation = 0f;
    private Vector3 camStartPos;
    private CharacterController controller;
    private Vector3 velocity;
    private float swayTimer = 0f;
    private float breathTimer = 0f;
    private float currentTilt = 0f;
    private float currentYRotation = 0f;

    private float moveX = 0f;
    private float moveZ = 0f;

    public bool canMove = true;
    public bool canLook = true;

    void Start()
    {
        controller = GetComponent<CharacterController>();

        if (cam == null)
        {
            return;
        }

        camStartPos = cam.localPosition;
        Cursor.lockState = CursorLockMode.Locked;

    }

    void Update()
    {
        if (cam == null) return;
        if (canLook)
        {
            Look();
            FoundFootageCameraMovement();
            CameraShake();
        }
        if (!canMove) return;
        Move();
        if (!canHearSound)
        {
            WalkingSound.Stop();
            RunningSound.Stop();
        }
    }


    void Look()
    {
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;

        xRotation -= mouseY;
        xRotation = Mathf.Clamp(xRotation, -80f, 80f);

        currentYRotation += mouseX;

        Quaternion targetCamRotation = Quaternion.Euler(xRotation, 0, currentTilt);
        cam.localRotation = Quaternion.Lerp(cam.localRotation, targetCamRotation, Time.deltaTime * lookSmoothVertical);

        Quaternion targetPlayerRotation = Quaternion.Euler(0, currentYRotation, 0);
        transform.rotation = Quaternion.Lerp(transform.rotation, targetPlayerRotation, Time.deltaTime * lookSmoothHorizontal);
    }
    public void SetRotation(float yRot)
    {
        currentYRotation = yRot;
        transform.rotation = Quaternion.Euler(0, yRot, 0);
    }

    public bool canHearSound = true;
    void Move()
    {
        moveX = Input.GetAxis("Horizontal");
        moveZ = Input.GetAxis("Vertical");

        float currentSpeed = Input.GetKey(KeyCode.LeftShift) ? sprintSpeed : moveSpeed;

        Vector3 move = transform.right * moveX + transform.forward * moveZ;
        controller.Move(move * currentSpeed * Time.deltaTime);

        if (controller.isGrounded && velocity.y < 0)
            velocity.y = -2f;

        if (Input.GetKeyDown(KeyCode.Space) && controller.isGrounded)
            velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);

        velocity.y += gravity * Time.deltaTime;
        controller.Move(velocity * Time.deltaTime);

        bool isMovingNow = Mathf.Abs(moveX) > 0.1f || Mathf.Abs(moveZ) > 0.1f;
        bool isSprintingNow = Input.GetKey(KeyCode.LeftShift);
        if (!isMovingNow && canHearSound)
        {
            if (WalkingSound.isPlaying) WalkingSound.Stop();
            if (RunningSound.isPlaying) RunningSound.Stop();
            return;
        }
        if (isSprintingNow && canHearSound)
        {
            if (!RunningSound.isPlaying) RunningSound.Play();
            if (WalkingSound.isPlaying) WalkingSound.Stop();
        }
        else
        {
            if (!WalkingSound.isPlaying) WalkingSound.Play();
            if (RunningSound.isPlaying) RunningSound.Stop();
        }
    }

    void FoundFootageCameraMovement()
    {
        bool isMoving = Mathf.Abs(moveX) > 0.01f || Mathf.Abs(moveZ) > 0.01f;
        bool isSprinting = Input.GetKey(KeyCode.LeftShift);

        if (isMoving)
        {
            float speedMultiplier = isSprinting ? 2f : 1f;
            swayTimer += Time.deltaTime * cameraSwaySpeed * speedMultiplier;

            float verticalSway = Mathf.Sin(swayTimer) * headBobAmount * (isSprinting ? 1.8f : 1f);
            float horizontalSway = Mathf.Sin(swayTimer * 0.5f) * cameraSwayAmount * (isSprinting ? 1.5f : 1f);
            float targetTilt = Mathf.Sin(swayTimer * 0.5f) * cameraTiltAmount * (isSprinting ? 1.8f : 1f);

            currentTilt = Mathf.Lerp(currentTilt, targetTilt, Time.deltaTime * 8f);

            Vector3 targetPos = camStartPos + new Vector3(horizontalSway, verticalSway, 0);
            cam.localPosition = targetPos;

            breathTimer = 0f;
        }
        else
        {
            breathTimer += Time.deltaTime * breathingSpeed;
            float breathEffect = Mathf.Sin(breathTimer) * breathingAmount;

            Vector3 targetPos = camStartPos + new Vector3(0, breathEffect, 0);
            cam.localPosition = Vector3.Lerp(cam.localPosition, targetPos, Time.deltaTime * 3f);

            currentTilt = Mathf.Lerp(currentTilt, 0f, Time.deltaTime * 5f);
        }
    }

    void CameraShake()
    {
        cam.localPosition += new Vector3(
            Random.Range(-cameraShakeAmount, cameraShakeAmount),
            Random.Range(-cameraShakeAmount, cameraShakeAmount),
            0
        );
    }
    public void StartShake(float amount)
    {
        cameraShakeAmount = amount;
    }

    public void StopShake()
    {
        cameraShakeAmount = 0f;
    }
}