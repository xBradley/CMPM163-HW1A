using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveUD : MonoBehaviour
{
	int count = 0;
	bool up = true;
	
	// Update is called once per frame
	void Update()
	{

		if (up)
		{
			transform.Translate(Vector3.up * Time.deltaTime, Space.World);
			print(count);
			if (count < 200) ++count;
			else up = false;

		}
		else if (!up)
		{
			transform.Translate(Vector3.down * Time.deltaTime, Space.World);
			print(count);
			if (count > 0) --count;
			else up = true;
		}
	}
}
