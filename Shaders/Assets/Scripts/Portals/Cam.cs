using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cam : MonoBehaviour
{
    [SerializeField] private Transform sphere;
    [SerializeField] private Transform portalInner;

    private Camera cam;
    private Vector3 portalStartRot;
    private Vector3 sphereStartRot;

    private Vector3 camRot;

    // Start is called before the first frame update
    void Start()
    {
        cam = Camera.main;

        portalStartRot = portalInner.rotation.eulerAngles;
        sphereStartRot = sphere.rotation.eulerAngles;
    }

    // Update is called once per frame
    void Update()
    {
        //camRot = cam.transform.rotation.eulerAngles;
        //camRot.x = Mathf.Clamp(camRot.x, 270, 90);
        //camRot.y = Mathf.Clamp(camRot.y, -25, 25);

        transform.rotation = Quaternion.Euler(camRot);


        Matrix4x4 m1 = sphere.transform.localToWorldMatrix * portalInner.transform.worldToLocalMatrix *
                       cam.transform.localToWorldMatrix;

        this.transform.SetPositionAndRotation(m1.GetColumn(3), m1.rotation);



        //if (camRot.y > 90 && camRot.y < 270)
        //{
        //    portalInner.rotation = Quaternion.Euler(new Vector3(portalStartRot.x, 0, portalStartRot.z));
        //    sphere.rotation = Quaternion.Euler(new Vector3(sphereStartRot.x, sphereStartRot.y +180, sphereStartRot.z));
        //}
        //else
        //{
        //    portalInner.rotation = Quaternion.Euler(new Vector3(portalStartRot.x, 180, portalStartRot.z));
        //    sphere.rotation = Quaternion.Euler(new Vector3(sphereStartRot.x, sphereStartRot.y, sphereStartRot.z));
        //}
    }
}
