using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAnim : MonoBehaviour
{
    public float speed;

    private void Update()
    {
        transform.Rotate(Vector3.right, Time.deltaTime * speed);
        transform.Rotate(Vector3.up, Time.deltaTime * speed * 2f);
    }
}